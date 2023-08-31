      subroutine i2ar_0_2d(rr_p,theta_p,v_p)
      real*8 rr_p,theta_p,v_p
      write(6,'(a,/a)') '###########################################',
     +          'i2ar is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'i2ar is not linked. Run compile with -i option.'
      write(6,*) 'i2ar_0_2d'
      stop
      end
      
      subroutine fdefi2ar(ifunc,label,ifile,ipar,rpar,maxpar,hoppar)
      integer maxpar
      integer ifunc,ifile,ipar(maxpar)
      real*8  rpar(maxpar),hoppar(maxpar,*)
      character*(*) label
      return
      end
      
      subroutine fi2ar(v,x,ifunc,ipar,rpar)
      integer ifunc,ipar(*)
      real*8 v,x,rpar(*)
      write(6,'(a,/a)') '###########################################',  
     +          'i2ar is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',  
     +          'i2ar is not linked. Run compile with -i option.'
      stop
      end
      
      subroutine i2ar_dim_init(matdim,matrow,matcol,raregas,
     &   ierr,message)
      integer matdim,ierr
      character*(*) matrow,matcol,raregas,message
      write(6,'(a,/a)') '###########################################',
     +          'i2ar is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'i2ar is not linked. Run compile with -i option.'
      write(6,*) 'i2ar_dim_init'
      stop
      end
      
      subroutine i2ar_dim(r,rcm,theta_cm,matrix_element)
      real*8 r,rcm,theta_cm,matrix_element
      write(6,'(a,/a)') '###########################################',  
     +          'i2ar is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',  
     +          'i2ar is not linked. Run compile with -i option.'
      write(6,*) 'i2ar_dim'
      stop
      end

