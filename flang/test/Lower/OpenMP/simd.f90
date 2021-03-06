! Tests for 2.9.3.1 Simd

! RUN: bbc -fopenmp -emit-fir %s -o - | FileCheck %s

!CHECK-LABEL: func @_QPsimdloop()
subroutine simdloop
integer :: i
  !$OMP SIMD
  ! CHECK: %[[LB:.*]] = arith.constant 1 : i32
  ! CHECK-NEXT: %[[UB:.*]] = arith.constant 9 : i32
  ! CHECK-NEXT: %[[STEP:.*]] = arith.constant 1 : i32
  ! CHECK-NEXT: omp.simdloop for (%[[I:.*]]) : i32 = (%[[LB]]) to (%[[UB]]) inclusive step (%[[STEP]]) {
  do i=1, 9
    ! CHECK: fir.store %[[I]] to %[[LOCAL:.*]] : !fir.ref<i32>
    ! CHECK: %[[LD:.*]] = fir.load %[[LOCAL]] : !fir.ref<i32>
    ! CHECK: fir.call @_FortranAioOutputInteger32({{.*}}, %[[LD]]) : (!fir.ref<i8>, i32) -> i1
    print*, i
  end do
  !$OMP END SIMD 
end subroutine

!CHECK-LABEL: func @_QPsimdloop_with_if_clause
subroutine simdloop_with_if_clause(n, threshold)
integer :: i, n, threshold
  !$OMP SIMD IF( n .GE. threshold )
  ! CHECK: %[[LB:.*]] = arith.constant 1 : i32
  ! CHECK: %[[UB:.*]] = fir.load %arg0
  ! CHECK: %[[STEP:.*]] = arith.constant 1 : i32
  ! CHECK: %[[COND:.*]] = arith.cmpi sge
  ! CHECK: omp.simdloop if(%[[COND:.*]]) for (%[[I:.*]]) : i32 = (%[[LB]]) to (%[[UB]]) inclusive  step (%[[STEP]]) {
  do i = 1, n
    ! CHECK: fir.store %[[I]] to %[[LOCAL:.*]] : !fir.ref<i32>
    ! CHECK: %[[LD:.*]] = fir.load %[[LOCAL]] : !fir.ref<i32>
    ! CHECK: fir.call @_FortranAioOutputInteger32({{.*}}, %[[LD]]) : (!fir.ref<i8>, i32) -> i1
    print*, i
  end do
  !$OMP END SIMD
end subroutine
