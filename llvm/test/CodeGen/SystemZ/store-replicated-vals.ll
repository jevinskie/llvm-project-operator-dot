; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=s390x-linux-gnu -mcpu=z15 | FileCheck %s
;
; Test storing of replicated values using vector replicate type instructions.

;; Replicated registers

define void @fun_2x1b(i8* %Src, i16* %Dst) {
; CHECK-LABEL: fun_2x1b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlrepb %v0, 0(%r2)
; CHECK-NEXT:    vsteh %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 %i = load i8, i8* %Src
 %ZE = zext i8 %i to i16
 %Val = mul i16 %ZE, 257
 store i16 %Val, i16* %Dst
 ret void
}

; Test multiple stores of same value.
define void @fun_4x1b(i8* %Src, i32* %Dst, i32* %Dst2) {
; CHECK-LABEL: fun_4x1b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlrepb %v0, 0(%r2)
; CHECK-NEXT:    vstef %v0, 0(%r3), 0
; CHECK-NEXT:    vstef %v0, 0(%r4), 0
; CHECK-NEXT:    br %r14
 %i = load i8, i8* %Src
 %ZE = zext i8 %i to i32
 %Val = mul i32 %ZE, 16843009
 store i32 %Val, i32* %Dst
 store i32 %Val, i32* %Dst2
 ret void
}

define void @fun_8x1b(i8* %Src, i64* %Dst) {
; CHECK-LABEL: fun_8x1b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlrepb %v0, 0(%r2)
; CHECK-NEXT:    vsteg %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 %i = load i8, i8* %Src
 %ZE = zext i8 %i to i64
 %Val = mul i64 %ZE, 72340172838076673
 store i64 %Val, i64* %Dst
 ret void
}

; A second truncated store of same value.
define void @fun_8x1b_4x1b(i8* %Src, i64* %Dst, i32* %Dst2) {
; CHECK-LABEL: fun_8x1b_4x1b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlrepb %v0, 0(%r2)
; CHECK-NEXT:    vsteg %v0, 0(%r3), 0
; CHECK-NEXT:    vstef %v0, 0(%r4), 0
; CHECK-NEXT:    br %r14
 %i = load i8, i8* %Src
 %ZE = zext i8 %i to i64
 %Val = mul i64 %ZE, 72340172838076673
 store i64 %Val, i64* %Dst
 %TrVal = trunc i64 %Val to i32
 store i32 %TrVal, i32* %Dst2
 ret void
}

define void @fun_2x2b(i16* %Src, i32* %Dst) {
; CHECK-LABEL: fun_2x2b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlreph %v0, 0(%r2)
; CHECK-NEXT:    vstef %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 %i = load i16, i16* %Src
 %ZE = zext i16 %i to i32
 %Val = mul i32 %ZE, 65537
 store i32 %Val, i32* %Dst
 ret void
}

define void @fun_4x2b(i16* %Src, i64* %Dst) {
; CHECK-LABEL: fun_4x2b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlreph %v0, 0(%r2)
; CHECK-NEXT:    vsteg %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 %i = load i16, i16* %Src
 %ZE = zext i16 %i to i64
 %Val = mul i64 %ZE, 281479271743489
 store i64 %Val, i64* %Dst
 ret void
}

define void @fun_2x4b(i32* %Src, i64* %Dst) {
; CHECK-LABEL: fun_2x4b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlrepf %v0, 0(%r2)
; CHECK-NEXT:    vsteg %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 %i = load i32, i32* %Src
 %ZE = zext i32 %i to i64
 %Val = mul i64 %ZE, 4294967297
 store i64 %Val, i64* %Dst
 ret void
}

;; Replicated registers already in a vector.

; Test multiple stores of same value.
define void @fun_2Eltsx8x1b(i8* %Src, <2 x i64>* %Dst, <2 x i64>* %Dst2) {
; CHECK-LABEL: fun_2Eltsx8x1b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlrepb %v0, 0(%r2)
; CHECK-NEXT:    vst %v0, 0(%r3), 3
; CHECK-NEXT:    vst %v0, 0(%r4), 3
; CHECK-NEXT:    br %r14
 %i = load i8, i8* %Src
 %ZE = zext i8 %i to i64
 %Mul = mul i64 %ZE, 72340172838076673
 %tmp = insertelement <2 x i64> undef, i64 %Mul, i32 0
 %Val = shufflevector <2 x i64> %tmp, <2 x i64> undef, <2 x i32> zeroinitializer
 store <2 x i64> %Val, <2 x i64>* %Dst
 store <2 x i64> %Val, <2 x i64>* %Dst2
 ret void
}

define void @fun_4Eltsx2x2b(i16* %Src, <4 x i32>* %Dst) {
; CHECK-LABEL: fun_4Eltsx2x2b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlreph %v0, 0(%r2)
; CHECK-NEXT:    vst %v0, 0(%r3), 3
; CHECK-NEXT:    br %r14
 %i = load i16, i16* %Src
 %ZE = zext i16 %i to i32
 %Mul = mul i32 %ZE, 65537
 %tmp = insertelement <4 x i32> undef, i32 %Mul, i32 0
 %Val = shufflevector <4 x i32> %tmp, <4 x i32> undef, <4 x i32> zeroinitializer
 store <4 x i32> %Val, <4 x i32>* %Dst
 ret void
}

