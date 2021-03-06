; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+v -verify-machineinstrs -stop-after=finalize-isel < %s | FileCheck %s

; This test makes sure we match FrameIndex into the base address.
; Done as a MIR test because eliminateFrameIndex will likely turn it
; back into an addi.

declare void @llvm.riscv.vse.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>*,
  i64);

define i64 @test(<vscale x 1 x i64> %0) nounwind {
  ; CHECK-LABEL: name: test
  ; CHECK: bb.0.entry:
  ; CHECK-NEXT:   liveins: $v8
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:vr = COPY $v8
  ; CHECK-NEXT:   [[ADDI:%[0-9]+]]:gpr = ADDI %stack.0.a, 0
  ; CHECK-NEXT:   PseudoVSE64_V_M1 [[COPY]], killed [[ADDI]], 1, 6 /* e64 */
  ; CHECK-NEXT:   [[LD:%[0-9]+]]:gpr = LD %stack.0.a, 0 :: (dereferenceable load (s64) from %ir.a)
  ; CHECK-NEXT:   $x10 = COPY [[LD]]
  ; CHECK-NEXT:   PseudoRET implicit $x10
entry:
  %a = alloca i64
  %b = bitcast i64* %a to <vscale x 1 x i64>*
  call void @llvm.riscv.vse.nxv1i64(
    <vscale x 1 x i64> %0,
    <vscale x 1 x i64>* %b,
    i64 1)
  %c = load i64, i64* %a
  ret i64 %c
}
