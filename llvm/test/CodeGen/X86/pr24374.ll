; RUN: llc < %s | FileCheck %s
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-w64-windows-gnu"

@llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @g, ptr null }]

declare i32 @__gxx_personality_seh0(...)

; Function Attrs: nounwind
define void @f() #0 personality ptr @__gxx_personality_seh0 {
entry:
  invoke void @g()
          to label %exit unwind label %lpad

lpad:                                             ; preds = %entry
  landingpad { ptr, i32 }
          cleanup
  unreachable

exit:                                             ; preds = %entry
  unreachable
}
; CHECK-LABEL: f:
; CHECK:       .seh_proc f
; CHECK:               .seh_handler __gxx_personality_seh0, @unwind, @except
; CHECK:       callq g
; CHECK:               .seh_handlerdata
; CHECK:               .seh_endproc

define void @g() {
  unreachable
}
; CHECK-LABEL: g:
; CHECK: nop

attributes #0 = { nounwind }
