//===-- Debug.cpp - An easy way to add debug output to your code ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements a handy way of adding debugging information to your
// code, without it being enabled all of the time, and without having to add
// command line options to enable it.
//
// In particular, just wrap your code with the LLVM_DEBUG() macro, and it will
// be enabled automatically if you specify '-debug' on the command-line.
// Alternatively, you can also use the SET_DEBUG_TYPE("foo") macro to specify
// that your debug code belongs to class "foo".  Then, on the command line, you
// can specify '-debug-only=foo' to enable JUST the debug information for the
// foo class.
//
// When compiling without assertions, the -debug-* options and all code in
// LLVM_DEBUG() statements disappears, so it does not affect the runtime of the
// code.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/Debug.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/circular_raw_ostream.h"
#include "llvm/Support/raw_ostream.h"

#include "DebugOptions.h"

#undef isCurrentDebugType
#undef setCurrentDebugType
#undef setCurrentDebugTypes
#undef isRunningUnderDebugger
#undef debugtrap
#undef unconditional_debugtrap

using namespace llvm;

// Even though LLVM might be built with NDEBUG, define symbols that the code
// built without NDEBUG can depend on via the llvm/Support/Debug.h header.
namespace llvm {
/// Exported boolean set by the -debug option.
bool DebugFlag = false;

static ManagedStatic<std::vector<std::string>> CurrentDebugType;

/// Return true if the specified string is the debug type
/// specified on the command line, or if none was specified on the command line
/// with the -debug-only=X option.
bool isCurrentDebugType(const char *DebugType) {
  if (CurrentDebugType->empty())
    return true;
  // See if DebugType is in list. Note: do not use find() as that forces us to
  // unnecessarily create an std::string instance.
  for (auto &d : *CurrentDebugType) {
    if (d == DebugType)
      return true;
  }
  return false;
}

/// Set the current debug type, as if the -debug-only=X
/// option were specified.  Note that DebugFlag also needs to be set to true for
/// debug output to be produced.
///
void setCurrentDebugTypes(const char **Types, unsigned Count);

void setCurrentDebugType(const char *Type) {
  setCurrentDebugTypes(&Type, 1);
}

void setCurrentDebugTypes(const char **Types, unsigned Count) {
  CurrentDebugType->clear();
  for (size_t T = 0; T < Count; ++T)
    CurrentDebugType->push_back(Types[T]);
}

#ifdef __APPLE__
#include <cassert>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <unistd.h>
#elif defined(__linux__)
#include <cassert>
#include <cstring>
#include <fcntl.h>
#include <unistd.h>
#endif
bool isRunningUnderDebugger() {
#ifdef __APPLE__
  int junk;
  int mib[4];
  struct kinfo_proc info;
  size_t size;

  // Initialize the flags so that, if sysctl fails for some bizarre
  // reason, we get a predictable result.

  info.kp_proc.p_flag = 0;

  // Initialize mib, which tells sysctl the info we want, in this case
  // we're looking for information about a specific process ID.

  mib[0] = CTL_KERN;
  mib[1] = KERN_PROC;
  mib[2] = KERN_PROC_PID;
  mib[3] = getpid();

  // Call sysctl.

  size = sizeof(info);
  junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
  assert(junk == 0);

  // We're being debugged if the P_TRACED flag is set.

  return ((info.kp_proc.p_flag & P_TRACED) != 0);
#elif defined(__linux__)
    static int status_fd = -1;
    if (status_fd < 0) {
        status_fd = open("/proc/self/status", O_RDONLY);
        assert(status_fd >= 0);
    }
    assert(lseek(status_fd, 0, SEEK_SET) == 0);
    char buf[1024];
    assert(read(status_fd, buf, sizeof(buf)) > 0);
    buf[sizeof(buf) - 1] = '\0';
    return !strstr(buf, "\nTracerPid:\t0\n");
#else
#error "platform not supported"
  return false;
#endif
}

void unconditional_debugtrap() {
#if __has_builtin(__builtin_trap)
  __builtin_debugtrap();
#else
#error "platform not supported"
#endif
}

void debugtrap() {
  if (!isRunningUnderDebugger()) {
    return;
  }
  __builtin_debugtrap();
}

void debugtrap_target() { return; }

} // namespace llvm

