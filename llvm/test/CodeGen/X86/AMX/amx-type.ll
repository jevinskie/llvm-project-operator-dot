; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt --codegen-opt-level=2 -mtriple=x86_64 -lower-amx-type %s -S | FileCheck %s

%struct.__tile_str = type { i16, i16, <256 x i32> }

@buf = dso_local global [1024 x i8] zeroinitializer, align 64
@buf2 = dso_local global [1024 x i8] zeroinitializer, align 64

; test bitcast x86_amx to <256 x i32>
define dso_local void @test_user_empty(i16 %m, i16 %n, ptr%buf, i64 %s) {
; CHECK-LABEL: @test_user_empty(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[N:%.*]], ptr [[BUF:%.*]], i64 [[S:%.*]])
; CHECK-NEXT:    ret void
;
entry:
  %t1 = call x86_amx @llvm.x86.tileloadd64.internal(i16 %m, i16 %n, ptr %buf, i64 %s)
  %t2 = bitcast x86_amx %t1 to <256 x i32>
  ret void
}

; test bitcast <256 x i32> to x86_amx
define dso_local void @test_user_empty2(<256 x i32> %in) {
; CHECK-LABEL: @test_user_empty2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
entry:
  %t = bitcast <256 x i32> %in to x86_amx
  ret void
}

define dso_local <256 x i32> @test_amx_load_bitcast(ptr %in, i16 %m, i16 %n, ptr%buf, i64 %s) {
; CHECK-LABEL: @test_amx_load_bitcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T1:%.*]] = load <256 x i32>, ptr [[IN:%.*]], align 64
; CHECK-NEXT:    [[TMP0:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[N:%.*]], ptr [[IN]], i64 64)
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], ptr [[BUF:%.*]], i64 [[S:%.*]], x86_amx [[TMP0]])
; CHECK-NEXT:    ret <256 x i32> [[T1]]
;
entry:
  %t1 = load <256 x i32>, ptr %in, align 64
  %t2 = bitcast <256 x i32> %t1 to x86_amx
  call void @llvm.x86.tilestored64.internal(i16 %m, i16 %n, ptr %buf, i64 %s, x86_amx %t2)
  ret <256 x i32> %t1
}

define dso_local <256 x i32> @test_amx_bitcast_store(ptr %out, i16 %m, i16 %n, ptr%buf, i64 %s) {
; CHECK-LABEL: @test_amx_bitcast_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[M]], ptr [[BUF:%.*]], i64 [[S:%.*]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[M]], ptr [[OUT:%.*]], i64 64, x86_amx [[T1]])
; CHECK-NEXT:    [[TMP0:%.*]] = load <256 x i32>, ptr [[OUT]], align 1024
; CHECK-NEXT:    ret <256 x i32> [[TMP0]]
;
entry:
  %t1 = call x86_amx @llvm.x86.tileloadd64.internal(i16 %m, i16 %m, ptr %buf, i64 %s)
  %t2 = bitcast x86_amx %t1 to <256 x i32>
  store <256 x i32> %t2, ptr %out
  ret <256 x i32> %t2
}

define dso_local void @test_src_add(<256 x i32> %x, <256 x i32> %y, i16 %r, i16 %c, ptr %buf, i64 %s) {
; CHECK-LABEL: @test_src_add(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[ADD:%.*]] = add <256 x i32> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    store <256 x i32> [[ADD]], ptr [[TMP0]], align 1024
; CHECK-NEXT:    [[TMP1:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[R:%.*]], i16 [[C:%.*]], ptr [[TMP0]], i64 64)
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[R]], i16 [[C]], ptr [[BUF:%.*]], i64 [[S:%.*]], x86_amx [[TMP1]])
; CHECK-NEXT:    ret void
;
entry:
  %add = add <256 x i32> %y, %x
  %t = bitcast <256 x i32> %add to x86_amx
  call void @llvm.x86.tilestored64.internal(i16 %r, i16 %c, ptr %buf, i64 %s, x86_amx %t)
  ret void
}

