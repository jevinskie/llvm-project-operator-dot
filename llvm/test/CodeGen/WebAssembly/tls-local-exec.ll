; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+bulk-memory,atomics | FileCheck %s --check-prefixes=CHECK,TLS
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+bulk-memory,atomics -fast-isel | FileCheck %s --check-prefixes=CHECK,TLS
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=-bulk-memory,atomics | FileCheck %s --check-prefixes=CHECK,NO-TLS
target triple = "wasm32-unknown-unknown"

; CHECK-LABEL: address_of_tls:
; CHECK-NEXT: .functype  address_of_tls () -> (i32)
define i32 @address_of_tls() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls
  ; NO-TLS-NEXT: return
  ret i32 ptrtoint(i32* @tls to i32)
}

; CHECK-LABEL: address_of_tls_external:
; CHECK-NEXT: .functype  address_of_tls_external () -> (i32)
define i32 @address_of_tls_external() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls_external@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls_external
  ; NO-TLS-NEXT: return
  ret i32 ptrtoint(i32* @tls_external to i32)
}

; CHECK-LABEL: ptr_to_tls:
; CHECK-NEXT: .functype ptr_to_tls () -> (i32)
define i32* @ptr_to_tls() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls
  ; NO-TLS-NEXT: return
  ret i32* @tls
}

; CHECK-LABEL: tls_load:
; CHECK-NEXT: .functype tls_load () -> (i32)
define i32 @tls_load() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: i32.load 0
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const 0
  ; NO-TLS-NEXT: i32.load tls
  ; NO-TLS-NEXT: return
  %tmp = load i32, i32* @tls, align 4
  ret i32 %tmp
}

; CHECK-LABEL: tls_store:
; CHECK-NEXT: .functype tls_store (i32) -> ()
define void @tls_store(i32 %x) {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls@TLSREL
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: i32.store 0
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const 0
  ; NO-TLS-NEXT: i32.store tls
  ; NO-TLS-NEXT: return
  store i32 %x, i32* @tls, align 4
  ret void
}

; CHECK-LABEL: tls_size:
; CHECK-NEXT: .functype tls_size () -> (i32)
define i32 @tls_size() {
; CHECK-NEXT: global.get __tls_size
; CHECK-NEXT: return
  %1 = call i32 @llvm.wasm.tls.size.i32()
  ret i32 %1
}

; CHECK: .type tls,@object
; TLS-NEXT: .section .tbss.tls,"T",@
; NO-TLS-NEXT: .section .bss.tls,"",@
; CHECK-NEXT: .p2align 2
; CHECK-NEXT: tls:
; CHECK-NEXT: .int32 0
@tls = internal thread_local(localexec) global i32 0

@tls_external = external thread_local(localexec) global i32, align 4

declare i32 @llvm.wasm.tls.size.i32()