define void @fun_6Eltsx2x2b(i16* %Src, <6 x i32>* %Dst) {
; CHECK-LABEL: fun_6Eltsx2x2b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlreph %v0, 0(%r2)
; CHECK-NEXT:    vsteg %v0, 16(%r3), 0
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
 %i = load i16, i16* %Src
 %ZE = zext i16 %i to i32
 %Mul = mul i32 %ZE, 65537
 %tmp = insertelement <6 x i32> undef, i32 %Mul, i32 0
 %Val = shufflevector <6 x i32> %tmp, <6 x i32> undef, <6 x i32> zeroinitializer
 store <6 x i32> %Val, <6 x i32>* %Dst
 ret void
}

define void @fun_2Eltsx2x4b(i32* %Src, <2 x i64>* %Dst) {
; CHECK-LABEL: fun_2Eltsx2x4b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlrepf %v0, 0(%r2)
; CHECK-NEXT:    vst %v0, 0(%r3), 3
; CHECK-NEXT:    br %r14
 %i = load i32, i32* %Src
 %ZE = zext i32 %i to i64
 %Mul = mul i64 %ZE, 4294967297
 %tmp = insertelement <2 x i64> undef, i64 %Mul, i32 0
 %Val = shufflevector <2 x i64> %tmp, <2 x i64> undef, <2 x i32> zeroinitializer
 store <2 x i64> %Val, <2 x i64>* %Dst
 ret void
}

define void @fun_5Eltsx2x4b(i32* %Src, <5 x i64>* %Dst) {
; CHECK-LABEL: fun_5Eltsx2x4b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlrepf %v0, 0(%r2)
; CHECK-NEXT:    vsteg %v0, 32(%r3), 0
; CHECK-NEXT:    vst %v0, 16(%r3), 4
; CHECK-NEXT:    vst %v0, 0(%r3), 4
; CHECK-NEXT:    br %r14
 %i = load i32, i32* %Src
 %ZE = zext i32 %i to i64
 %Mul = mul i64 %ZE, 4294967297
 %tmp = insertelement <5 x i64> undef, i64 %Mul, i32 0
 %Val = shufflevector <5 x i64> %tmp, <5 x i64> undef, <5 x i32> zeroinitializer
 store <5 x i64> %Val, <5 x i64>* %Dst
 ret void
}

; Test replicating an incoming argument.
define void @fun_8x1b_arg(i8 %Arg, i64* %Dst) {
; CHECK-LABEL: fun_8x1b_arg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vlvgp %v0, %r2, %r2
; CHECK-NEXT:    vrepb %v0, %v0, 7
; CHECK-NEXT:    vsteg %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 %ZE = zext i8 %Arg to i64
 %Val = mul i64 %ZE, 72340172838076673
 store i64 %Val, i64* %Dst
 ret void
}

; A replication of a non-local value (ISD::AssertZext case).
define void @fun_nonlocalval() {
; CHECK-LABEL: fun_nonlocalval:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lhi %r0, 0
; CHECK-NEXT:    ciblh %r0, 0, 0(%r14)
; CHECK-NEXT:  .LBB13_1: # %bb2
; CHECK-NEXT:    llgf %r0, 0(%r1)
; CHECK-NEXT:    vlvgp %v0, %r0, %r0
; CHECK-NEXT:    vrepf %v0, %v0, 1
; CHECK-NEXT:    vst %v0, 0(%r1), 3
; CHECK-NEXT:    br %r14
  %i = load i32, i32* undef, align 4
  br i1 undef, label %bb2, label %bb7

bb2:                                              ; preds = %bb1
  %i3 = zext i32 %i to i64
  %i4 = mul nuw i64 %i3, 4294967297
  %i5 = insertelement <2 x i64> poison, i64 %i4, i64 0
  %i6 = shufflevector <2 x i64> %i5, <2 x i64> poison, <2 x i32> zeroinitializer
  store <2 x i64> %i6, <2 x i64>* undef, align 8
  ret void

bb7:
  ret void
}

;; Replicated immediates

; Some cases where scalar instruction is better
define void @fun_8x1i_zero(i64* %Dst) {
; CHECK-LABEL: fun_8x1i_zero:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mvghi 0(%r2), 0
; CHECK-NEXT:    br %r14
 store i64 0, i64* %Dst
 ret void
}

define void @fun_4x1i_minus1(i32* %Dst) {
; CHECK-LABEL: fun_4x1i_minus1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mvhi 0(%r2), -1
; CHECK-NEXT:    br %r14
 store i32 -1, i32* %Dst
 ret void
}

