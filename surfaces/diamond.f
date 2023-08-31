C     -----------------------------------------
C     - Coulomb potential of three Carbons 
C     for 1e in the vacancy of the NV center (C3v symm)-
C     -----------------------------------------
C     INPUT:
C     r1...: coordinates of 1 electron in au 
C      OUTPUT:
C     v     : Coulomb potential energy in au

      
      subroutine diamond(x,y,z,v)      

C     externally used variables
      real*8  x,y,z,v
C     internally used variables
      real*8  r(3),ri(3),alfa,pot,dist2
      integer n,ix,iy,iz,gdim              
      logical test1, test2

      alfa=8.d0
      r=(/x,y,z/)
C     --Tamaño de la grilla en unidades de b=a/4. a = lado del cubo.
      gdim=8
C     -----------------------------------------------------------
      n=0
      v=0.d0
      pot=0.d0
      do ix=-gdim,gdim
      do iy=-gdim,gdim
      do iz=-gdim,gdim
       test1=(modulo(ix,2)==modulo(iy,2).and.modulo(ix,2)==modulo(iz,2))
       test2=(modulo(ix+iy+iz,4)==0.or.modulo(ix+iy+iz,4)==1)
       if (test1 .and. test2) then
         ri=(/dble(ix),dble(iy),dble(iz)/)
         dist2=dot_product(r-ri,r-ri)
         pot=exp(-dist2*alfa)
         v=pot + v
         n=n+1
       endif
      enddo
      enddo
      enddo

      return
      end      


C--------------------------------------------------------------------------
C Place here your own potential energy routine (and remove the lines above).
C E.g.:
C     subroutine mysrf(r1,r2,theta,phi,v)
C        .... FORTRAN TEXT ..
C     return
C     end
C
C NOTE: You also have to modify the file source/opfuncs/usersrf.F
C       Subroutine uvpoint   and   subroutine usersurfinfo. 
C       Please edit the text accordingly.
C
C       You may name the coordinates as you like, but make sure that their 
C       ordering is appropriate. The variable v contains the energy value 
C       on return, i.e. v = V(r1,r2,theta,phi) 
C--------------------------------------------------------------------------

