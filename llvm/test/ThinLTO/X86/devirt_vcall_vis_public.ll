; REQUIRES: x86-registered-target

; Test devirtualization through the thin link and backend, when vtables
; have vcall_visibility metadata with public visibility.

; Index based WPD
; Generate unsplit module with summary for ThinLTO index-based WPD.
; RUN: opt -thinlto-bc -o %t2.o %s
; RUN: llvm-lto2 run %t2.o -save-temps -pass-remarks=. \
; RUN:   -whole-program-visibility \
; RUN:   -o %t3 \
; RUN:   -r=%t2.o,test,px \
; RUN:   -r=%t2.o,_ZN1A1nEi,p \
; RUN:   -r=%t2.o,_ZN1B1fEi,p \
; RUN:   -r=%t2.o,_ZN1C1fEi,p \
; RUN:   -r=%t2.o,_ZN1D1mEi,p \
; RUN:   -r=%t2.o,_ZTV1B,px \
; RUN:   -r=%t2.o,_ZTV1C,px \
; RUN:   -r=%t2.o,_ZTV1D,px 2>&1 | FileCheck %s --check-prefix=REMARK
; RUN: llvm-dis %t3.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-IR

; Hybrid WPD
; Generate split module with summary for hybrid Thin/Regular LTO WPD.
; RUN: opt -thinlto-bc -thinlto-split-lto-unit -o %t.o %s
; FIXME: Fix machine verifier issues and remove -verify-machineinstrs=0. PR39436.
; RUN: llvm-lto2 run %t.o -save-temps -pass-remarks=. \
; RUN:   -whole-program-visibility \
; RUN:   -verify-machineinstrs=0 \
; RUN:   -o %t3 \
; RUN:   -r=%t.o,test,px \
; RUN:   -r=%t.o,_ZN1A1nEi,p \
; RUN:   -r=%t.o,_ZN1B1fEi,p \
; RUN:   -r=%t.o,_ZN1C1fEi,p \
; RUN:   -r=%t.o,_ZN1D1mEi,p \
; RUN:   -r=%t.o,_ZTV1B, \
; RUN:   -r=%t.o,_ZTV1C, \
; RUN:   -r=%t.o,_ZTV1D, \
; RUN:   -r=%t.o,_ZN1A1nEi, \
; RUN:   -r=%t.o,_ZN1B1fEi, \
; RUN:   -r=%t.o,_ZN1C1fEi, \
; RUN:   -r=%t.o,_ZN1D1mEi, \
; RUN:   -r=%t.o,_ZTV1B,px \
; RUN:   -r=%t.o,_ZTV1C,px \
; RUN:   -r=%t.o,_ZTV1D,px 2>&1 | FileCheck %s --check-prefix=REMARK --dump-input=fail
; RUN: llvm-dis %t3.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-IR

; Regular LTO WPD
; RUN: opt -o %t4.o %s
; RUN: llvm-lto2 run %t4.o -save-temps -pass-remarks=. \
; RUN:   -whole-program-visibility \
; RUN:   -o %t5 \
; RUN:   -r=%t4.o,test,px \
; RUN:   -r=%t4.o,_ZN1A1nEi,p \
; RUN:   -r=%t4.o,_ZN1B1fEi,p \
; RUN:   -r=%t4.o,_ZN1C1fEi,p \
; RUN:   -r=%t4.o,_ZN1D1mEi,p \
; RUN:   -r=%t4.o,_ZTV1B,px \
; RUN:   -r=%t4.o,_ZTV1C,px \
; RUN:   -r=%t4.o,_ZTV1D,px 2>&1 | FileCheck %s --check-prefix=REMARK
; RUN: llvm-dis %t5.0.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-IR

; REMARK-DAG: single-impl: devirtualized a call to _ZN1A1nEi
; REMARK-DAG: single-impl: devirtualized a call to _ZN1D1mEi

; Try everything again but without -whole-program-visibility to confirm
; WPD fails

