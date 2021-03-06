; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s

define void @bar(ptr %p, <2 x i64> %x) nounwind {
; CHECK-LABEL: bar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps %xmm0, (%rdi)
; CHECK-NEXT:    retq
  store <2 x i64> %x, ptr %p
  ret void
}
