; RUN: opt -mtriple=x86_64 -codegenprepare -S < %s | FileCheck %s
; CHECK: for.body.preheader

@N = common global i32 0, align 4
@E = common global ptr null, align 8
@B = common global ptr null, align 8

; Function Attrs: nounwind
define i32 @foo() {
entry:
  %0 = load i32, ptr @N, align 4
  %1 = load ptr, ptr @E, align 8
  %2 = load ptr, ptr @B, align 8
  %cmp7 = icmp eq ptr %2, %1
  br i1 %cmp7, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %add.lcssa = phi i32 [ %add, %for.body ]
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %n.0.lcssa = phi i32 [ %0, %entry ], [ %add.lcssa, %for.cond.cleanup.loopexit ]
  ret i32 %n.0.lcssa

for.body:                                         ; preds = %for.body.preheader, %for.body
  %I.09 = phi ptr [ %incdec.ptr, %for.body ], [ %2, %for.body.preheader ]
  %n.08 = phi i32 [ %add, %for.body ], [ %0, %for.body.preheader ]
  %3 = load ptr, ptr %I.09, align 8
  %call = tail call i32 @map(ptr %3)
  %add = add nsw i32 %call, %n.08
  %incdec.ptr = getelementptr inbounds ptr, ptr %I.09, i64 1
  %cmp = icmp eq ptr %incdec.ptr, %1
  br i1 %cmp, label %for.cond.cleanup.loopexit, label %for.body
}

declare i32 @map(ptr)
