# REQUIRES: aarch64
# RUN: rm -rf %t; split-file %s %t

# RUN: llvm-mc -filetype=obj -triple=arm64-apple-darwin %t/arm64-dtrace.s -o %t/arm64-dtrace.o
# RUN: %lld -arch arm64 -o %t/arm64-dtrace %t/arm64-dtrace.o

## If references of dtrace symbols are handled by lld, their relocation should be replaced with the following instructions
# RUN: llvm-objdump --macho -D %t/arm64-dtrace | FileCheck %s --check-prefix=CHECK

# CHECK: 00 00 80 d2  mov     x0, #0

# CHECK: 1f 20 03 d5  nop

#--- arm64-dtrace.s
	.globl	_main
_main:
	bl	___dtrace_isenabled$Foo$added$v1
	.reference	___dtrace_typedefs$Foo$v2
	bl	___dtrace_probe$Foo$added$v1$696e74
	.reference	___dtrace_stability$Foo$v1$1_1_0_1_1_0_1_1_0_1_1_0_1_1_0
	ret

.subsections_via_symbols
