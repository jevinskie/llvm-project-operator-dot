; RUN: opt -module-summary %s -o %t1.bc
; RUN: opt -module-summary %p/Inputs/diagnostic-handler-remarks.ll -o %t2.bc

; Check that the hotness attribute is included in the optimization record file
; with -lto-pass-remarks-with-hotness.

; RUN: llvm-lto -thinlto-action=run \
; RUN:          -lto-pass-remarks-output=%t.yaml \
; RUN:          -lto-pass-remarks-with-hotness \
; RUN:          -exported-symbol _func2 \
; RUN:          -exported-symbol _main %t1.bc %t2.bc 2>&1 | \
; RUN:     FileCheck %s -allow-empty
; CHECK-NOT: remark:
; CHECK-NOT: llvm-lto:

; Verify that bar is imported 'and' inlined into 'foo'
; RUN: cat %t.yaml.thin.0.yaml | FileCheck %s -check-prefixes=YAML1,YAML1-NO-ANNOTATE

; Verify that bar is imported 'and' inlined into 'foo'
; RUN: cat %t.yaml.thin.1.yaml | FileCheck %s -check-prefixes=YAML2,YAML2-NO-ANNOTATE

; Run again with -annotate-inline-phase

; RUN: llvm-lto -thinlto-action=run \
; RUN:          -lto-pass-remarks-output=%t.yaml \
; RUN:          -annotate-inline-phase \
; RUN:          -lto-pass-remarks-with-hotness \
; RUN:          -exported-symbol _func2 \
; RUN:          -exported-symbol _main %t1.bc %t2.bc 2>&1 | \
; RUN:     FileCheck %s -allow-empty
; CHECK-NOT: remark:
; CHECK-NOT: llvm-lto:

; Verify that pass name is annotated with LTO phase information.
; RUN: cat %t.yaml.thin.0.yaml | FileCheck %s -check-prefixes=YAML1,YAML1-ANNOTATE

; YAML1:      --- !Passed
; YAML1:      --- !Passed
; YAML1-NO-ANNOTATE-NEXT: Pass: inline
; YAML1-ANNOTATE-NEXT: Pass:   postlink-cgscc-inline
; YAML1-NEXT: Name:            Inlined
; YAML1-NEXT: Function:        main
; YAML1-NEXT: Hotness:         50
; YAML1-NEXT: Args:
; YAML1-NEXT:   - String:          ''''
; YAML1-NEXT:   - Callee:          foo
; YAML1-NEXT:   - String:          ''' inlined into '
; YAML1-NEXT:   - Caller:          main
; YAML1-NEXT:   - String:          ''''
; YAML1-NEXT:   - String:          ' with '
; YAML1-NEXT:   - String:          '(cost='
; YAML1-NEXT:   - Cost:            '-30'
; YAML1-NEXT:   - String:          ', threshold='
; YAML1-NEXT:   - Threshold:       '375'
; YAML1-NEXT:   - String:          ')'
; YAML1-NEXT: ...


; Verify that bar is imported 'and' inlined into 'foo'
; RUN: cat %t.yaml.thin.1.yaml | FileCheck %s -check-prefixes=YAML2,YAML2-ANNOTATE
; YAML2:      --- !Passed
; YAML2-NO-ANNOTATE-NEXT: Pass:            inline
; YAML2-ANNOTATE-NEXT: Pass:            postlink-cgscc-inline
; YAML2-NEXT: Name:            Inlined
; YAML2-NEXT: Function:        foo
; YAML2-NEXT: Args:
; YAML2-NEXT:   - String:          ''''
; YAML2-NEXT:   - Callee:          bar
; YAML2-NEXT:   - String:          ''' inlined into '
; YAML2-NEXT:   - Caller:          foo
; YAML2-NEXT:   - String:          ''''
; YAML2-NEXT:   - String:          ' with '
; YAML2-NEXT:   - String:          '(cost='
; YAML2-NEXT:   - Cost:            '-30'
; YAML2-NEXT:   - String:          ', threshold='
; YAML2-NEXT:   - Threshold:       '375'
; YAML2-NEXT:   - String:          ')'
; YAML2-NEXT: ...


target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

define i32 @bar() {
	ret i32 42
}
declare i32 @foo()
define i32 @main() !prof !0 {
  %i = call i32 @foo()
  ret i32 %i
}

!0 = !{!"function_entry_count", i64 50}
