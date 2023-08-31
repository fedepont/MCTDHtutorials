      real*8 function licnsrf (k,r,error)
      real*8  r
      integer k,error
      write(6,'(a,/a)') '###########################################',
     +          'licnsrf is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'licnsrf is not linked. Run compile with -i option.'
      licnsrf=0.d0
      stop
      end


