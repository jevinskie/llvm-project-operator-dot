; RUN: llc < %s -mtriple=i686-- -relocation-model=pic | FileCheck %s -check-prefix=PIC
; RUN: llc < %s -mtriple=i686-- -relocation-model=static | FileCheck %s -check-prefix=STATIC
;
; Make sure the common loop invariant A is hoisted up to preheader,
; since too many registers are needed to subsume it into the addressing modes.
; It's safe to sink A in when it's not pic.

; PIC:  align
; PIC:  movl  $4, -4([[REG:%e[a-z]+]])
; PIC:  movl  $5, ([[REG]])
; PIC:  addl  $4, [[REG]]
; PIC:  decl  {{%e[[a-z]+}}
; PIC:  jne

; STATIC: align
; STATIC: movl  $4, -4(%ecx)
; STATIC: movl  $5, (%ecx)
; STATIC: addl  $4, %ecx
; STATIC: decl  %eax
; STATIC: jne

@A = global [16 x [16 x i32]] zeroinitializer, align 32		; <ptr> [#uses=2]

define void @test(i32 %row, i32 %N.in) nounwind {
entry:
	%N = bitcast i32 %N.in to i32		; <i32> [#uses=1]
	%tmp5 = icmp sgt i32 %N.in, 0		; <i1> [#uses=1]
	br i1 %tmp5, label %cond_true, label %return

cond_true:		; preds = %cond_true, %entry
	%indvar = phi i32 [ 0, %entry ], [ %indvar.next, %cond_true ]		; <i32> [#uses=2]
	%i.0.0 = bitcast i32 %indvar to i32		; <i32> [#uses=2]
	%tmp2 = add i32 %i.0.0, 1		; <i32> [#uses=1]
	%tmp = getelementptr [16 x [16 x i32]], ptr @A, i32 0, i32 %row, i32 %tmp2		; <ptr> [#uses=1]
	store i32 4, ptr %tmp
	%tmp5.upgrd.1 = add i32 %i.0.0, 2		; <i32> [#uses=1]
	%tmp7 = getelementptr [16 x [16 x i32]], ptr @A, i32 0, i32 %row, i32 %tmp5.upgrd.1		; <ptr> [#uses=1]
	store i32 5, ptr %tmp7
	%indvar.next = add i32 %indvar, 1		; <i32> [#uses=2]
	%exitcond = icmp eq i32 %indvar.next, %N		; <i1> [#uses=1]
	br i1 %exitcond, label %return, label %cond_true

return:		; preds = %cond_true, %entry
	ret void
}
