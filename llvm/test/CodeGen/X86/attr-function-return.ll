; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=i386-linux-gnu %s -o - -verify-machineinstrs \
; RUN:   | FileCheck %s
; RUN: llc --mtriple=x86_64-linux-gnu %s -o - -verify-machineinstrs \
; RUN:   | FileCheck %s
define void @x() fn_ret_thunk_extern {
; CHECK-LABEL: x:
; CHECK:       # %bb.0:
; CHECK-NEXT:    jmp __x86_return_thunk
  ret void
}
