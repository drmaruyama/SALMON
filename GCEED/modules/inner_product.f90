! Copyright 2017 Katsuyuki Nobusada, Masashi Noda, Kazuya Ishimura, Kenji Iida, Maiku Yamaguchi
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.


MODULE inner_product_sub

use scf_data
use new_world_sub
implicit none

INTERFACE inner_product

  MODULE PROCEDURE R_inner_product, C_inner_product

END INTERFACE

CONTAINS

!=======================================================================
subroutine R_inner_product(matbox1,matbox2,rbox2)
!$ use omp_lib
implicit none
integer :: ix,iy,iz
real(8) :: matbox1(iwk3sta(1):iwk3end(1),iwk3sta(2):iwk3end(2),iwk3sta(3):iwk3end(3))
real(8) :: matbox2(iwk3sta(1):iwk3end(1),iwk3sta(2):iwk3end(2),iwk3sta(3):iwk3end(3))
real(8) :: rbox,rbox2

rbox=0.d0
!$omp parallel do reduction(+ : rbox)
do iz=iwk3sta(3),iwk3end(3)
do iy=iwk3sta(2),iwk3end(2)
do ix=iwk3sta(1),iwk3end(1)
  rbox=rbox+matbox1(ix,iy,iz)*matbox2(ix,iy,iz)
end do
end do
end do

if(iwk_size>=1.and.iwk_size<=2)then
  call MPI_Allreduce(rbox,rbox2,1,MPI_DOUBLE_PRECISION,MPI_SUM,newworld_comm_orbital,ierr)
else if(iwk_size>=11.and.iwk_size<=12)then
  call MPI_Allreduce(rbox,rbox2,1,MPI_DOUBLE_PRECISION,MPI_SUM,newworld_comm_h,ierr)
else
  write(*,*) "iwk_size is not set" 
  stop
end if

end subroutine R_inner_product

!=======================================================================
subroutine C_inner_product(matbox1,matbox2,cbox2)
!$ use omp_lib
implicit none
integer :: ix,iy,iz
complex(8) :: matbox1(iwk3sta(1):iwk3end(1),iwk3sta(2):iwk3end(2),iwk3sta(3):iwk3end(3))
complex(8) :: matbox2(iwk3sta(1):iwk3end(1),iwk3sta(2):iwk3end(2),iwk3sta(3):iwk3end(3))
complex(8) :: cbox,cbox2

cbox=0.d0
!$omp parallel do reduction(+ : cbox)
do iz=iwk3sta(3),iwk3end(3)
do iy=iwk3sta(2),iwk3end(2)
do ix=iwk3sta(1),iwk3end(1)
  cbox=cbox+conjg(matbox1(ix,iy,iz))*matbox2(ix,iy,iz)
end do
end do
end do

if(iwk_size>=1.and.iwk_size<=2)then
  call MPI_Allreduce(cbox,cbox2,1,MPI_DOUBLE_COMPLEX,MPI_SUM,newworld_comm_orbital,ierr)
else if(iwk_size>=11.and.iwk_size<=12)then
  call MPI_Allreduce(cbox,cbox2,1,MPI_DOUBLE_COMPLEX,MPI_SUM,newworld_comm_h,ierr)
else
  write(*,*) "iwk_size is not set" 
  stop
end if

end subroutine C_inner_product

END MODULE inner_product_sub
