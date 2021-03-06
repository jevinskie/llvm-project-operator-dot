; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -O0 < %s | FileCheck --check-prefixes=CHECK,CHECK-O0 %s
; RUN: llc -mtriple=x86_64-unknown-unknown -O3 < %s | FileCheck --check-prefixes=CHECK,CHECK-O3 %s

declare void @external()
declare void @no_csr() "no_callee_saved_registers"

define void @normal() {
; CHECK-LABEL: normal:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq external@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  call void @external()
  ret void
}

; Calling a routine with no CSRs means the caller has to spill a bunch
define void @test1() {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    callq external@PLT
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  call void @external() "no_callee_saved_registers"
  ret void
}

; Same as test1, but on callee, not callsite
define void @test2() {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pushq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    pushq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    pushq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    .cfi_offset %rbx, -56
; CHECK-NEXT:    .cfi_offset %r12, -48
; CHECK-NEXT:    .cfi_offset %r13, -40
; CHECK-NEXT:    .cfi_offset %r14, -32
; CHECK-NEXT:    .cfi_offset %r15, -24
; CHECK-NEXT:    .cfi_offset %rbp, -16
; CHECK-NEXT:    callq no_csr@PLT
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 56
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    popq %r12
; CHECK-NEXT:    .cfi_def_cfa_offset 40
; CHECK-NEXT:    popq %r13
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    .cfi_def_cfa_offset 24
; CHECK-NEXT:    popq %r15
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  call void @no_csr()
  ret void
}

; on an invoke instead
define i32 @test3() personality ptr undef {
; CHECK-O0-LABEL: test3:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushq %rbp
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    pushq %r15
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 24
; CHECK-O0-NEXT:    pushq %r14
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 32
; CHECK-O0-NEXT:    pushq %r13
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 40
; CHECK-O0-NEXT:    pushq %r12
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 48
; CHECK-O0-NEXT:    pushq %rbx
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 56
; CHECK-O0-NEXT:    pushq %rax
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 64
; CHECK-O0-NEXT:    .cfi_offset %rbx, -56
; CHECK-O0-NEXT:    .cfi_offset %r12, -48
; CHECK-O0-NEXT:    .cfi_offset %r13, -40
; CHECK-O0-NEXT:    .cfi_offset %r14, -32
; CHECK-O0-NEXT:    .cfi_offset %r15, -24
; CHECK-O0-NEXT:    .cfi_offset %rbp, -16
; CHECK-O0-NEXT:  .Ltmp0:
; CHECK-O0-NEXT:    callq no_csr@PLT
; CHECK-O0-NEXT:  .Ltmp1:
; CHECK-O0-NEXT:    jmp .LBB3_1
; CHECK-O0-NEXT:  .LBB3_1: # %invoke.cont
; CHECK-O0-NEXT:    movl $1, %eax
; CHECK-O0-NEXT:    addq $8, %rsp
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 56
; CHECK-O0-NEXT:    popq %rbx
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 48
; CHECK-O0-NEXT:    popq %r12
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 40
; CHECK-O0-NEXT:    popq %r13
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 32
; CHECK-O0-NEXT:    popq %r14
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 24
; CHECK-O0-NEXT:    popq %r15
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    popq %rbp
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 8
; CHECK-O0-NEXT:    retq
; CHECK-O0-NEXT:  .LBB3_2: # %lpad
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 64
; CHECK-O0-NEXT:  .Ltmp2:
; CHECK-O0-NEXT:    xorl %eax, %eax
; CHECK-O0-NEXT:    addq $8, %rsp
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 56
; CHECK-O0-NEXT:    popq %rbx
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 48
; CHECK-O0-NEXT:    popq %r12
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 40
; CHECK-O0-NEXT:    popq %r13
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 32
; CHECK-O0-NEXT:    popq %r14
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 24
; CHECK-O0-NEXT:    popq %r15
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O0-NEXT:    popq %rbp
; CHECK-O0-NEXT:    .cfi_def_cfa_offset 8
; CHECK-O0-NEXT:    retq
;
; CHECK-O3-LABEL: test3:
; CHECK-O3:       # %bb.0: # %entry
; CHECK-O3-NEXT:    pushq %rbp
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O3-NEXT:    pushq %r15
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 24
; CHECK-O3-NEXT:    pushq %r14
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 32
; CHECK-O3-NEXT:    pushq %r13
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 40
; CHECK-O3-NEXT:    pushq %r12
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 48
; CHECK-O3-NEXT:    pushq %rbx
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 56
; CHECK-O3-NEXT:    pushq %rax
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 64
; CHECK-O3-NEXT:    .cfi_offset %rbx, -56
; CHECK-O3-NEXT:    .cfi_offset %r12, -48
; CHECK-O3-NEXT:    .cfi_offset %r13, -40
; CHECK-O3-NEXT:    .cfi_offset %r14, -32
; CHECK-O3-NEXT:    .cfi_offset %r15, -24
; CHECK-O3-NEXT:    .cfi_offset %rbp, -16
; CHECK-O3-NEXT:  .Ltmp0:
; CHECK-O3-NEXT:    callq no_csr@PLT
; CHECK-O3-NEXT:  .Ltmp1:
; CHECK-O3-NEXT:  # %bb.1: # %invoke.cont
; CHECK-O3-NEXT:    movl $1, %eax
; CHECK-O3-NEXT:  .LBB3_2: # %invoke.cont
; CHECK-O3-NEXT:    addq $8, %rsp
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 56
; CHECK-O3-NEXT:    popq %rbx
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 48
; CHECK-O3-NEXT:    popq %r12
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 40
; CHECK-O3-NEXT:    popq %r13
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 32
; CHECK-O3-NEXT:    popq %r14
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 24
; CHECK-O3-NEXT:    popq %r15
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 16
; CHECK-O3-NEXT:    popq %rbp
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 8
; CHECK-O3-NEXT:    retq
; CHECK-O3-NEXT:  .LBB3_3: # %lpad
; CHECK-O3-NEXT:    .cfi_def_cfa_offset 64
; CHECK-O3-NEXT:  .Ltmp2:
; CHECK-O3-NEXT:    xorl %eax, %eax
; CHECK-O3-NEXT:    jmp .LBB3_2
entry:
  invoke void @no_csr()
     to label %invoke.cont unwind label %lpad

invoke.cont:
  ret i32 1

lpad:
  %0 = landingpad { ptr, i32 }
          cleanup
  ret i32 0
}

define void @no_csr_func() "no_callee_saved_registers" {
; CHECK-LABEL: no_csr_func:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq external@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  call void @external()
  ret void
}

