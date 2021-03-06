// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature --include-generated-funcs --replace-value-regex "__omp_offloading_[0-9a-z]+_[0-9a-z]+"
// RUN: %clang_cc1 -no-opaque-pointers -verify -fopenmp -x c++ -triple powerpc64le-unknown-unknown -fopenmp-targets=nvptx64-nvidia-cuda -fopenmp-offload-mandatory -emit-llvm %s -o - | FileCheck %s --check-prefix=MANDATORY
// expected-no-diagnostics

void foo() {}
#pragma omp declare target(foo)

void bar() {}
#pragma omp declare target device_type(nohost) to(bar)

void host() {
#pragma omp target
  { bar(); }
}

void host_if(bool cond) {
#pragma omp target if(cond)
  { bar(); }
}

void host_dev(int device) {
#pragma omp target device(device)
  { bar(); }
}
// MANDATORY-LABEL: define {{[^@]+}}@_Z3foov
// MANDATORY-SAME: () #[[ATTR0:[0-9]+]] {
// MANDATORY-NEXT:  entry:
// MANDATORY-NEXT:    ret void
//
//
// MANDATORY-LABEL: define {{[^@]+}}@_Z4hostv
// MANDATORY-SAME: () #[[ATTR0]] {
// MANDATORY-NEXT:  entry:
// MANDATORY-NEXT:    [[KERNEL_ARGS:%.*]] = alloca [[STRUCT___TGT_KERNEL_ARGUMENTS:%.*]], align 8
// MANDATORY-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 0
// MANDATORY-NEXT:    store i32 1, i32* [[TMP0]], align 4
// MANDATORY-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 1
// MANDATORY-NEXT:    store i32 0, i32* [[TMP1]], align 4
// MANDATORY-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 2
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP2]], align 8
// MANDATORY-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 3
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP3]], align 8
// MANDATORY-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 4
// MANDATORY-NEXT:    store i64* null, i64** [[TMP4]], align 8
// MANDATORY-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 5
// MANDATORY-NEXT:    store i64* null, i64** [[TMP5]], align 8
// MANDATORY-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 6
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP6]], align 8
// MANDATORY-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 7
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP7]], align 8
// MANDATORY-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 8
// MANDATORY-NEXT:    store i64 0, i64* [[TMP8]], align 8
// MANDATORY-NEXT:    [[TMP9:%.*]] = call i32 @__tgt_target_kernel(%struct.ident_t* @[[GLOB1:[0-9]+]], i64 -1, i32 -1, i32 0, i8* @.{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z4hostv_l12.region_id, %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]])
// MANDATORY-NEXT:    [[TMP10:%.*]] = icmp ne i32 [[TMP9]], 0
// MANDATORY-NEXT:    br i1 [[TMP10]], label [[OMP_OFFLOAD_FAILED:%.*]], label [[OMP_OFFLOAD_CONT:%.*]]
// MANDATORY:       omp_offload.failed:
// MANDATORY-NEXT:    unreachable
// MANDATORY:       omp_offload.cont:
// MANDATORY-NEXT:    ret void
//
//
// MANDATORY-LABEL: define {{[^@]+}}@_Z7host_ifb
// MANDATORY-SAME: (i1 noundef zeroext [[COND:%.*]]) #[[ATTR0]] {
// MANDATORY-NEXT:  entry:
// MANDATORY-NEXT:    [[COND_ADDR:%.*]] = alloca i8, align 1
// MANDATORY-NEXT:    [[FROMBOOL:%.*]] = zext i1 [[COND]] to i8
// MANDATORY-NEXT:    store i8 [[FROMBOOL]], i8* [[COND_ADDR]], align 1
// MANDATORY-NEXT:    [[TMP0:%.*]] = load i8, i8* [[COND_ADDR]], align 1
// MANDATORY-NEXT:    [[TOBOOL:%.*]] = trunc i8 [[TMP0]] to i1
// MANDATORY-NEXT:    br i1 [[TOBOOL]], label [[OMP_IF_THEN:%.*]], label [[OMP_IF_ELSE:%.*]]
// MANDATORY:       omp_if.then:
// MANDATORY-NEXT:    [[KERNEL_ARGS:%.*]] = alloca [[STRUCT___TGT_KERNEL_ARGUMENTS:%.*]], align 8
// MANDATORY-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 0
// MANDATORY-NEXT:    store i32 1, i32* [[TMP1]], align 4
// MANDATORY-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 1
// MANDATORY-NEXT:    store i32 0, i32* [[TMP2]], align 4
// MANDATORY-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 2
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP3]], align 8
// MANDATORY-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 3
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP4]], align 8
// MANDATORY-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 4
// MANDATORY-NEXT:    store i64* null, i64** [[TMP5]], align 8
// MANDATORY-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 5
// MANDATORY-NEXT:    store i64* null, i64** [[TMP6]], align 8
// MANDATORY-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 6
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP7]], align 8
// MANDATORY-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 7
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP8]], align 8
// MANDATORY-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 8
// MANDATORY-NEXT:    store i64 0, i64* [[TMP9]], align 8
// MANDATORY-NEXT:    [[TMP10:%.*]] = call i32 @__tgt_target_kernel(%struct.ident_t* @[[GLOB1]], i64 -1, i32 -1, i32 0, i8* @.{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z7host_ifb_l17.region_id, %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]])
// MANDATORY-NEXT:    [[TMP11:%.*]] = icmp ne i32 [[TMP10]], 0
// MANDATORY-NEXT:    br i1 [[TMP11]], label [[OMP_OFFLOAD_FAILED:%.*]], label [[OMP_OFFLOAD_CONT:%.*]]
// MANDATORY:       omp_offload.failed:
// MANDATORY-NEXT:    unreachable
// MANDATORY:       omp_offload.cont:
// MANDATORY-NEXT:    br label [[OMP_IF_END:%.*]]
// MANDATORY:       omp_if.else:
// MANDATORY-NEXT:    unreachable
// MANDATORY:       omp_if.end:
// MANDATORY-NEXT:    ret void
//
//
// MANDATORY-LABEL: define {{[^@]+}}@_Z8host_devi
// MANDATORY-SAME: (i32 noundef signext [[DEVICE:%.*]]) #[[ATTR0]] {
// MANDATORY-NEXT:  entry:
// MANDATORY-NEXT:    [[DEVICE_ADDR:%.*]] = alloca i32, align 4
// MANDATORY-NEXT:    [[DOTCAPTURE_EXPR_:%.*]] = alloca i32, align 4
// MANDATORY-NEXT:    store i32 [[DEVICE]], i32* [[DEVICE_ADDR]], align 4
// MANDATORY-NEXT:    [[TMP0:%.*]] = load i32, i32* [[DEVICE_ADDR]], align 4
// MANDATORY-NEXT:    store i32 [[TMP0]], i32* [[DOTCAPTURE_EXPR_]], align 4
// MANDATORY-NEXT:    [[TMP1:%.*]] = load i32, i32* [[DOTCAPTURE_EXPR_]], align 4
// MANDATORY-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
// MANDATORY-NEXT:    [[KERNEL_ARGS:%.*]] = alloca [[STRUCT___TGT_KERNEL_ARGUMENTS:%.*]], align 8
// MANDATORY-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 0
// MANDATORY-NEXT:    store i32 1, i32* [[TMP3]], align 4
// MANDATORY-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 1
// MANDATORY-NEXT:    store i32 0, i32* [[TMP4]], align 4
// MANDATORY-NEXT:    [[TMP5:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 2
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP5]], align 8
// MANDATORY-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 3
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP6]], align 8
// MANDATORY-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 4
// MANDATORY-NEXT:    store i64* null, i64** [[TMP7]], align 8
// MANDATORY-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 5
// MANDATORY-NEXT:    store i64* null, i64** [[TMP8]], align 8
// MANDATORY-NEXT:    [[TMP9:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 6
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP9]], align 8
// MANDATORY-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 7
// MANDATORY-NEXT:    store i8** null, i8*** [[TMP10]], align 8
// MANDATORY-NEXT:    [[TMP11:%.*]] = getelementptr inbounds [[STRUCT___TGT_KERNEL_ARGUMENTS]], %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]], i32 0, i32 8
// MANDATORY-NEXT:    store i64 0, i64* [[TMP11]], align 8
// MANDATORY-NEXT:    [[TMP12:%.*]] = call i32 @__tgt_target_kernel(%struct.ident_t* @[[GLOB1]], i64 [[TMP2]], i32 -1, i32 0, i8* @.{{__omp_offloading_[0-9a-z]+_[0-9a-z]+}}__Z8host_devi_l22.region_id, %struct.__tgt_kernel_arguments* [[KERNEL_ARGS]])
// MANDATORY-NEXT:    [[TMP13:%.*]] = icmp ne i32 [[TMP12]], 0
// MANDATORY-NEXT:    br i1 [[TMP13]], label [[OMP_OFFLOAD_FAILED:%.*]], label [[OMP_OFFLOAD_CONT:%.*]]
// MANDATORY:       omp_offload.failed:
// MANDATORY-NEXT:    unreachable
// MANDATORY:       omp_offload.cont:
// MANDATORY-NEXT:    ret void
//
//
// MANDATORY-LABEL: define {{[^@]+}}@.omp_offloading.requires_reg
// MANDATORY-SAME: () #[[ATTR3:[0-9]+]] {
// MANDATORY-NEXT:  entry:
// MANDATORY-NEXT:    call void @__tgt_register_requires(i64 1)
// MANDATORY-NEXT:    ret void
//
