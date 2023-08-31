C     -----------------------------------------
C     - Coulomb potential of Nitrogen (z) 
C     for 1e in the vacancy of the NV center (C3v symm)-
C     -----------------------------------------
C     INPUT:
C     r1...: coordinates of 1 electron in au 
C      OUTPUT:
C     v     : Coulomb potential energy in au

      
      subroutine Nc3vcoul(r1,theta1,v)      

C     externally used variables
      real*8  r1,theta1,v
C     internally used variables
      real*8  a,r,theta,d              

      a = 6.7463              ![a.u.], parameter for Diamond
      r=r1
      theta=theta1
      d=0.01d0                ! cut off

      v = 1.D0/sqrt(d**2+r**2+0.1875d0*a**2
     +                           -a*r*cos(theta)*sqrt(3.d0)*0.5d0)
 
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

