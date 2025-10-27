C#######################################################################
C     UFDEF1D       User-Function-DEFinition-1D
C
C 1D CURVES  defined by the user.
C See  opfuncs/func1d.F for examples.
C
C ifile = 304
C
C#######################################################################


      subroutine ufdef1d(ifunc,label,ifile,hopipar,hoprpar,
     +                   maxpar,hoppar)

      implicit none

      integer maxpar
      integer ifunc,ifile,hopipar(maxpar),ilbl,jlbl,np
      real*8  hoprpar(maxpar),hoppar(maxpar,*)
      character*64 label

C-----------------------------------------------------------------------
C get argument list no.
C-----------------------------------------------------------------------
      np=0
      ilbl=index(label,'[')+1
      if (ilbl .gt. 1) then
         jlbl = index(label,']')-1
         read(label(ilbl:jlbl),*) np
      endif

C-----------------------------------------------------------------------
C get end of operator label
C-----------------------------------------------------------------------
      ilbl=index(label,'[')-1
      if (ilbl .lt. 0) ilbl=index(label,' ')-1


C-----------------------------------------------------------------------
C now assign function number
C Note: hopipar(1) and hoprpar(1) are reserved for the exponent.
C The exponent was read in defanld (opfuncs/callanld.f).
C-----------------------------------------------------------------------

C my1d: my1d^r  (provide subroutine on file: user1d.F)
      if (label(1:ilbl) .eq. 'my1d') then
         if (np .gt.0) then
            hoprpar(2)=hoppar(1,np)
            hoprpar(3)=hoppar(2,np)
            hoprpar(4)=hoppar(3,np)
            hoprpar(5)=hoppar(4,np)
            hoprpar(6)=hoppar(5,np)
         else
            hoprpar(2)=0.d0
            hoprpar(3)=0.d0
            hoprpar(4)=0.d0
            hoprpar(5)=0.d0
            hoprpar(6)=0.d0
         endif
         ifunc=1

C newfunc     ! This is, of course, just an example.
C     elseif (label(1:ilbl) .eq. 'newfunc') then
C        ifunc=2


C-----------------------------------------------------------------------
C end of if loop
C-----------------------------------------------------------------------
      endif

C-----------------------------------------------------------------------
C if label is assigned, assign ifile no.
C-----------------------------------------------------------------------
      if (ifunc .ne. 0) ifile=304

      return
      end


C#######################################################################
C  UFUNC1D    User-Functions-1D
C
C Define here new user specific, real 1D functions.
C See funcanld.F for examples.
C#######################################################################

      subroutine ufunc1d(v,x,ifunc,hopipar,hoprpar)

      implicit none

#include "global.inc"

      integer ifunc,hopipar(*)
      real*8  hoprpar(*)
      real*8  v,x


C Decide which function to call, accroding to ifunc

      if (ifunc .eq. 1) then
        call my1d(x,v,hoprpar(2),hoprpar(3),hoprpar(4),
     +                hoprpar(5),hoprpar(6))

C newfunc EXAMPLE
C Set here the routine you want to call
C
C     elseif (ifunc .eq. 2) then
C       call newfunc(x,v)

      else
        routine='ufunc1d (opfuncs/user1D.F)'
        write(message,'(a,i5)') 'Function not found :',ifunc
        call errormsg
      endif

C Apply exponent.
      if(hopipar(1).eq.0) then
         v=v**hoprpar(1)
      elseif(hopipar(1).ne.1) then
         v=v**hopipar(1)
      endif
      return

      end


C#######################################################################
C#######################################################################
C
C                     my1d
C
C User supplied real 1D potential with parameters.
C Edit the following routine according to your demands.
C Note that my1d is called from subroutine funcanld.
C See fdefanld and funcanld on opfuncs/funcanld.F
C
C#######################################################################

      subroutine my1d(x,v,par1,par2,par3,par4,par5)

      implicit none

      real*8  x,v,par1,par2,par3,par4,par5

C-----------------------------------------------------------------------
C--- Place your routine here and outcomment write and stop.
C--- You may use the keyword my1d directly in the operator tableau
C--- of the Hamiltinian-Section, if you make no use of the parameters.
C--- (They will all be set to zero).
C--- With parameters you have to use a LABELS-SECTION like:
C---     LABELS-SECTION
C---        my = my1d[p1,p2,p3,p4,p5]
C---     end-labels-section
C--- where p1...p5 are (real) numbers or parameters, and then use my
C--- (or my^n) within the operator tableau (Hamiltonian-Section).
C--- If you do not need all parameters, use only the first ones and
C--- ignore the last ones. Example:
C---   v = sqrt( par1 + par2*cos(par3*x)**par4 )
C---
C--- You may define several functions by letting par1 make the selection.
C--- E.g.:
C---
C---  if( abs(par1-1.d0) .lt. 1.d-4 ) then
C---     <code of first routine>
C---  elseif( abs(par1-3.d0) .lt. 1.d-4 ) then
C---     <code of second routine>
C---  elseif( abs(par1-3.d0) .lt. 1.d-4 ) then
C---     <code of third routine>
C---  endif
C---  return
C---  end
C-----------------------------------------------------------------------

      write(6,'(/a/a/a/a/)')
     +     '##################################################',
     +     ' ERROR: You have first to edit the subroutine my1d',
     +     '  (lines 135-195 on opfuncs/user1d.F)',
     +     '      STOP '

      stop

C      return
      end

C#######################################################################

