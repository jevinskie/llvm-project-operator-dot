; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -fast-isel-abort=3 -mtriple=x86_64-apple-darwin10 | FileCheck %s
; RUN: llc < %s -fast-isel -mtriple=i686-- -mattr=+sse2 | FileCheck --check-prefix=SSE2 %s

define double @fneg_f64(double %x) nounwind {
; CHECK-LABEL: fneg_f64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movq %xmm0, %rax
; CHECK-NEXT:    movabsq $-9223372036854775808, %rcx ## imm = 0x8000000000000000
; CHECK-NEXT:    xorq %rax, %rcx
; CHECK-NEXT:    movq %rcx, %xmm0
; CHECK-NEXT:    retq
;
; SSE2-LABEL: fneg_f64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushl %ebp
; SSE2-NEXT:    movl %esp, %ebp
; SSE2-NEXT:    andl $-8, %esp
; SSE2-NEXT:    subl $8, %esp
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; SSE2-NEXT:    movlps %xmm0, (%esp)
; SSE2-NEXT:    fldl (%esp)
; SSE2-NEXT:    movl %ebp, %esp
; SSE2-NEXT:    popl %ebp
; SSE2-NEXT:    retl
  %y = fneg double %x
  ret double %y
}

define float @fneg_f32(float %x) nounwind {
; CHECK-LABEL: fneg_f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    xorl $2147483648, %eax ## imm = 0x80000000
; CHECK-NEXT:    movd %eax, %xmm0
; CHECK-NEXT:    retq
;
; SSE2-LABEL: fneg_f32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pushl %eax
; SSE2-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE2-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; SSE2-NEXT:    movss %xmm0, (%esp)
; SSE2-NEXT:    flds (%esp)
; SSE2-NEXT:    popl %eax
; SSE2-NEXT:    retl
  %y = fneg float %x
  ret float %y
}

define void @fneg_f64_mem(ptr %x, ptr %y) nounwind {
; CHECK-LABEL: fneg_f64_mem:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movq %xmm0, %rax
; CHECK-NEXT:    movabsq $-9223372036854775808, %rcx ## imm = 0x8000000000000000
; CHECK-NEXT:    xorq %rax, %rcx
; CHECK-NEXT:    movq %rcx, %xmm0
; CHECK-NEXT:    movq %xmm0, (%rsi)
; CHECK-NEXT:    retq
;
; SSE2-LABEL: fneg_f64_mem:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; SSE2-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    xorps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; SSE2-NEXT:    movsd %xmm0, (%eax)
; SSE2-NEXT:    retl
  %a = load double, ptr %x
  %b = fneg double %a
  store double %b, ptr %y
  ret void
}

define void @fneg_f32_mem(ptr %x, ptr %y) nounwind {
; CHECK-LABEL: fneg_f32_mem:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    xorl $2147483648, %eax ## imm = 0x80000000
; CHECK-NEXT:    movd %eax, %xmm0
; CHECK-NEXT:    movd %xmm0, (%rsi)
; CHECK-NEXT:    retq
;
; SSE2-LABEL: fneg_f32_mem:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; SSE2-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE2-NEXT:    movd %xmm0, %ecx
; SSE2-NEXT:    xorl $2147483648, %ecx # imm = 0x80000000
; SSE2-NEXT:    movd %ecx, %xmm0
; SSE2-NEXT:    movd %xmm0, (%eax)
; SSE2-NEXT:    retl
  %a = load float, ptr %x
  %b = fneg float %a
  store float %b, ptr %y
  ret void
}