define dso_local void @test_src_add2(<256 x i32> %x, i16 %r, i16 %c, ptr %buf, i64 %s) {
; CHECK-LABEL: @test_src_add2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[R:%.*]], i16 [[C:%.*]], ptr [[BUF:%.*]], i64 [[S:%.*]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[R]], i16 [[C]], ptr [[TMP0]], i64 64, x86_amx [[T1]])
; CHECK-NEXT:    [[TMP1:%.*]] = load <256 x i32>, ptr [[TMP0]], align 1024
; CHECK-NEXT:    [[ADD:%.*]] = add <256 x i32> [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret void
;
entry:
  %t1 = call x86_amx @llvm.x86.tileloadd64.internal(i16 %r, i16 %c, ptr %buf, i64 %s)
  %t2 = bitcast x86_amx %t1 to <256 x i32>
  %add = add <256 x i32> %t2, %x
  ret void
}

define dso_local void @test_load(ptr %in, ptr %out) local_unnamed_addr {
; CHECK-LABEL: @test_load(
; CHECK-NEXT:    [[TMP1:%.*]] = load <256 x i32>, ptr [[IN:%.*]], align 64
; CHECK-NEXT:    store <256 x i32> [[TMP1]], ptr [[OUT:%.*]], align 64
; CHECK-NEXT:    ret void
;
  %1 = load <256 x i32>, ptr %in, align 64
  store <256 x i32> %1, ptr %out, align 64
  ret void
}

define dso_local <256 x i32> @foo(ptr nocapture readonly byval(<256 x i32>) align 1024 %0, ptr nocapture readonly byval(<256 x i32>) align 1024 %1) local_unnamed_addr {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load <256 x i32>, ptr [[TMP0:%.*]], align 1024
; CHECK-NEXT:    [[Y:%.*]] = load <256 x i32>, ptr [[TMP1:%.*]], align 1024
; CHECK-NEXT:    [[ADD:%.*]] = add <256 x i32> [[Y]], [[X]]
; CHECK-NEXT:    ret <256 x i32> [[ADD]]
;
entry:
  %x = load <256 x i32>, ptr %0, align 1024
  %y = load <256 x i32>, ptr %1, align 1024
  %add = add <256 x i32> %y, %x
  ret <256 x i32> %add
}

define dso_local void @__tile_loadd(ptr nocapture %0, ptr %1, i64 %2) local_unnamed_addr {
; CHECK-LABEL: @__tile_loadd(
; CHECK-NEXT:    [[TMP4:%.*]] = load i16, ptr [[TMP0:%.*]], align 64
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR:%.*]], ptr [[TMP0]], i64 0, i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = load i16, ptr [[TMP5]], align 2
; CHECK-NEXT:    [[TMP7:%.*]] = shl i64 [[TMP2:%.*]], 32
; CHECK-NEXT:    [[TMP8:%.*]] = ashr exact i64 [[TMP7]], 32
; CHECK-NEXT:    [[TMP9:%.*]] = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP4]], i16 [[TMP6]], ptr [[TMP1:%.*]], i64 [[TMP8]])
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], ptr [[TMP0]], i64 0, i32 2
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[TMP4]], i16 [[TMP6]], ptr [[TMP10]], i64 64, x86_amx [[TMP9]])
; CHECK-NEXT:    ret void
;
  %4 = load i16, ptr %0, align 64
  %5 = getelementptr inbounds %struct.__tile_str, ptr %0, i64 0, i32 1
  %6 = load i16, ptr %5, align 2
  %7 = shl i64 %2, 32
  %8 = ashr exact i64 %7, 32
  %9 = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 %4, i16 %6, ptr %1, i64 %8)
  %10 = bitcast x86_amx %9 to <256 x i32>
  %11 = getelementptr inbounds %struct.__tile_str, ptr %0, i64 0, i32 2
  store <256 x i32> %10, ptr %11, align 64
  ret void
}

