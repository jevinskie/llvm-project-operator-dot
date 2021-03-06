; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mcpu=skx | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=skx | FileCheck %s --check-prefix=X64

; Check for assert in foldMaskAndShiftToScale due to out of range mask scaling.

@b = common dso_local global i8 zeroinitializer, align 1
@c = common dso_local global i8 zeroinitializer, align 1
@d = common dso_local global i64 zeroinitializer, align 8
@e = common dso_local global i64 zeroinitializer, align 8

define dso_local void @foo(i64 %x) nounwind {
; X86-LABEL: foo:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    movl d+4, %eax
; X86-NEXT:    notl %eax
; X86-NEXT:    movl d, %ecx
; X86-NEXT:    notl %ecx
; X86-NEXT:    andl $-566231040, %ecx # imm = 0xDE400000
; X86-NEXT:    andl $701685459, %eax # imm = 0x29D2DED3
; X86-NEXT:    shrdl $21, %eax, %ecx
; X86-NEXT:    shrl $21, %eax
; X86-NEXT:    addl $7, %ecx
; X86-NEXT:    pushl %eax
; X86-NEXT:    pushl %ecx
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll __divdi3
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    orl %eax, %edx
; X86-NEXT:    setne {{[0-9]+}}(%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
;
; X64-LABEL: foo:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    movq d(%rip), %rcx
; X64-NEXT:    movabsq $3013716102212485120, %rdx # imm = 0x29D2DED3DE400000
; X64-NEXT:    andnq %rdx, %rcx, %rcx
; X64-NEXT:    shrq $21, %rcx
; X64-NEXT:    addq $7, %rcx
; X64-NEXT:    movq %rdi, %rdx
; X64-NEXT:    orq %rcx, %rdx
; X64-NEXT:    shrq $32, %rdx
; X64-NEXT:    je .LBB0_1
; X64-NEXT:  # %bb.2:
; X64-NEXT:    cqto
; X64-NEXT:    idivq %rcx
; X64-NEXT:    jmp .LBB0_3
; X64-NEXT:  .LBB0_1:
; X64-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    divl %ecx
; X64-NEXT:    # kill: def $eax killed $eax def $rax
; X64-NEXT:  .LBB0_3:
; X64-NEXT:    testq %rax, %rax
; X64-NEXT:    setne -{{[0-9]+}}(%rsp)
; X64-NEXT:    retq
  %1 = alloca i8, align 1
  %2 = load i64, ptr @d, align 8
  %3 = or i64 -3013716102214263007, %2
  %4 = xor i64 %3, -1
  %5 = load i64, ptr @e, align 8
  %6 = load i8, ptr @b, align 1
  %7 = trunc i8 %6 to i1
  %8 = zext i1 %7 to i64
  %9 = xor i64 %5, %8
  %10 = load i8, ptr @c, align 1
  %11 = trunc i8 %10 to i1
  %12 = zext i1 %11 to i32
  %13 = or i32 551409149, %12
  %14 = sub nsw i32 %13, 551409131
  %15 = zext i32 %14 to i64
  %16 = shl i64 %9, %15
  %17 = sub nsw i64 %16, 223084523
  %18 = ashr i64 %4, %17
  %19 = and i64 %18, 9223372036854775806
  %20 = add nsw i64 7, %19
  %21 = sdiv i64 %x, %20
  %22 = icmp ne i64 %21, 0
  %23 = zext i1 %22 to i8
  store i8 %23, ptr %1, align 1
  ret void
}
