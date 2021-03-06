; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X64

; compare v2i16

define <2 x i16> @compare_v2i64_to_v2i16_unary(ptr %src) nounwind {
; X86-LABEL: compare_v2i64_to_v2i16_unary:
; X86:       # %bb.0:
; X86-NEXT:    pcmpeqd %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: compare_v2i64_to_v2i16_unary:
; X64:       # %bb.0:
; X64-NEXT:    pcmpeqd %xmm0, %xmm0
; X64-NEXT:    retq
  %val = load <2 x i16>, ptr %src, align 4
  %cmp = icmp uge <2 x i16> %val, %val
  %sel = select <2 x i1> %cmp, <2 x i16> <i16 -1, i16 -1>, <2 x i16> zeroinitializer
  ret <2 x i16> %sel
}

define <2 x i16> @compare_v2i64_to_v2i16_binary(ptr %src0, ptr %src1) nounwind {
; X86-LABEL: compare_v2i64_to_v2i16_binary:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X86-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    pmaxuw %xmm1, %xmm0
; X86-NEXT:    pcmpeqw %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: compare_v2i64_to_v2i16_binary:
; X64:       # %bb.0:
; X64-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X64-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-NEXT:    pmaxuw %xmm1, %xmm0
; X64-NEXT:    pcmpeqw %xmm1, %xmm0
; X64-NEXT:    retq
  %val0 = load <2 x i16>, ptr %src0, align 4
  %val1 = load <2 x i16>, ptr %src1, align 4
  %cmp = icmp uge <2 x i16> %val0, %val1
  %sel = select <2 x i1> %cmp, <2 x i16> <i16 -1, i16 -1>, <2 x i16> zeroinitializer
  ret <2 x i16> %sel
}
