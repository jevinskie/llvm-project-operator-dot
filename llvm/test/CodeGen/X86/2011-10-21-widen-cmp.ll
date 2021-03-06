; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=corei7 | FileCheck %s

; Check that a <4 x float> compare is generated and that we are
; not stuck in an endless loop.

define void @cmp_2_floats(<2 x float> %a, <2 x float> %b, <2 x float> %c) {
; CHECK-LABEL: cmp_2_floats:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movaps %xmm0, %xmm3
; CHECK-NEXT:    cmpordps %xmm2, %xmm2
; CHECK-NEXT:    movaps %xmm2, %xmm0
; CHECK-NEXT:    blendvps %xmm0, %xmm3, %xmm1
; CHECK-NEXT:    movlps %xmm1, (%rax)
; CHECK-NEXT:    retq
entry:
  %0 = fcmp oeq <2 x float> %c, %c
  %1 = select <2 x i1> %0, <2 x float> %a, <2 x float> %b
  store <2 x float> %1, ptr undef
  ret void
}

define void @cmp_2_doubles(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: cmp_2_doubles:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movapd %xmm0, %xmm3
; CHECK-NEXT:    cmpordpd %xmm2, %xmm2
; CHECK-NEXT:    movapd %xmm2, %xmm0
; CHECK-NEXT:    blendvpd %xmm0, %xmm3, %xmm1
; CHECK-NEXT:    movapd %xmm1, (%rax)
; CHECK-NEXT:    retq
entry:
  %0 = fcmp oeq <2 x double> %c, %c
  %1 = select <2 x i1> %0, <2 x double> %a, <2 x double> %b
  store <2 x double> %1, ptr undef
  ret void
}

define void @mp_11193(ptr nocapture %aFOO, ptr nocapture %RET) nounwind {
; CHECK-LABEL: mp_11193:
; CHECK:       # %bb.0: # %allocas
; CHECK-NEXT:    movl $-1082130432, (%rsi) # imm = 0xBF800000
; CHECK-NEXT:    retq
allocas:
  %bincmp = fcmp olt <8 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 9.000000e+00, float 1.000000e+00, float 9.000000e+00, float 1.000000e+00> , <float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00>
  %t = extractelement <8 x i1> %bincmp, i32 0
  %ft = sitofp i1 %t to float
  store float %ft, ptr %RET
  ret void
}

