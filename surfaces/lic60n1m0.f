C     Fede-----------------------------------------------------------------

C     -----------------------------------------
C     -Li@C60 Born-Oppenheimer type potential for n=1 m=0 electronic state-

C     #################################################################
C     #### WARNING: eps0 and w should be the same as in the op file ######
C     #################################################################
C     -----------------------------------------
C     INPUT:
C     R,theta: Separation of the Li from the C60 cage center. 
C      OUTPUT:
C     v     : 2-dimensional potential V(R,theta) of the Li@C60 under 
C             the influence of a laser field with polarization angle theta 
C             with respect to the Li-C60center line.
                module carga
        character*6 :: nombre_file_C60            
        integer :: imax_fullereno
        real*8 :: epsilon_LJ, sigma_LJ, conversion_ua, AA6_LJ, BB12_LJ
        real*8, dimension(3) :: rx_ref_LJ
        real*4, dimension(60,3) :: x_fullereno
                 end module  carga


      subroutine lic60n1m0(R,theta,v)      

C     externally used variables
      real*8  R,theta,v
C     internally used variables
      real*8  eps,omega,Rr,E0,E1,e,LJ,rho
      real*8  Rant,E0ant,rhoant,eant,E1ant,dE0,dE1,drho
      real*8  st,b,a1,a2
      real*4  pot
      integer Nt_max,NR,n,u
      character*11 a_in

      
      call lectura_LJ
      omega = 0.057d0   ![a.u.]
      eps = 0.009258d0   ![a.u.]
      a_in="LiC60_R.dat"
      Nt_max=52
      NR=302
      u=35
      open(unit=u, file=a_in, status="old")
      Rant=0.d0
      E0ant=0.d0
      rho=0.d0
      eant=0.d0
      do n=1,NR
       read(u,*) Rr,E0,e,LJ,rho
       if (Rr > R) exit
       Rant=Rr
       E0ant=E0
       rhoant=rho
       eant=e
       enddo
        if ( Rant < 1d-8 .or. Rant==Rr) then
        write(6,*)  
     +  'Required R value is lower than the first or greater'
        write(6,*) 'than the last grid point.'
        write(2,*)
     +  'Required R value is lower than the first or greater'
        write(2,*) 'than the last grid point.'
        stop
        endif
        LJ=dble(pot(real(R),(/0.0,0.0,1.0/)))
        E1ant = eant - omega + LJ
        E1 = e - omega + LJ
        
C       Interpolation of the energies because R is between the two grid values (Rant,Rr).
        dE0 = (E0-E0ant)/(Rr-Rant)
        E0 = E0ant + LJ + dE0*(R-Rant)
        drho= (rho-rhoant)/(Rr-Rant)
        rho=rhoant + drho*(R-Rant)
        dE1 = (E1-E1ant)/(Rr-Rant)
        E1 = E1ant + LJ + dE1*(R-Rant)
        
        
        st=sin(theta)/2
        b=eps*st
        a1=((E1+E0) + sqrt((E1-E0)**2 + 8*b**2*rho))/2
        a2=((E1+E0) - sqrt((E1-E0)**2 + 8*b**2*rho))/2
        if( a1>a2 ) then
            a=a1
            a1=a2
            a2=a
        endif
        !		write(u_s0,*) R,theta,a1
        v=a1
        close(u)
        return
      end      

      subroutine lectura_LJ 
      use carga
      implicit none

      integer :: i, j
      real*4, dimension(3) :: rx, rx_CM


      nombre_file_C60='C60-Ih'
      !conversion amstrongs a ua
      conversion_ua=0.52900000000000
      !numero de C
      imax_fullereno=60


!       allocate (x_fullereno(imax_fullereno,3))
      x_fullereno=0.00000000000000

      open(29,file=nombre_file_C60//'.dat',status='old')

      do i= 1,imax_fullereno,1
      read(29,*) x_fullereno(i,1), x_fullereno(i,2), x_fullereno(i,3)
      end do

      close(29)


      rx_CM=0.00000000000000

      do i=1,imax_fullereno,1
              do j=1,3,1
              rx(j) = x_fullereno(i,j)/conversion_ua
              end do
      rx_CM=rx_CM+rx
      end do

      rx_CM=rx_CM/float(imax_fullereno)

      do i= 1,imax_fullereno,1
              do j=1,3,1
              x_fullereno(i,j)=x_fullereno(i,j)/conversion_ua-rx_CM(j)
              end do

      end do

      end subroutine lectura_LJ 


      function pot(xxrr,rx_ref)
      use carga
      implicit none
      integer  :: i_v,j
      real*4 :: xxrr
      real*4, dimension(3) :: rx, rr, rx_ref
      real*4 :: distancia_cuadr, distancia12, distancia6, potencial,pot


      epsilon_LJ=0.0046527d0
      sigma_LJ=3.4759d0

      BB12_LJ=4.d0*epsilon_LJ*sigma_LJ**12
      AA6_LJ= 4.d0*epsilon_LJ*sigma_LJ**6


      potencial=0.0 

      rr=xxrr*rx_ref
                      
      do i_v=1,imax_fullereno,1
                              
              do j=1,3,1
              rx(j) = x_fullereno(i_v,j)
              end do
                      
      distancia_cuadr= dot_product((rr-rx),(rr-rx))
                      
      distancia12=distancia_cuadr**6
      distancia6=distancia_cuadr**3
                                      
      potencial=potencial+ BB12_LJ/distancia12-AA6_LJ/distancia6
      end do
              
      pot=potencial
              
      return
      end function
        
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

