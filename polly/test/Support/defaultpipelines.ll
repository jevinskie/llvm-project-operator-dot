; Legacy pass manager
; RUN: opt %loadPolly -enable-new-pm=0 -polly -O0 -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=OFF
; RUN: opt %loadPolly -enable-new-pm=0 -polly -O1 -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ON
; RUN: opt %loadPolly -enable-new-pm=0 -polly -O2 -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ON
; RUN: opt %loadPolly -enable-new-pm=0 -polly -O3 -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ON
; RUN: opt %loadPolly -enable-new-pm=0 -polly -Os -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=OFF
; RUN: opt %loadPolly -enable-new-pm=0 -polly -Oz -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=OFF
;
; New pass manager
; RUN: opt %loadNPMPolly -enable-new-pm=1 -polly -O0 -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=OFF
; RUN: opt %loadNPMPolly -enable-new-pm=1 -polly -O1 -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ON
; RUN: opt %loadNPMPolly -enable-new-pm=1 -polly -O2 -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ON
; RUN: opt %loadNPMPolly -enable-new-pm=1 -polly -O3 -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=ON
; RUN: opt %loadNPMPolly -enable-new-pm=1 -polly -Os -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=OFF
; RUN: opt %loadNPMPolly -enable-new-pm=1 -polly -Oz -S < %s | FileCheck %s --check-prefix=CHECK --check-prefix=OFF
;
; Check that Polly's default pipeline works from detection to code generation
; with either pass manager.
; The presence of the BB polly.stmt.body.lr.ph indicates that the statement
; has been re-generated by Polly. It should not have been merged with other
; BBs by SimplifyCFG.
;
; for (int j = 0; j < n; j += 1) {
;   A[0] = 42.0;
; }
;
define void @func(i32 %n, double* noalias nonnull %A) {
entry:
  br label %for

for:
  %j = phi i32 [0, %entry], [%j.inc, %inc]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %body, label %exit

    body:
      store double 42.0, double* %A
      br label %inc

inc:
  %j.inc = add nuw nsw i32 %j, 1
  br label %for

exit:
  br label %return

return:
  ret void
}


; CHECK-LABEL: define void @func(
; ON:       polly.stmt.body.lr.ph:
; ON-NEXT:    store double 4.200000e+01, double* %A, align 8
; OFF-NOT:  polly
