C     -----------------------------------------
C     - Coulomb potential of three Carbons 
C     for 1e in the vacancy of the NV center (C3v symm)-
C     -----------------------------------------
C     INPUT:
C     r1...: coordinates of 1 electron in au 
C      OUTPUT:
C     v     : Coulomb potential energy in au

      
      subroutine Cc3vcoul(r1,theta1,phi1,v)      

C     externally used variables
      real*8  r1,theta1,phi1,v
C     internally used variables
      real*8  a,r,theta,phi,pi,d              

      a = 6.7463              ![a.u.], parameter for Diamond
      d = 0.01                ![a.u.], cut off
      r=r1
      theta=theta1
      phi=phi1
      pi = 4.0d0*atan(1.0d0)

      v = 1.D0/sqrt(d**2+r**2+0.1875d0*a**2
     +    -a*r*(sqrt(2.d0/3.d0)*sin(theta)*cos(phi)
     +    -0.5d0/sqrt(3.d0)*cos(theta)))

      v = v + 1.D0/sqrt(d**2+r**2+0.1875d0*a**2
     +    -a*r*(sqrt(2.d0/3.d0)*sin(theta)*cos(phi + 2.d0*pi/3.d0)
     +    -0.5d0/sqrt(3.d0)*cos(theta)))

      v = v + 1.D0/sqrt(d**2+r**2+0.1875d0*a**2
     +    -a*r*(sqrt(2.d0/3.d0)*sin(theta)*cos(phi - 2.d0*pi/3.d0)
     +    -0.5d0/sqrt(3.d0)*cos(theta)))
 
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

