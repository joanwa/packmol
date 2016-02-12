!  
!  Written by Leandro Martínez, 2009-2011.
!  Copyright (c) 2009-2011, Leandro Martínez, Jose Mario Martinez,
!  Ernesto G. Birgin.
!  
!  This program is free software; you can redistribute it and/or
!  modify it under the terms of the GNU General Public License
!  as published by the Free Software Foundation; either version 2
!  of the License, or (at your option) any later version.
!  

subroutine compicart(itype,imol,iatom,icart)

  use sizes
  use molpa
  implicit none
      
  integer :: itype, imol, iatom, icart, i

  icart = natfix

  do i=1,itype-1
    icart = icart + nmols(i)*natoms(i)
  end do

  icart = icart + (imol-1)*natoms(itype)
  icart = icart + iatom

end subroutine compicart

subroutine compiluganbar(itype,imol,ilugan,ilubar)

  use sizes
  use molpa
  implicit none
      
  integer :: itype, imol, ilugan, ilubar, i

  ilubar = 0 
  ilugan = ntotmol*3 

  do i=1,itype-1
     if(comptype(i)) then
        ilubar = ilubar + 3*nmols(i)
        ilugan = ilugan + 3*nmols(i)
     end if
  end do

  if(comptype(itype)) then
     ilubar = ilubar + (imol-1)*3
     ilugan = ilugan + (imol-1)*3
  end if

end subroutine compiluganbar

subroutine comprindex(itype,imol,ind)

  use sizes
  use molpa
  implicit none
  
  integer :: itype, imol, ind, i

  ind = 0.d0

  do i=1,itype-1
     if(comptype(i)) then
        ind = ind + nmols(i)
     end if
  end do

  ind = ind + imol

end subroutine comprindex

!     Calculates the ceeling of a number x     
 
subroutine ceil(x,result)
      
  implicit none
  double precision :: x
  integer :: result

  if ((x - int(x)) .eq. 0) then
     result = int(x)
  else
     result = int(x) + 1
  end if
      
end subroutine ceil
