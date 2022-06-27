; RUN: opt < %s -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

; CHECK: %t = add i64 %t, 1
; CHECK: -->  poison

define void @foo() {
entry:
  ret void

dead:
  %t = add i64 %t, 1
  ret void
}