define dso_local void @__tile_dpbssd(ptr nocapture %0, ptr nocapture readonly byval(%struct.__tile_str) align 64 %1, ptr nocapture readonly byval(%struct.__tile_str) align 64 %2) local_unnamed_addr {
; CHECK-LABEL: @__tile_dpbssd(
; CHECK-NEXT:    [[TMP4:%.*]] = load i16, ptr [[TMP1:%.*]], align 64
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR:%.*]], ptr [[TMP2:%.*]], i64 0, i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = load i16, ptr [[TMP5]], align 2
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], ptr [[TMP1]], i64 0, i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load i16, ptr [[TMP7]], align 2
; CHECK-NEXT:    [[TMP9:%.*]] = udiv i16 [[TMP8]], 4
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], ptr [[TMP0:%.*]], i64 0, i32 2
; CHECK-NEXT:    [[TMP11:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP4]], i16 [[TMP6]], ptr [[TMP10]], i64 64)
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], ptr [[TMP1]], i64 0, i32 2
; CHECK-NEXT:    [[TMP13:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP4]], i16 [[TMP8]], ptr [[TMP12]], i64 64)
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], ptr [[TMP2]], i64 0, i32 2
; CHECK-NEXT:    [[TMP15:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP9]], i16 [[TMP6]], ptr [[TMP14]], i64 64)
; CHECK-NEXT:    [[TMP16:%.*]] = tail call x86_amx @llvm.x86.tdpbssd.internal(i16 [[TMP4]], i16 [[TMP6]], i16 [[TMP8]], x86_amx [[TMP11]], x86_amx [[TMP13]], x86_amx [[TMP15]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[TMP4]], i16 [[TMP6]], ptr [[TMP10]], i64 64, x86_amx [[TMP16]])
; CHECK-NEXT:    ret void
;
  %4 = load i16, ptr %1, align 64
  %5 = getelementptr inbounds %struct.__tile_str, ptr %2, i64 0, i32 1
  %6 = load i16, ptr %5, align 2
  %7 = getelementptr inbounds %struct.__tile_str, ptr %1, i64 0, i32 1
  %8 = load i16, ptr %7, align 2
  %9 = getelementptr inbounds %struct.__tile_str, ptr %0, i64 0, i32 2
  %10 = load <256 x i32>, ptr %9, align 64
  %11 = bitcast <256 x i32> %10 to x86_amx
  %12 = getelementptr inbounds %struct.__tile_str, ptr %1, i64 0, i32 2
  %13 = load <256 x i32>, ptr %12, align 64
  %14 = bitcast <256 x i32> %13 to x86_amx
  %15 = getelementptr inbounds %struct.__tile_str, ptr %2, i64 0, i32 2
  %16 = load <256 x i32>, ptr %15, align 64
  %17 = bitcast <256 x i32> %16 to x86_amx
  %18 = tail call x86_amx @llvm.x86.tdpbssd.internal(i16 %4, i16 %6, i16 %8, x86_amx %11, x86_amx %14, x86_amx %17)
  %19 = bitcast x86_amx %18 to <256 x i32>
  store <256 x i32> %19, ptr %9, align 64
  ret void
}

define dso_local void @__tile_dpbsud(i16 %m, i16 %n, i16 %k, ptr %pc, ptr %pa, ptr %pb) {
; CHECK-LABEL: @__tile_dpbsud(
; CHECK-NEXT:    [[TMP1:%.*]] = udiv i16 [[K:%.*]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[K]], ptr [[PA:%.*]], i64 64)
; CHECK-NEXT:    [[TMP3:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP1]], i16 [[N:%.*]], ptr [[PB:%.*]], i64 64)
; CHECK-NEXT:    [[TMP4:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M]], i16 [[N]], ptr [[PC:%.*]], i64 64)
; CHECK-NEXT:    [[T6:%.*]] = tail call x86_amx @llvm.x86.tdpbsud.internal(i16 [[M]], i16 [[N]], i16 [[K]], x86_amx [[TMP4]], x86_amx [[TMP2]], x86_amx [[TMP3]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], ptr [[PC]], i64 64, x86_amx [[T6]])
; CHECK-NEXT:    ret void
;
  %t0 = load <256 x i32>, ptr %pa, align 64
  %t1 = bitcast <256 x i32> %t0 to x86_amx
  %t2 = load <256 x i32>, ptr %pb, align 64
  %t3 = bitcast <256 x i32> %t2 to x86_amx
  %t4 = load <256 x i32>, ptr %pc, align 64
  %t5 = bitcast <256 x i32> %t4 to x86_amx
  %t6 = tail call x86_amx @llvm.x86.tdpbsud.internal(i16 %m, i16 %n, i16 %k, x86_amx %t5, x86_amx %t1, x86_amx %t3)
  %t7 = bitcast x86_amx %t6 to <256 x i32>
  store <256 x i32> %t7, ptr %pc, align 64
  ret void
}

