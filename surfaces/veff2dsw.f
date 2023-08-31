C    San-----------------------------------------------------------------
 
C     -----------------------------------------
C     -Effective 2d potential for 2 electrons in a square nano wire-
C     #################################################################
C     #### WARNING: m and w should be the same as in the op file ######
C     #################################################################
C     -----------------------------------------
C     INPUT:
C     z1,z2: longitudinal coordinates of 2 electrons in nm 
C      OUTPUT:
C     v     : Coulomb potential energy in nm

      subroutine veff2dsw(z1,z2,v)      

C     externally used variables
      real*8  z1,z2,v
C     internally used variables
      integer i, j
      integer err_apertura, err_lectura
      real*8  a,z!
      real*8  aunm, aueV
      real*8  veff(2,10001)
      character*100 archivo

       
      aunm = 0.05291772d0
      aueV = 27.211385d0
      z = abs(z1-z2)*aunm*12.9d0/0.063d0 !*a
      archivo='/home/pont/programas/mctdh85.6/source/surfaces/veff.dat'
      OPEN(7, file = archivo, IOSTAT = err_apertura)

      IF (err_apertura > 0) THEN
      WRITE(*,*)'ERROR EN LA APERTURA DE DATOS'
      STOP
      ENDIF

C      READ(7,*, IOSTAT = err_lectura) veff

C      IF (err_lectura > 0) THEN
C      WRITE(*,*)'ERROR EN LA LECTURA DE DATOS'
C      STOP
C      ENDIF

C      CLOSE(7)

      if ( z >= 499.90 ) then ! after 	this there is no more data en veff, but it should go like 1/z
      v = 1.d0/z*aunm*12.9d0/0.063d0
      else

      i = 1
      DO WHILE (z >= veff(1,i))
      READ(7,*, IOSTAT = err_lectura) veff(1,i),veff(2,i)
      i = i+1
      ENDDO
      CLOSE(7)

      v = (veff(2,i)-veff(2,i-1))
      v = v/(veff(1,i)-veff(1,i-1))
      v = v*(z-veff(1,i-1))
      v = v + veff(2,i-1)
      v = v*aunm*12.9d0/0.063d0
C      write(*,*) veff(1,i-1), veff(2,i-1)
C      write(*,*) veff(1,i),veff(2,i)
C      write(*,*) z, v
      endif
C      write(*,*) z, v
      i = 1

      return
      end     

C     San-----------------------------------------------------------------


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

