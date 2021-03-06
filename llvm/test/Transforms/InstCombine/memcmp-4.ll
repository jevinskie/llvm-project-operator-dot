; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Verify that calls to memcmp with counts in excess of the array sizes are
; either folded gracefully or expanded to library calls.
;
; RUN: opt < %s -passes=instcombine -S -data-layout="E" | FileCheck %s --check-prefixes=BE
; RUN: opt < %s -passes=instcombine -S -data-layout="e" | FileCheck %s --check-prefixes=LE

declare i32 @memcmp(i8*, i8*, i64)

@ia16a = constant [4 x i16] [i16 24930, i16 25444, i16 25958, i16 26472]
@ia16b = constant [5 x i16] [i16 24930, i16 25444, i16 25958, i16 26472, i16 26992]
@ia16c = constant [6 x i16] [i16 24930, i16 25444, i16 25958, i16 26472, i16 26993, i16 29042]


; Fold calls with a count in excess of the size of one of the arrays that
; differ.  They're strictly undefined but folding the result to the expected
; value (analogous to strncmp) is safer than letting a SIMD library
; implementation return a bogus value.

define void @fold_memcmp_mismatch_too_big(i32* %pcmp) {
; BE-LABEL: @fold_memcmp_mismatch_too_big(
; BE-NEXT:    store i32 -1, i32* [[PCMP:%.*]], align 4
; BE-NEXT:    [[PSTOR_CB:%.*]] = getelementptr i32, i32* [[PCMP]], i64 1
; BE-NEXT:    store i32 1, i32* [[PSTOR_CB]], align 4
; BE-NEXT:    ret void
;
; LE-LABEL: @fold_memcmp_mismatch_too_big(
; LE-NEXT:    store i32 -1, i32* [[PCMP:%.*]], align 4
; LE-NEXT:    [[PSTOR_CB:%.*]] = getelementptr i32, i32* [[PCMP]], i64 1
; LE-NEXT:    store i32 1, i32* [[PSTOR_CB]], align 4
; LE-NEXT:    ret void
;
  %p0 = getelementptr [5 x i16], [5 x i16]* @ia16b, i64 0, i64 0
  %p1 = bitcast i16* %p0 to i8*
  %q0 = getelementptr [6 x i16], [6 x i16]* @ia16c, i64 0, i64 0
  %q1 = bitcast i16* %q0 to i8*

  %cmp_bc = call i32 @memcmp(i8* %p1, i8* %q1, i64 12)
  %pstor_bc = getelementptr i32, i32* %pcmp, i64 0
  store i32 %cmp_bc, i32* %pstor_bc

  %cmp_cb = call i32 @memcmp(i8* %q1, i8* %p1, i64 12)
  %pstor_cb = getelementptr i32, i32* %pcmp, i64 1
  store i32 %cmp_cb, i32* %pstor_cb

  ret void
}


; Fold even calls with excessive byte counts of arrays with matching bytes.
; Like in the instances above, this is preferable to letting the undefined
; calls take place, although it does prevent sanitizers from detecting them.

define void @fold_memcmp_match_too_big(i32* %pcmp) {
; BE-LABEL: @fold_memcmp_match_too_big(
; BE-NEXT:    store i32 0, i32* [[PCMP:%.*]], align 4
; BE-NEXT:    [[PSTOR_AB_M1:%.*]] = getelementptr i32, i32* [[PCMP]], i64 1
; BE-NEXT:    store i32 0, i32* [[PSTOR_AB_M1]], align 4
; BE-NEXT:    ret void
;
; LE-LABEL: @fold_memcmp_match_too_big(
; LE-NEXT:    store i32 0, i32* [[PCMP:%.*]], align 4
; LE-NEXT:    [[PSTOR_AB_M1:%.*]] = getelementptr i32, i32* [[PCMP]], i64 1
; LE-NEXT:    store i32 0, i32* [[PSTOR_AB_M1]], align 4
; LE-NEXT:    ret void
;
  %p0 = getelementptr [4 x i16], [4 x i16]* @ia16a, i64 0, i64 0
  %p1 = bitcast i16* %p0 to i8*
  %q0 = getelementptr [5 x i16], [5 x i16]* @ia16b, i64 0, i64 0
  %q1 = bitcast i16* %q0 to i8*

  %cmp_ab_9 = call i32 @memcmp(i8* %p1, i8* %q1, i64 9)
  %pstor_ab_9 = getelementptr i32, i32* %pcmp, i64 0
  store i32 %cmp_ab_9, i32* %pstor_ab_9

  %cmp_ab_m1 = call i32 @memcmp(i8* %p1, i8* %q1, i64 -1)
  %pstor_ab_m1 = getelementptr i32, i32* %pcmp, i64 1
  store i32 %cmp_ab_m1, i32* %pstor_ab_m1

  ret void
}
