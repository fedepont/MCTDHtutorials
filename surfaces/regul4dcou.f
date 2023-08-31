C     Anni-----------------------------------------------------------------

C     -----------------------------------------
C     - 4dim Coulomb potential for 2 electrons -
C     -----------------------------------------
C     INPUT:
C     x1..z2: coordinates of 2 electrons in au 
C      OUTPUT:
C     v     : Coulomb potential energy in au

      
      subroutine regul4dcou(x1,z1,x2,z2,v)      

C     externally used variables
      real*8  x1,z1,x2,z2,v
C     internally used variables
      real*8  a,b,x,z,r              

      a = 0.01                ![a.u.], parameter

      x = x1-x2
      z = z1-z2

      r = a**2 !regularization parameter

      v = 1.D0/sqrt(x**2+z**2+r)

      return
      end      

C     Anni-----------------------------------------------------------------


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

