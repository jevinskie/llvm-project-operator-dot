; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; TODO: Test that ...
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare i32 @strcmp(i8*, i8*)

@s9 = constant [10 x i8] c"123456789\00"


; Fold strcmp(C ? s3 : s5, s3) to C ? 0 : 1.

define i32 @fold_strcmp_s3_x_s4_s3(i1 %C) {
; CHECK-LABEL: @fold_strcmp_s3_x_s4_s3(
; CHECK-NEXT:    [[PTR:%.*]] = select i1 [[C:%.*]], i8* getelementptr inbounds ([10 x i8], [10 x i8]* @s9, i64 0, i64 6), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @s9, i64 0, i64 5)
; CHECK-NEXT:    [[CMP:%.*]] = call i32 @strcmp(i8* noundef nonnull dereferenceable(1) [[PTR]], i8* noundef nonnull dereferenceable(4) getelementptr inbounds ([10 x i8], [10 x i8]* @s9, i64 0, i64 6))
; CHECK-NEXT:    ret i32 [[CMP]]
;

  %ps3 = getelementptr [10 x i8], [10 x i8]* @s9, i64 0, i64 6
  %ps4 = getelementptr [10 x i8], [10 x i8]* @s9, i64 0, i64 5

  %ptr = select i1 %C, i8* %ps3, i8* %ps4
  %cmp = call i32 @strcmp(i8* %ptr, i8* %ps3)
  ret i32 %cmp
}
