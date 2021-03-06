; FIXME: Targets below should support this builtin after they document the thread pointer for X86.
; CHECK-ERROR: LLVM ERROR: Target OS doesn't support __builtin_thread_pointer() yet.

; RUN: not --crash llc < %s -o /dev/null -mtriple=i686-pc-win32 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR
; RUN: not --crash llc < %s -o /dev/null -mtriple=x86_64-pc-win32 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR
; RUN: not --crash llc < %s -o /dev/null -mtriple=i686-pc-windows-gnu 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR
; RUN: not --crash llc < %s -o /dev/null -mtriple=x86_64-pc-windows-gnu 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR
; RUN: not --crash llc < %s -o /dev/null -mtriple=i686-apple-darwin 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR
; RUN: not --crash llc < %s -o /dev/null -mtriple=x86_64-pc-apple-darwin 2>&1 | FileCheck %s --check-prefix=CHECK-ERROR

declare ptr @llvm.thread.pointer()

define ptr @thread_pointer() nounwind {
  %1 = tail call ptr @llvm.thread.pointer()
  ret ptr %1
}
