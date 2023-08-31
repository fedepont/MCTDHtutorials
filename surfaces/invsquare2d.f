C     Fede-----------------------------------------------------------------

C     -----------------------------------------
C     -inverse squared potential in 2D-
C     -----------------------------------------
C     INPUT:
C     x1,y1,x2,y2: in plane coordinates of 2 electrons in au 
C      OUTPUT:
C     v     : Coulomb potential energy in au

      subroutine invsquare2d(x1,y1,x2,y2,v)      

C     externally used variables
      real*8  x1,y1,x2,y2,v
C     internally used variables
      a=5d-1
      v = 1.d0/((x1-x2)**2+ (y1-y2)**2 +a**2)

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

