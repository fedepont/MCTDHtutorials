C     Fede-----------------------------------------------------------------

C     -----------------------------------------
C     -Spherical Coulomb potential = 1/r_> for 2 electrons-
C     -----------------------------------------
C     INPUT:
C     r1,r2: radial coordinates of 2 electrons in au 
C      OUTPUT:
C     v     : Coulomb potential energy in au

      subroutine sphcou(r1,r2,v)      

C     externally used variables
      real*8  r1,r2,v
C     internally used variables
      real*8  r
     
      r = r1-r2
      
      if ( r > 0.0d0 ) then 
      v = 1.d0/r1
      else
      v= 1.d0/r2
      endif

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