; Index based WPD
; RUN: llvm-lto2 run %t2.o -save-temps -pass-remarks=. \
; RUN:   -o %t3 \
; RUN:   -r=%t2.o,test,px \
; RUN:   -r=%t2.o,_ZN1A1nEi,p \
; RUN:   -r=%t2.o,_ZN1B1fEi,p \
; RUN:   -r=%t2.o,_ZN1C1fEi,p \
; RUN:   -r=%t2.o,_ZN1D1mEi,p \
; RUN:   -r=%t2.o,_ZTV1B,px \
; RUN:   -r=%t2.o,_ZTV1C,px \
; RUN:   -r=%t2.o,_ZTV1D,px 2>&1 | FileCheck %s --implicit-check-not single-impl --allow-empty
; RUN: llvm-dis %t3.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-NODEVIRT-IR

; Hybrid WPD
; RUN: llvm-lto2 run %t.o -save-temps -pass-remarks=. \
; RUN:   -verify-machineinstrs=0 \
; RUN:   -o %t3 \
; RUN:   -r=%t.o,test,px \
; RUN:   -r=%t.o,_ZN1A1nEi,p \
; RUN:   -r=%t.o,_ZN1B1fEi,p \
; RUN:   -r=%t.o,_ZN1C1fEi,p \
; RUN:   -r=%t.o,_ZN1D1mEi,p \
; RUN:   -r=%t.o,_ZTV1B, \
; RUN:   -r=%t.o,_ZTV1C, \
; RUN:   -r=%t.o,_ZTV1D, \
; RUN:   -r=%t.o,_ZN1A1nEi, \
; RUN:   -r=%t.o,_ZN1B1fEi, \
; RUN:   -r=%t.o,_ZN1C1fEi, \
; RUN:   -r=%t.o,_ZN1D1mEi, \
; RUN:   -r=%t.o,_ZTV1B,px \
; RUN:   -r=%t.o,_ZTV1C,px \
; RUN:   -r=%t.o,_ZTV1D,px 2>&1 | FileCheck %s --implicit-check-not single-impl --allow-empty
; RUN: llvm-dis %t3.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-NODEVIRT-IR

; Regular LTO WPD
; RUN: llvm-lto2 run %t4.o -save-temps -pass-remarks=. \
; RUN:   -o %t5 \
; RUN:   -r=%t4.o,test,px \
; RUN:   -r=%t4.o,_ZN1A1nEi,p \
; RUN:   -r=%t4.o,_ZN1B1fEi,p \
; RUN:   -r=%t4.o,_ZN1C1fEi,p \
; RUN:   -r=%t4.o,_ZN1D1mEi,p \
; RUN:   -r=%t4.o,_ZTV1B,px \
; RUN:   -r=%t4.o,_ZTV1C,px \
; RUN:   -r=%t4.o,_ZTV1D,px 2>&1 | FileCheck %s --implicit-check-not single-impl --allow-empty
; RUN: llvm-dis %t5.0.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-NODEVIRT-IR

; Try index-based WPD again with both -whole-program-visibility and
; -disable-whole-program-visibility to confirm the latter overrides
; the former and that WPD fails.
; RUN: llvm-lto2 run %t2.o -save-temps -pass-remarks=. \
; RUN:   -whole-program-visibility \
; RUN:   -disable-whole-program-visibility \
; RUN:   -o %t3 \
; RUN:   -r=%t2.o,test,px \
; RUN:   -r=%t2.o,_ZN1A1nEi,p \
; RUN:   -r=%t2.o,_ZN1B1fEi,p \
; RUN:   -r=%t2.o,_ZN1C1fEi,p \
; RUN:   -r=%t2.o,_ZN1D1mEi,p \
; RUN:   -r=%t2.o,_ZTV1B,px \
; RUN:   -r=%t2.o,_ZTV1C,px \
; RUN:   -r=%t2.o,_ZTV1D,px 2>&1 | FileCheck %s --implicit-check-not single-impl --allow-empty
; RUN: llvm-dis %t3.1.4.opt.bc -o - | FileCheck %s --check-prefix=CHECK-NODEVIRT-IR

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-grtev4-linux-gnu"

%struct.A = type { i32 (...)** }
%struct.B = type { %struct.A }
%struct.C = type { %struct.A }
%struct.D = type { i32 (...)** }