define void @fun_4x1i_allones(i32* %Dst) {
; CHECK-LABEL: fun_4x1i_allones:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mvhi 0(%r2), -1
; CHECK-NEXT:    br %r14
 store i32 4294967295, i32* %Dst
 ret void
}

define void @fun_2i(i16* %Dst) {
; CHECK-LABEL: fun_2i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mvhhi 0(%r2), 1
; CHECK-NEXT:    br %r14
 store i16 1, i16* %Dst
 ret void
}

define void @fun_2x2i(i32* %Dst) {
; CHECK-LABEL: fun_2x2i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrepih %v0, 1
; CHECK-NEXT:    vstef %v0, 0(%r2), 0
; CHECK-NEXT:    br %r14
 store i32 65537, i32* %Dst
 ret void
}

define void @fun_4x2i(i64* %Dst) {
; CHECK-LABEL: fun_4x2i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrepih %v0, 1
; CHECK-NEXT:    vsteg %v0, 0(%r2), 0
; CHECK-NEXT:    br %r14
 store i64 281479271743489, i64* %Dst
 ret void
}

define void @fun_2x4i(i64* %Dst) {
; CHECK-LABEL: fun_2x4i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrepif %v0, 1
; CHECK-NEXT:    vsteg %v0, 0(%r2), 0
; CHECK-NEXT:    br %r14
 store i64 4294967297, i64* %Dst
 ret void
}

; Store replicated immediate twice using the same vector.
define void @fun_4x1i(i32* %Dst, i32* %Dst2) {
; CHECK-LABEL: fun_4x1i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrepib %v0, 3
; CHECK-NEXT:    vstef %v0, 0(%r2), 0
; CHECK-NEXT:    vstef %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 store i32 50529027, i32* %Dst
 store i32 50529027, i32* %Dst2
 ret void
}

define void @fun_8x1i(i64* %Dst, i64* %Dst2) {
; CHECK-LABEL: fun_8x1i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrepib %v0, 1
; CHECK-NEXT:    vsteg %v0, 0(%r2), 0
; CHECK-NEXT:    vsteg %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 store i64 72340172838076673, i64* %Dst
 store i64 72340172838076673, i64* %Dst2
 ret void
}

; Similar, but with vectors.
define void @fun_4Eltsx4x1i_2Eltsx4x1i(<4 x i32>* %Dst, <2 x i32>* %Dst2) {
; CHECK-LABEL: fun_4Eltsx4x1i_2Eltsx4x1i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrepib %v0, 3
; CHECK-NEXT:    vst %v0, 0(%r2), 3
; CHECK-NEXT:    vsteg %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 %tmp = insertelement <4 x i32> undef, i32 50529027, i32 0
 %Val = shufflevector <4 x i32> %tmp, <4 x i32> undef, <4 x i32> zeroinitializer
 store <4 x i32> %Val, <4 x i32>* %Dst
 %tmp2 = insertelement <2 x i32> undef, i32 50529027, i32 0
 %Val2 = shufflevector <2 x i32> %tmp2, <2 x i32> undef, <2 x i32> zeroinitializer
 store <2 x i32> %Val2, <2 x i32>* %Dst2
 ret void
}

; Same, but 64-bit store is scalar.
define void @fun_4Eltsx4x1i_8x1i(<4 x i32>* %Dst, i64* %Dst2) {
; CHECK-LABEL: fun_4Eltsx4x1i_8x1i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrepib %v0, 3
; CHECK-NEXT:    vst %v0, 0(%r2), 3
; CHECK-NEXT:    vsteg %v0, 0(%r3), 0
; CHECK-NEXT:    br %r14
 %tmp = insertelement <4 x i32> undef, i32 50529027, i32 0
 %Val = shufflevector <4 x i32> %tmp, <4 x i32> undef, <4 x i32> zeroinitializer
 store <4 x i32> %Val, <4 x i32>* %Dst
 store i64 217020518514230019, i64* %Dst2
 ret void
}

define void @fun_3Eltsx2x4i(<3 x i64>* %Dst) {
; CHECK-LABEL: fun_3Eltsx2x4i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrepif %v0, 1
; CHECK-NEXT:    vsteg %v0, 16(%r2), 0
; CHECK-NEXT:    vst %v0, 0(%r2), 4
; CHECK-NEXT:    br %r14
 %tmp = insertelement <3 x i64> undef, i64 4294967297, i32 0
 %Val = shufflevector <3 x i64> %tmp, <3 x i64> undef, <3 x i32> zeroinitializer
 store <3 x i64> %Val, <3 x i64>* %Dst
 ret void
}

; i128 replicated '1': not using vrepib, but should compile.
define void @fun_16x1i(i128* %Dst) {
; CHECK-LABEL: fun_16x1i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    llihf %r0, 16843009
; CHECK-NEXT:    oilf %r0, 16843009
; CHECK-NEXT:    stg %r0, 8(%r2)
; CHECK-NEXT:    stg %r0, 0(%r2)
; CHECK-NEXT:    br %r14
 store i128 1334440654591915542993625911497130241, i128* %Dst
 ret void
}
