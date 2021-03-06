; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instsimplify -S < %s | FileCheck %s

define i1 @bitcast() {
; CHECK-LABEL: @bitcast(
; CHECK-NEXT:    ret i1 false
;
  %a = alloca i32
  %b = alloca i64
  %y = call ptr @func1(ptr %b)
  %cmp = icmp eq ptr %a, %y
  ret i1 %cmp
}

%gept = type { i32, i32 }

define i1 @gep3() {
; CHECK-LABEL: @gep3(
; CHECK-NEXT:    ret i1 false
;
  %x = alloca %gept, align 8
  %y = call ptr @func2(ptr %x)
  %b = getelementptr %gept, ptr %y, i64 0, i32 1
  %equal = icmp eq ptr %x, %b
  ret i1 %equal
}

declare ptr @func1(ptr returned) nounwind readnone willreturn
declare ptr @func2(ptr returned) nounwind readnone willreturn