define dso_local void @__tile_dpbusd(i16 %m, i16 %n, i16 %k, ptr %pc, ptr %pa, ptr %pb) {
; CHECK-LABEL: @__tile_dpbusd(
; CHECK-NEXT:    [[TMP1:%.*]] = udiv i16 [[K:%.*]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[K]], ptr [[PA:%.*]], i64 64)
; CHECK-NEXT:    [[TMP3:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP1]], i16 [[N:%.*]], ptr [[PB:%.*]], i64 64)
; CHECK-NEXT:    [[TMP4:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M]], i16 [[N]], ptr [[PC:%.*]], i64 64)
; CHECK-NEXT:    [[T6:%.*]] = tail call x86_amx @llvm.x86.tdpbusd.internal(i16 [[M]], i16 [[N]], i16 [[K]], x86_amx [[TMP4]], x86_amx [[TMP2]], x86_amx [[TMP3]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], ptr [[PC]], i64 64, x86_amx [[T6]])
; CHECK-NEXT:    ret void
;
  %t0 = load <256 x i32>, ptr %pa, align 64
  %t1 = bitcast <256 x i32> %t0 to x86_amx
  %t2 = load <256 x i32>, ptr %pb, align 64
  %t3 = bitcast <256 x i32> %t2 to x86_amx
  %t4 = load <256 x i32>, ptr %pc, align 64
  %t5 = bitcast <256 x i32> %t4 to x86_amx
  %t6 = tail call x86_amx @llvm.x86.tdpbusd.internal(i16 %m, i16 %n, i16 %k, x86_amx %t5, x86_amx %t1, x86_amx %t3)
  %t7 = bitcast x86_amx %t6 to <256 x i32>
  store <256 x i32> %t7, ptr %pc, align 64
  ret void
}

define dso_local void @__tile_dpbuud(i16 %m, i16 %n, i16 %k, ptr %pc, ptr %pa, ptr %pb) {
; CHECK-LABEL: @__tile_dpbuud(
; CHECK-NEXT:    [[TMP1:%.*]] = udiv i16 [[K:%.*]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[K]], ptr [[PA:%.*]], i64 64)
; CHECK-NEXT:    [[TMP3:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP1]], i16 [[N:%.*]], ptr [[PB:%.*]], i64 64)
; CHECK-NEXT:    [[TMP4:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M]], i16 [[N]], ptr [[PC:%.*]], i64 64)
; CHECK-NEXT:    [[T6:%.*]] = tail call x86_amx @llvm.x86.tdpbuud.internal(i16 [[M]], i16 [[N]], i16 [[K]], x86_amx [[TMP4]], x86_amx [[TMP2]], x86_amx [[TMP3]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], ptr [[PC]], i64 64, x86_amx [[T6]])
; CHECK-NEXT:    ret void
;
  %t0 = load <256 x i32>, ptr %pa, align 64
  %t1 = bitcast <256 x i32> %t0 to x86_amx
  %t2 = load <256 x i32>, ptr %pb, align 64
  %t3 = bitcast <256 x i32> %t2 to x86_amx
  %t4 = load <256 x i32>, ptr %pc, align 64
  %t5 = bitcast <256 x i32> %t4 to x86_amx
  %t6 = tail call x86_amx @llvm.x86.tdpbuud.internal(i16 %m, i16 %n, i16 %k, x86_amx %t5, x86_amx %t1, x86_amx %t3)
  %t7 = bitcast x86_amx %t6 to <256 x i32>
  store <256 x i32> %t7, ptr %pc, align 64
  ret void
}

