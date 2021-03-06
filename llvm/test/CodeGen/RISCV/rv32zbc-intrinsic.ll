; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+zbc -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32ZBC

declare i32 @llvm.riscv.clmulr.i32(i32 %a, i32 %b)

define i32 @clmul32r(i32 %a, i32 %b) nounwind {
; RV32ZBC-LABEL: clmul32r:
; RV32ZBC:       # %bb.0:
; RV32ZBC-NEXT:    clmulr a0, a0, a1
; RV32ZBC-NEXT:    ret
  %tmp = call i32 @llvm.riscv.clmulr.i32(i32 %a, i32 %b)
  ret i32 %tmp
}