@_ZTV1B = constant { [4 x i8*] } { [4 x i8*] [i8* null, i8* undef, i8* bitcast (i32 (%struct.B*, i32)* @_ZN1B1fEi to i8*), i8* bitcast (i32 (%struct.A*, i32)* @_ZN1A1nEi to i8*)] }, !type !0, !type !1, !vcall_visibility !5
@_ZTV1C = constant { [4 x i8*] } { [4 x i8*] [i8* null, i8* undef, i8* bitcast (i32 (%struct.C*, i32)* @_ZN1C1fEi to i8*), i8* bitcast (i32 (%struct.A*, i32)* @_ZN1A1nEi to i8*)] }, !type !0, !type !2, !vcall_visibility !5
@_ZTV1D = constant { [3 x i8*] } { [3 x i8*] [i8* null, i8* undef, i8* bitcast (i32 (%struct.D*, i32)* @_ZN1D1mEi to i8*)] }, !type !3, !vcall_visibility !5


; CHECK-IR-LABEL: define i32 @test
define i32 @test(%struct.A* %obj, %struct.D* %obj2, i32 %a) {
entry:
  %0 = bitcast %struct.A* %obj to i8***
  %vtable = load i8**, i8*** %0
  %1 = bitcast i8** %vtable to i8*
  %p = call i1 @llvm.type.test(i8* %1, metadata !"_ZTS1A")
  call void @llvm.assume(i1 %p)
  %fptrptr = getelementptr i8*, i8** %vtable, i32 1
  %2 = bitcast i8** %fptrptr to i32 (%struct.A*, i32)**
  %fptr1 = load i32 (%struct.A*, i32)*, i32 (%struct.A*, i32)** %2, align 8

  ; Check that the call was devirtualized.
  ; CHECK-IR: %call = tail call i32 @_ZN1A1nEi
  ; CHECK-NODEVIRT-IR: %call = tail call i32 %fptr1
  %call = tail call i32 %fptr1(%struct.A* nonnull %obj, i32 %a)

  %3 = bitcast i8** %vtable to i32 (%struct.A*, i32)**
  %fptr22 = load i32 (%struct.A*, i32)*, i32 (%struct.A*, i32)** %3, align 8

  ; We still have to call it as virtual.
  ; CHECK-IR: %call3 = tail call i32 %fptr22
  ; CHECK-NODEVIRT-IR: %call3 = tail call i32 %fptr22
  %call3 = tail call i32 %fptr22(%struct.A* nonnull %obj, i32 %call)

  %4 = bitcast %struct.D* %obj2 to i8***
  %vtable2 = load i8**, i8*** %4
  %5 = bitcast i8** %vtable2 to i8*
  %p2 = call i1 @llvm.type.test(i8* %5, metadata !4)
  call void @llvm.assume(i1 %p2)

  %6 = bitcast i8** %vtable2 to i32 (%struct.D*, i32)**
  %fptr33 = load i32 (%struct.D*, i32)*, i32 (%struct.D*, i32)** %6, align 8

  ; Check that the call was devirtualized.
  ; CHECK-IR: %call4 = tail call i32 @_ZN1D1mEi
  ; CHECK-NODEVIRT-IR: %call4 = tail call i32 %fptr33
  %call4 = tail call i32 %fptr33(%struct.D* nonnull %obj2, i32 %call3)
  ret i32 %call4
}
; CHECK-IR-LABEL: ret i32
; CHECK-IR-LABEL: }

declare i1 @llvm.type.test(i8*, metadata)
declare void @llvm.assume(i1)

define i32 @_ZN1B1fEi(%struct.B* %this, i32 %a) #0 {
   ret i32 0;
}

define i32 @_ZN1A1nEi(%struct.A* %this, i32 %a) #0 {
   ret i32 0;
}

define i32 @_ZN1C1fEi(%struct.C* %this, i32 %a) #0 {
   ret i32 0;
}

define i32 @_ZN1D1mEi(%struct.D* %this, i32 %a) #0 {
   ret i32 0;
}

; Make sure we don't inline or otherwise optimize out the direct calls.
attributes #0 = { noinline optnone }

!0 = !{i64 16, !"_ZTS1A"}
!1 = !{i64 16, !"_ZTS1B"}
!2 = !{i64 16, !"_ZTS1C"}
!3 = !{i64 16, !4}
!4 = distinct !{}
!5 = !{i64 0}