define dso_local void @__tile_dpbf16ps(i16 %m, i16 %n, i16 %k, ptr %pc, ptr %pa, ptr %pb) {
; CHECK-LABEL: @__tile_dpbf16ps(
; CHECK-NEXT:    [[TMP1:%.*]] = udiv i16 [[K:%.*]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M:%.*]], i16 [[K]], ptr [[PA:%.*]], i64 64)
; CHECK-NEXT:    [[TMP3:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP1]], i16 [[N:%.*]], ptr [[PB:%.*]], i64 64)
; CHECK-NEXT:    [[TMP4:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[M]], i16 [[N]], ptr [[PC:%.*]], i64 64)
; CHECK-NEXT:    [[T6:%.*]] = tail call x86_amx @llvm.x86.tdpbf16ps.internal(i16 [[M]], i16 [[N]], i16 [[K]], x86_amx [[TMP4]], x86_amx [[TMP2]], x86_amx [[TMP3]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[M]], i16 [[N]], ptr [[PC]], i64 64, x86_amx [[T6]])
; CHECK-NEXT:    ret void
;
  %t0 = load <256 x i32>, ptr %pa, align 64
  %t1 = bitcast <256 x i32> %t0 to x86_amx
  %t2 = load <256 x i32>, ptr %pb, align 64
  %t3 = bitcast <256 x i32> %t2 to x86_amx
  %t4 = load <256 x i32>, ptr %pc, align 64
  %t5 = bitcast <256 x i32> %t4 to x86_amx
  %t6 = tail call x86_amx @llvm.x86.tdpbf16ps.internal(i16 %m, i16 %n, i16 %k, x86_amx %t5, x86_amx %t1, x86_amx %t3)
  %t7 = bitcast x86_amx %t6 to <256 x i32>
  store <256 x i32> %t7, ptr %pc, align 64
  ret void
}

define dso_local void @__tile_stored(ptr %0, i64 %1, ptr nocapture readonly byval(%struct.__tile_str) align 64 %2) local_unnamed_addr {
; CHECK-LABEL: @__tile_stored(
; CHECK-NEXT:    [[TMP4:%.*]] = load i16, ptr [[TMP2:%.*]], align 64
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR:%.*]], ptr [[TMP2]], i64 0, i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = load i16, ptr [[TMP5]], align 2
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT___TILE_STR]], ptr [[TMP2]], i64 0, i32 2
; CHECK-NEXT:    [[TMP8:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[TMP4]], i16 [[TMP6]], ptr [[TMP7]], i64 64)
; CHECK-NEXT:    [[TMP9:%.*]] = shl i64 [[TMP1:%.*]], 32
; CHECK-NEXT:    [[TMP10:%.*]] = ashr exact i64 [[TMP9]], 32
; CHECK-NEXT:    tail call void @llvm.x86.tilestored64.internal(i16 [[TMP4]], i16 [[TMP6]], ptr [[TMP0:%.*]], i64 [[TMP10]], x86_amx [[TMP8]])
; CHECK-NEXT:    ret void
;
  %4 = load i16, ptr %2, align 64
  %5 = getelementptr inbounds %struct.__tile_str, ptr %2, i64 0, i32 1
  %6 = load i16, ptr %5, align 2
  %7 = getelementptr inbounds %struct.__tile_str, ptr %2, i64 0, i32 2
  %8 = load <256 x i32>, ptr %7, align 64
  %9 = bitcast <256 x i32> %8 to x86_amx
  %10 = shl i64 %1, 32
  %11 = ashr exact i64 %10, 32
  tail call void @llvm.x86.tilestored64.internal(i16 %4, i16 %6, ptr %0, i64 %11, x86_amx %9)
  ret void
}

declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, ptr, i64)
declare x86_amx @llvm.x86.tdpbssd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbsud.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbusd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbuud.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbf16ps.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare void @llvm.x86.tilestored64.internal(i16, i16, ptr, i64, x86_amx)
