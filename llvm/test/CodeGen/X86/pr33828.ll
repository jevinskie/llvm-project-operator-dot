; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mcpu=haswell | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=haswell | FileCheck %s --check-prefix=X64

@var_580 = external dso_local local_unnamed_addr global i8, align 1

define void @foo(i8 %a0) {
; X86-LABEL: foo:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movsbl var_580, %eax
; X86-NEXT:    testl $-536870913, %eax # imm = 0xDFFFFFFF
; X86-NEXT:    jne .LBB0_1
; X86-NEXT:  # %bb.2: # %if.end13
; X86-NEXT:    retl
; X86-NEXT:  .LBB0_1: # %if.then11
;
; X64-LABEL: foo:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movsbl var_580(%rip), %eax
; X64-NEXT:    testl $-536870913, %eax # imm = 0xDFFFFFFF
; X64-NEXT:    jne .LBB0_1
; X64-NEXT:  # %bb.2: # %if.end13
; X64-NEXT:    retq
; X64-NEXT:  .LBB0_1: # %if.then11
entry:
  %tmp = icmp ugt i8 %a0, 60
  %phitmp = zext i1 %tmp to i16
  br label %if.end

if.end:
  %tmp1 = load i8, ptr @var_580, align 1
  %conv7 = sext i8 %tmp1 to i32
  %conv8 = zext i16 %phitmp to i32
  %mul = shl nuw nsw i32 %conv8, 1
  %div9 = udiv i32 %mul, 71
  %sub = add nsw i32 %div9, -3
  %shl = shl i32 1, %sub
  %neg = xor i32 %shl, -1
  %and = and i32 %neg, %conv7
  %tobool10 = icmp eq i32 %and, 0
  br i1 %tobool10, label %if.end13, label %if.then11

if.then11:
  unreachable

if.end13:
  ret void
}
