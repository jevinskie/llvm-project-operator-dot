; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

define float @foo1(float %a) {
; CHECK-LABEL: @foo1(
; CHECK-NEXT:    [[B:%.*]] = fcmp ogt float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[B]], float [[A]], float 0.000000e+00
; CHECK-NEXT:    [[D:%.*]] = fcmp olt float [[C]], 1.000000e+00
; CHECK-NEXT:    [[F:%.*]] = select i1 [[D]], float [[C]], float 1.000000e+00
; CHECK-NEXT:    ret float [[F]]
;
  %b = fcmp ogt float %a, 0.0
  %c = select i1 %b, float %a, float 0.0
  %d = fcmp olt float %c, 1.0
  %f = select i1 %d, float %c, float 1.0
  ret float %f
}

define float @foo2(float %a) {
; CHECK-LABEL: @foo2(
; CHECK-NEXT:    [[B:%.*]] = fcmp ogt float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[B]], float [[A]], float 0.000000e+00
; CHECK-NEXT:    [[D:%.*]] = fcmp olt float [[C]], 1.000000e+00
; CHECK-NEXT:    [[E:%.*]] = select i1 [[B]], float [[A]], float 0.000000e+00
; CHECK-NEXT:    [[F:%.*]] = select i1 [[D]], float [[E]], float 1.000000e+00
; CHECK-NEXT:    ret float [[F]]
;
  %b = fcmp ogt float %a, 0.0
  %c = select i1 %b, float %a, float 0.0
  %d = fcmp olt float %c, 1.0
  %e = select i1 %b, float %a, float 0.0
  %f = select i1 %d, float %e, float 1.0
  ret float %f
}

