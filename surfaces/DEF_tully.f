      subroutine tully(x,y,z,r,theta,phi,epot,N_xy,N_z)

      implicit none
      real*8 x,y,z,r,theta,phi,epot
      integer N_xy,N_z


      write(6,'(a,/a)') '###########################################',
     +          'tully is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'tully is not linked. Run compile with -i option.'

      stop

      end
