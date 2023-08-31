      SUBROUTINE h4bmkp(cc,Vfit,r,dVdcc,dVdr,Derr,ideriv)
      IMPLICIT REAL*8 (A-H,O-Z)
      dimension cc(4,3), r(6), dVdcc(4,3), dVdr(6)
      write(6,'(a,/a)') '###########################################',
     +          'h4bmkp is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'h4bmkp is not linked. Run compile with -i option.'
      stop
      end