define <2 x i32> @foo3(<2 x i1> %vec_bool, i1 %bool, <2 x i32> %V) {
; CHECK-LABEL: @foo3(
; CHECK-NEXT:    [[SEL0:%.*]] = select <2 x i1> [[VEC_BOOL:%.*]], <2 x i32> zeroinitializer, <2 x i32> [[V:%.*]]
; CHECK-NEXT:    [[SEL1:%.*]] = select i1 [[BOOL:%.*]], <2 x i32> [[SEL0]], <2 x i32> [[V]]
; CHECK-NEXT:    ret <2 x i32> [[SEL1]]
;
  %sel0 = select <2 x i1> %vec_bool, <2 x i32> zeroinitializer, <2 x i32> %V
  %sel1 = select i1 %bool, <2 x i32> %sel0, <2 x i32> %V
  ret <2 x i32> %sel1
}

; Four variations of (select (select-shuffle)) with a common operand.

define <4 x i8> @sel_shuf_commute0(<4 x i8> %x, <4 x i8> %y, <4 x i1> %cmp) {
; CHECK-LABEL: @sel_shuf_commute0(
; CHECK-NEXT:    [[SEL:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i8> [[Y:%.*]], <4 x i8> [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i8> [[X]], <4 x i8> [[SEL]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    ret <4 x i8> [[R]]
;
  %blend = shufflevector <4 x i8> %x, <4 x i8> %y, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %r = select <4 x i1> %cmp, <4 x i8> %blend, <4 x i8> %x
  ret <4 x i8> %r
}

; Weird types are ok.

define <5 x i9> @sel_shuf_commute1(<5 x i9> %x, <5 x i9> %y, <5 x i1> %cmp) {
; CHECK-LABEL: @sel_shuf_commute1(
; CHECK-NEXT:    [[SEL:%.*]] = select <5 x i1> [[CMP:%.*]], <5 x i9> [[X:%.*]], <5 x i9> [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <5 x i9> [[SEL]], <5 x i9> [[Y]], <5 x i32> <i32 0, i32 6, i32 2, i32 8, i32 9>
; CHECK-NEXT:    ret <5 x i9> [[R]]
;
  %blend = shufflevector <5 x i9> %x, <5 x i9> %y, <5 x i32> <i32 0, i32 6, i32 2, i32 8, i32 9>
  %r = select <5 x i1> %cmp, <5 x i9> %blend, <5 x i9> %y
  ret <5 x i9> %r
}

define <4 x float> @sel_shuf_commute2(<4 x float> %x, <4 x float> %y, <4 x i1> %cmp) {
; CHECK-LABEL: @sel_shuf_commute2(
; CHECK-NEXT:    [[SEL:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x float> [[X:%.*]], <4 x float> [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[X]], <4 x float> [[SEL]], <4 x i32> <i32 0, i32 1, i32 2, i32 7>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %blend = shufflevector <4 x float> %x, <4 x float> %y, <4 x i32> <i32 0, i32 1, i32 2, i32 7>
  %r = select <4 x i1> %cmp, <4 x float> %x, <4 x float> %blend
  ret <4 x float> %r
}

; Scalar condition is ok.

define <4 x i8> @sel_shuf_commute3(<4 x i8> %x, <4 x i8> %y, i1 %cmp) {
; CHECK-LABEL: @sel_shuf_commute3(
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP:%.*]], <4 x i8> [[Y:%.*]], <4 x i8> [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x i8> [[SEL]], <4 x i8> [[Y]], <4 x i32> <i32 0, i32 5, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x i8> [[R]]
;
  %blend = shufflevector <4 x i8> %x, <4 x i8> %y, <4 x i32> <i32 0, i32 5, i32 2, i32 3>
  %r = select i1 %cmp, <4 x i8> %y, <4 x i8> %blend
  ret <4 x i8> %r
}

declare void @use(<4 x i8>)

; Negative test - extra use would require another instruction.

define <4 x i8> @sel_shuf_use(<4 x i8> %x, <4 x i8> %y, <4 x i1> %cmp) {
; CHECK-LABEL: @sel_shuf_use(
; CHECK-NEXT:    [[BLEND:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 7>
; CHECK-NEXT:    call void @use(<4 x i8> [[BLEND]])
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i8> [[BLEND]], <4 x i8> [[X]]
; CHECK-NEXT:    ret <4 x i8> [[R]]
;
  %blend = shufflevector <4 x i8> %x, <4 x i8> %y, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  call void @use(<4 x i8> %blend)
  %r = select <4 x i1> %cmp, <4 x i8> %blend, <4 x i8> %x
  ret <4 x i8> %r
}

; Negative test - undef in shuffle mask prevents transform.

define <4 x i8> @sel_shuf_undef(<4 x i8> %x, <4 x i8> %y, <4 x i1> %cmp) {
; CHECK-LABEL: @sel_shuf_undef(
; CHECK-NEXT:    [[BLEND:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 undef>
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i8> [[BLEND]], <4 x i8> [[Y]]
; CHECK-NEXT:    ret <4 x i8> [[R]]
;
  %blend = shufflevector <4 x i8> %x, <4 x i8> %y, <4 x i32> <i32 0, i32 5, i32 2, i32 undef>
  %r = select <4 x i1> %cmp, <4 x i8> %blend, <4 x i8> %y
  ret <4 x i8> %r
}

; Negative test - not a "select shuffle"

define <4 x i8> @sel_shuf_not(<4 x i8> %x, <4 x i8> %y, <4 x i1> %cmp) {
; CHECK-LABEL: @sel_shuf_not(
; CHECK-NEXT:    [[NOTBLEND:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 6>
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i8> [[NOTBLEND]], <4 x i8> [[Y]]
; CHECK-NEXT:    ret <4 x i8> [[R]]
;
  %notblend = shufflevector <4 x i8> %x, <4 x i8> %y, <4 x i32> <i32 0, i32 5, i32 2, i32 6>
  %r = select <4 x i1> %cmp, <4 x i8> %notblend, <4 x i8> %y
  ret <4 x i8> %r
}

; Negative test - must shuffle one of the select operands

define <4 x i8> @sel_shuf_no_common_operand(<4 x i8> %x, <4 x i8> %y, <4 x i1> %cmp, <4 x i8> %z) {
; CHECK-LABEL: @sel_shuf_no_common_operand(
; CHECK-NEXT:    [[BLEND:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <4 x i32> <i32 0, i32 5, i32 2, i32 3>
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[CMP:%.*]], <4 x i8> [[Z:%.*]], <4 x i8> [[BLEND]]
; CHECK-NEXT:    ret <4 x i8> [[R]]
;
  %blend = shufflevector <4 x i8> %x, <4 x i8> %y, <4 x i32> <i32 0, i32 5, i32 2, i32 3>
  %r = select <4 x i1> %cmp, <4 x i8> %z, <4 x i8> %blend
  ret <4 x i8> %r
}

; Negative test - don't crash (this is not a select shuffle because it changes vector length)

define <2 x i8> @sel_shuf_narrowing_commute1(<4 x i8> %x, <4 x i8> %y, <2 x i8> %x2, <2 x i1> %cmp) {
; CHECK-LABEL: @sel_shuf_narrowing_commute1(
; CHECK-NEXT:    [[BLEND:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <2 x i32> <i32 0, i32 5>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP:%.*]], <2 x i8> [[BLEND]], <2 x i8> [[X2:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %blend = shufflevector <4 x i8> %x, <4 x i8> %y, <2 x i32> <i32 0, i32 5>
  %r = select <2 x i1> %cmp, <2 x i8> %blend, <2 x i8> %x2
  ret <2 x i8> %r
}

; Negative test - don't crash (this is not a select shuffle because it changes vector length)

define <2 x i8> @sel_shuf_narrowing_commute2(<4 x i8> %x, <4 x i8> %y, <2 x i8> %x2, <2 x i1> %cmp) {
; CHECK-LABEL: @sel_shuf_narrowing_commute2(
; CHECK-NEXT:    [[BLEND:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> [[Y:%.*]], <2 x i32> <i32 0, i32 5>
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CMP:%.*]], <2 x i8> [[X2:%.*]], <2 x i8> [[BLEND]]
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %blend = shufflevector <4 x i8> %x, <4 x i8> %y, <2 x i32> <i32 0, i32 5>
  %r = select <2 x i1> %cmp, <2 x i8> %x2, <2 x i8> %blend
  ret <2 x i8> %r
}
