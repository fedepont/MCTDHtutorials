      SUBROUTINE ho2sur(x,v)
      IMPLICIT NONE
      REAL*8 x(3), v
      write(6,'(a,/a)') '###########################################',
     +          'hoosrf is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'hoosrf is not linked. Run compile with -i option.'
      stop
      end

 
      function voh(r)
      implicit none
      real*8 r,voh
      write(6,'(a,/a)') '###########################################',
     +          'hoosrf is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'hoosrf is not linked. Run compile with -i option.'
      voh=0.d0
      stop
      end

