; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+tbm | FileCheck %s

define i64 @test_x86_tbm_bextri_u64(i64 %a) nounwind readnone {
; CHECK-LABEL: test_x86_tbm_bextri_u64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    bextrq $3841, %rdi, %rax # imm = 0xF01
; CHECK-NEXT:    retq
entry:
  %0 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 %a, i64 3841)
  ret i64 %0
}

declare i64 @llvm.x86.tbm.bextri.u64(i64, i64) nounwind readnone

define i64 @test_x86_tbm_bextri_u64_m(ptr nocapture %a) nounwind readonly {
; CHECK-LABEL: test_x86_tbm_bextri_u64_m:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    bextrq $3841, (%rdi), %rax # imm = 0xF01
; CHECK-NEXT:    retq
entry:
  %tmp1 = load i64, ptr %a, align 8
  %0 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 %tmp1, i64 3841)
  ret i64 %0
}

define i64 @test_x86_tbm_bextri_u64_bigint(i64 %a) nounwind readnone {
; CHECK-LABEL: test_x86_tbm_bextri_u64_bigint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    bextrq $65535, %rdi, %rax # imm = 0xFFFF
; CHECK-NEXT:    retq
entry:
  %0 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 %a, i64 549755813887)
  ret i64 %0
}

define i64 @test_x86_tbm_bextri_u64_z(i64 %a, i64 %b) nounwind readnone {
; CHECK-LABEL: test_x86_tbm_bextri_u64_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    bextrq $3841, %rdi, %rax # imm = 0xF01
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    retq
entry:
  %0 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 %a, i64 3841)
  %1 = icmp eq i64 %0, 0
  %2 = select i1 %1, i64 %b, i64 %0
  ret i64 %2
}
