C     Fede-----------------------------------------------------------------

C     -----------------------------------------
C     -Modified GAussian exp(-x^p) potential-
C     -----------------------------------------
C     INPUT:
C     x1,x2: coordinates of 2 electrons in au 
C      OUTPUT:
C     v     : gaussp potential energy in au

      subroutine gaussp(x1,x2,v)      

C     externally used variables
      real*8  x1,x2,v
C     internally used variables
      real*8  x,logv,dosp,s
      integer p
     
      x = x1-x2
      p = 1
      s = 1.0d0
      dosp= 2.d0*p

      logv = -(x/s)**(dosp)
      v= exp(logv)

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

