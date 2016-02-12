!  
!  Written by Ernesto G. Birgin, 2009-2011.
!  Copyright (c) 2009-2011, Jose Mario Martinez,
!  Ernesto G. Birgin.
!  
!  This program is free software; you can redistribute it and/or
!  modify it under the terms of the GNU General Public License
!  as published by the Free Software Foundation; either version 2
!  of the License, or (at your option) any later version.
!  
!
! Subroutine pgencan: This is only a interface to set some
!                    parameters. What might be important here
!                    is the setup of the constraint_axis constraint.
!

subroutine pgencan(n,x,fx)

  use sizes 
  use molpa
  use usegencan
  implicit none

  double precision :: lambda(1), rho(1), wd(8*nn)
  double precision :: epsgpsn,gpsupn,delmin
  double precision :: x(nn), l(nn), u(nn), fx, g(nn)
  double precision, parameter :: twopi = 2.d0 * 3.1415925655d0
  integer :: m,iprint,maxfc,ncomp,iter,fcnt,gcnt,cgcnt,inform
  integer :: wi(nn)
  integer :: n, i
  integer :: trtype1
  integer :: itype, imol

  m = 0

  ! Setup upper and lower bounds for variables. Usually there are none,
  ! but one might want to restrict the rotation of the molecules in one
  ! or more axis

  do i = 1,n/2
    l(i) = - 1.0d+20
    u(i) =   1.0d+20
  end do
  i = n/2
  do itype = 1, ntype
    do imol = 1, nmols(itype)
      if ( constrain_rot(itype,1) ) then
        l(i+1) = rot_bound(itype,1,1) - dabs(rot_bound(itype,1,2))
        u(i+1) = rot_bound(itype,1,1) + dabs(rot_bound(itype,1,2))
      else
        l(i+1) = 0.0d0
        u(i+1) = 1.0d0 * twopi
      end if
      if ( constrain_rot(itype,2) ) then
        l(i+2) = rot_bound(itype,2,1) - dabs(rot_bound(itype,2,2))
        u(i+2) = rot_bound(itype,2,1) + dabs(rot_bound(itype,2,2))
      else
        l(i+2) = 0.0d0
        u(i+2) = 1.0d0 * twopi
      end if
      if ( constrain_rot(itype,3) ) then
        l(i+3) = rot_bound(itype,3,1) - dabs(rot_bound(itype,3,2))
        u(i+3) = rot_bound(itype,3,1) + dabs(rot_bound(itype,3,2))
      else
        l(i+3) = 0.0d0
        u(i+3) = 1.0d0 * twopi
      end if
      i = i + 3
    end do
  end do

  epsgpsn = 1.0d-06
  maxfc   = 10 * maxit
  if(init1) iprint  = iprint1
  if(.not.init1) iprint  = iprint2
  ncomp   = 50
  delmin = 2.d0
  trtype1 = 1

  call easygencan(n,x,l,u,m,lambda,rho,epsgpsn,maxit,maxfc,&
                  trtype1,iprint,ncomp,fx,g,gpsupn,iter,fcnt,&
                  gcnt,cgcnt,inform,wi,wd,delmin)
  if( inform.ne.7 .and.(iprint1.gt.0 .or. iprint2.gt.0) ) write(*,*)

  return
end subroutine pgencan