// All Debug.h functionality is a no-op in NDEBUG mode.
#ifndef NDEBUG

namespace {
struct CreateDebug {
  static void *call() {
    return new cl::opt<bool, true>("debug", cl::desc("Enable debug output"),
                                   cl::Hidden, cl::location(DebugFlag));
  }
};

// -debug-buffer-size - Buffer the last N characters of debug output
//until program termination.
struct CreateDebugBufferSize {
  static void *call() {
    return new cl::opt<unsigned>(
        "debug-buffer-size",
        cl::desc("Buffer the last N characters of debug output "
                 "until program termination. "
                 "[default 0 -- immediate print-out]"),
        cl::Hidden, cl::init(0));
  }
};
} // namespace

// -debug - Command line option to enable the DEBUG statements in the passes.
// This flag may only be enabled in debug builds.
static ManagedStatic<cl::opt<bool, true>, CreateDebug> Debug;
static ManagedStatic<cl::opt<unsigned>, CreateDebugBufferSize> DebugBufferSize;

namespace {

struct DebugOnlyOpt {
  void operator=(const std::string &Val) const {
    if (Val.empty())
      return;
    DebugFlag = true;
    SmallVector<StringRef,8> dbgTypes;
    StringRef(Val).split(dbgTypes, ',', -1, false);
    for (auto dbgType : dbgTypes)
      CurrentDebugType->push_back(std::string(dbgType));
  }
};
} // namespace

static DebugOnlyOpt DebugOnlyOptLoc;

namespace {
struct CreateDebugOnly {
  static void *call() {
    return new cl::opt<DebugOnlyOpt, true, cl::parser<std::string>>(
        "debug-only",
        cl::desc("Enable a specific type of debug output (comma separated list "
                 "of types)"),
        cl::Hidden, cl::value_desc("debug string"),
        cl::location(DebugOnlyOptLoc), cl::ValueRequired);
  }
};
} // namespace

static ManagedStatic<cl::opt<DebugOnlyOpt, true, cl::parser<std::string>>,
                     CreateDebugOnly>
    DebugOnly;

void llvm::initDebugOptions() {
  *Debug;
  *DebugBufferSize;
  *DebugOnly;
}

// Signal handlers - dump debug output on termination.
static void debug_user_sig_handler(void *Cookie) {
  // This is a bit sneaky.  Since this is under #ifndef NDEBUG, we
  // know that debug mode is enabled and dbgs() really is a
  // circular_raw_ostream.  If NDEBUG is defined, then dbgs() ==
  // errs() but this will never be invoked.
  llvm::circular_raw_ostream &dbgout =
      static_cast<circular_raw_ostream &>(llvm::dbgs());
  dbgout.flushBufferWithBanner();
}

/// dbgs - Return a circular-buffered debug stream.
raw_ostream &llvm::dbgs() {
  // Do one-time initialization in a thread-safe way.
  static struct dbgstream {
    circular_raw_ostream strm;

    dbgstream()
        : strm(errs(), "*** Debug Log Output ***\n",
               (!EnableDebugBuffering || !DebugFlag) ? 0 : *DebugBufferSize) {
      if (EnableDebugBuffering && DebugFlag && *DebugBufferSize != 0)
        // TODO: Add a handler for SIGUSER1-type signals so the user can
        // force a debug dump.
        sys::AddSignalHandler(&debug_user_sig_handler, nullptr);
      // Otherwise we've already set the debug stream buffer size to
      // zero, disabling buffering so it will output directly to errs().
    }
  } thestrm;

  return thestrm.strm;
}

#else
// Avoid "has no symbols" warning.
namespace llvm {
  /// dbgs - Return errs().
  raw_ostream &dbgs() {
    return errs();
  }
}
void llvm::initDebugOptions() {}
#endif

/// EnableDebugBuffering - Turn on signal handler installation.
///
bool llvm::EnableDebugBuffering = false;
