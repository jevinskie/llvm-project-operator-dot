; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

declare i32 @llvm.amdgcn.perm(i32, i32, i32)

; src1 = 0x19203a4b (421542475), src2 = 0x5c6d7e8f (1550679695)
define void @test(ptr %p) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    store volatile i32 undef, ptr [[P:%.*]], align 4
; CHECK-NEXT:    store volatile i32 -1887539876, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 2121096267, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 1262100505, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 1550679695, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 421542475, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 545143439, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 16711935, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 16711935, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 436174336, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 16711680, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 -1, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 -1, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 -1, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 undef, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 421542475, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 1550679695, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 undef, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 143, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 0, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 255, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 1550679552, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 75, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 0, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 255, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 65535, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 421542400, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 -16776961, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 255, ptr [[P]], align 4
; CHECK-NEXT:    store volatile i32 -16777216, ptr [[P]], align 4
; CHECK-NEXT:    ret void
;
  %s1s2_u = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 undef)
  store volatile i32 %s1s2_u, ptr %p
  %s1s2_0x00010203 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 66051)
  store volatile i32 %s1s2_0x00010203, ptr %p
  %s1s2_0x01020304 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 16909060)
  store volatile i32 %s1s2_0x01020304, ptr %p
  %s1s2_0x04050607 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 67438087)
  store volatile i32 %s1s2_0x04050607, ptr %p
  %s1s2_0x03020100 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 50462976)
  store volatile i32 %s1s2_0x03020100, ptr %p
  %s1s2_0x07060504 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 117835012)
  store volatile i32 %s1s2_0x07060504, ptr %p
  %s1s2_0x06010500 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 100730112)
  store volatile i32 %s1s2_0x06010500, ptr %p
  %s1s2_0x0c0f0c0f = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 202312719)
  store volatile i32 %s1s2_0x0c0f0c0f, ptr %p
  %u1u2_0x0c0f0c0f = call i32 @llvm.amdgcn.perm(i32 undef, i32 undef, i32 202312719)
  store volatile i32 %u1u2_0x0c0f0c0f, ptr %p
  %s1s2_0x070d010c = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 118292748)
  store volatile i32 %s1s2_0x070d010c, ptr %p
  %u1u2_0x070d010c = call i32 @llvm.amdgcn.perm(i32 undef, i32 undef, i32 118292748)
  store volatile i32 %u1u2_0x070d010c, ptr %p
  %s1s2_0x80818283 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 1550679695, i32 2155971203)
  store volatile i32 %s1s2_0x80818283, ptr %p
  %u1u2_0x80818283 = call i32 @llvm.amdgcn.perm(i32 undef, i32 undef, i32 2155971203)
  store volatile i32 %u1u2_0x80818283, ptr %p
  %u1u2_0x0e0e0e0e = call i32 @llvm.amdgcn.perm(i32 undef, i32 undef, i32 235802126)
  store volatile i32 %u1u2_0x0e0e0e0e, ptr %p
  %u1s2_0x07060504 = call i32 @llvm.amdgcn.perm(i32 undef, i32 1550679695, i32 117835012)
  store volatile i32 %u1s2_0x07060504, ptr %p
  %s1u2_0x07060504 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 undef, i32 117835012)
  store volatile i32 %s1u2_0x07060504, ptr %p
  %u1s2_0x03020100 = call i32 @llvm.amdgcn.perm(i32 undef, i32 1550679695, i32 50462976)
  store volatile i32 %u1s2_0x03020100, ptr %p
  %s1u2_0x03020100 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 undef, i32 50462976)
  store volatile i32 %s1u2_0x03020100, ptr %p
  %u1s2_0x07060500 = call i32 @llvm.amdgcn.perm(i32 undef, i32 1550679695, i32 117835008)
  store volatile i32 %u1s2_0x07060500, ptr %p
  %u1s2_0x0706050c = call i32 @llvm.amdgcn.perm(i32 undef, i32 1550679695, i32 117835020)
  store volatile i32 %u1s2_0x0706050c, ptr %p
  %u1s2_0x0706050d = call i32 @llvm.amdgcn.perm(i32 undef, i32 1550679695, i32 117835021)
  store volatile i32 %u1s2_0x0706050d, ptr %p
  %u1s2_0x03020104 = call i32 @llvm.amdgcn.perm(i32 undef, i32 1550679695, i32 50462980)
  store volatile i32 %u1s2_0x03020104, ptr %p
  %s1u2_0x03020104 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 undef, i32 50462980)
  store volatile i32 %s1u2_0x03020104, ptr %p
  %s1u2_0x0302010c = call i32 @llvm.amdgcn.perm(i32 421542475, i32 undef, i32 50462988)
  store volatile i32 %s1u2_0x0302010c, ptr %p
  %s1u2_0x0302010e = call i32 @llvm.amdgcn.perm(i32 421542475, i32 undef, i32 50462990)
  store volatile i32 %s1u2_0x0302010e, ptr %p
  %s1u2_0x03020f0e = call i32 @llvm.amdgcn.perm(i32 421542475, i32 undef, i32 50466574)
  store volatile i32 %s1u2_0x03020f0e, ptr %p
  %s1u2_0x07060500 = call i32 @llvm.amdgcn.perm(i32 421542475, i32 undef, i32 117835008)
  store volatile i32 %s1u2_0x07060500, ptr %p
  %_0x81000100_0x01008100_0x0b0a0908 = call i32 @llvm.amdgcn.perm(i32 2164261120, i32 16810240, i32 185207048)
  store volatile i32 %_0x81000100_0x01008100_0x0b0a0908, ptr %p
  %_u1_0x01008100_0x0b0a0908 = call i32 @llvm.amdgcn.perm(i32 undef, i32 16810240, i32 185207048)
  store volatile i32 %_u1_0x01008100_0x0b0a0908, ptr %p
  %_0x81000100_u2_0x0b0a0908 = call i32 @llvm.amdgcn.perm(i32 2164261120, i32 undef, i32 185207048)
  store volatile i32 %_0x81000100_u2_0x0b0a0908, ptr %p
  ret void
}
