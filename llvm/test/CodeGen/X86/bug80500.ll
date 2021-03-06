; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686 -mcpu=skylake | FileCheck %s

; Fix for a typo introduced by D80500

define i32 @load_fold_udiv1(ptr %p) {
; CHECK-LABEL: load_fold_udiv1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl $-2004318071, %edx # imm = 0x88888889
; CHECK-NEXT:    mulxl (%eax), %eax, %eax
; CHECK-NEXT:    shrl $3, %eax
; CHECK-NEXT:    retl
  %v = load i32, ptr %p, align 4
  %ret = udiv i32 %v, 15
  ret i32 %ret
}
