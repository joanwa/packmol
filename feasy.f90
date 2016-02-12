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
!
! Subroutine that computes the function value
!
!

subroutine feasy(x,f) 
      
  use sizes
  use molpa
  implicit none

  double precision x(nn), f
  call feasyseq(x,f)

  return
end subroutine feasy

