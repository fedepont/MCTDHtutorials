      subroutine lsth(x1,x2,x3,epot,imod,icoll)
      IMPLICIT REAL*8 (A-H,O-Z)
      implicit integer (i-n)
      write(6,'(a,/a)') '###########################################',
     +          'lsth is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'lsth is not linked. Run compile with -i option.'
      stop
      end

      subroutine vh2(r,v)
      real*8   r,v
      write(6,'(a,/a)') '###########################################',
     +  'v:H2 needed. lsth is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +  'v:H2 needed. lsth is not linked. Run compile with -i option.'
      stop
      end













