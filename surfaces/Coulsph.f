C     Anni-----------------------------------------------------------------

C     -----------------------------------------
C     - 6dim Coulomb potential for 2 electrons in Spherical Coord -
C     -----------------------------------------
C     INPUT:
C     r1..phi2: coordinates of 2 electrons in au 
C      OUTPUT:
C     v     : Coulomb potential energy in au

      
      subroutine Coulsph(r1,theta1,phi1,r2,theta2,phi2,v)      

C     externally used variables
      real*8  r1,theta1,phi1,r2,theta2,phi2,v
C     internally used variables
      real*8  a,b,x,y,z,r              

      a = 0.01                ![a.u.], parameter

      cosgamma = dcos(theta1)*dcos(theta2)
     +                +dsin(theta1)*dsin(theta2)*dcos(phi1-phi2)

      r = a**2 !regularization parameter

      v = 1.D0/sqrt(r1**2 + r2**2 - 2.d0*r1*r2*cosgamma + r)

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

