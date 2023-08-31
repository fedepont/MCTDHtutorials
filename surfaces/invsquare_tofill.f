C     Fede-----------------------------------------------------------------

C     -----------------------------------------
C     -inverse squared potential in 1D-
C     -----------------------------------------
C     INPUT:
C     z1,z2: longitudinal coordinates of 2 electrons in au 
C      OUTPUT:
C     v     : Coulomb potential energy in au

      subroutine invsquare(z1,z2,v)      

C     externally used variables
      real*8  z1,z2,v
C     internally used variables
      a=DDD
      v = 1.d0/((z1-z2)**2+a**2)

      return
      end      

C     Fede-----------------------------------------------------------------


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

