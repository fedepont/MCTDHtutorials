C#######################################################################
C 
C                              Module  LSTH
C
C  This module contains a set of subroutines to calculate the LSTH
C  potential energy surface of H3 for collinear or general
C  configurations or the 1D potential curve of H2.
C  For more details on the LSTH surface see D.G.Truhlar and
C  C.J.Horowitz, JCP 68, 2466 (1978) and JCP 71, 1541 (1979).
C  The 1D H2 potential is a 87 node spline fit of Truhlar and
C  Horowitz to the data of W.Kolos and L.Woliniewicz JCP 43, 2429
C  (1965).
C
C  Note: For bond lengths smaller than 0.4 au the H3 and the H2
C        potential are NOT defined and the program stops !!!
C  Note: To set the spline data a Block Data named lsthdat with
C        two named Common Blocks lsthdata and lsthdatb are
C        provided --> Do not give any of your Block Datas or
C        Common Blocks these names for any other purpose !!!
C
C  1) To calculate the H3 potential for collinear or general 
C     configurations call
C
C               call lsth(x1,x2,x3,epot,imod,icoll)
C
C  INPUT:
C    x1,x2,x3: Bond lengths in au
C    imod    : Controls whether one or more H2 potential contributions
C              shall be subtracted from the total potential energy
C              imod == 1  --> subtract VH2(x1)
C              imod == 2  --> subtract VH2(x2)
C              imod == 12 --> subtract VH2(x1) and VH2(x2)
C              else       --> do not subtract 
C    icoll   : icoll == 1 --> Calculate potential energy of collinear
C                             configuration (x3 is set to x1+x2)
C              else  --> Calculate potential energy of configuration 
C                        defined by x1, x2 and x3
C  OUTPUT:
C    epot    : Potential energy in au
C
C
C   2) To calculate the 1D H2 potential
C 
C                   call vh2(r,v)
C
C   INPUT:
C         r: H2 distance in au
C
C   OUTPUT:
C         v: Potential energy in au
C
C#######################################################################


C***********************************************************************
C
C                  Subroutine    LSTH
C
C
C***********************************************************************
  
      subroutine lsth(x1,x2,x3,epot,imod,icoll)

      IMPLICIT REAL*8 (A-H,O-Z)
      implicit integer (i-n)

      integer nspl
      parameter (nspl=87)

      real*8  x(3),x1,x2,x3

      real*8  rkw(nspl),ekw(nspl),wkw(nspl)

      COMMON /lsthdata/ C6,C8,RKW,EKW,WKW
      save /lsthdata/

      COMMON /lsthdatb/ C,A,A1,F,FN,FB1,FB2,FB3,XN1,XN2,XN3,XN4,B1,B2,B3
     +     ,G1,G2,G3,D1,D2,D3,D4,XL1,XL2
      save /lsthdatb/

C-----------------------------------------------------------------------
C Define x(3) according to icoll
C-----------------------------------------------------------------------
      x(1) = x1
      x(2) = x2
      if (icoll.eq.1) then
         x(3) = x1+x2
      else
         x(3) = x3  
      endif

C-----------------------------------------------------------------------
C Check minimal bond lengths
C-----------------------------------------------------------------------
      do m=1,3
         if (x(m).lt.0.4d0) then
            write (6,*) 
     +       'Potential not defined for distances smaller than 0.4 au'
            stop
         endif
      enddo

C=======================================================================
C E LONDON
C=======================================================================
      EF1=EXP(-F*X(1))
      EF2=EXP(-F*X(2))
      EF3=EXP(-F*X(3))
      X21=X(1)*X(1)
      X22=X(2)*X(2)
      X23=X(3)*X(3)
      T1=C*(A+X(1)+A1*X21)*EF1
      T2=C*(A+X(2)+A1*X22)*EF2
      T3=C*(A+X(3)+A1*X23)*EF3

      CALL VPOTH2(X,S1,S2,S3)

C-----------------------------------------------------------------------
C 2 Q(R_i) = V_H2(R_i) + ^3E(R_i) 
C-----------------------------------------------------------------------
      XQ1=S1+T1
      XQ2=S2+T2
      XQ3=S3+T3

C-----------------------------------------------------------------------
C 2 J(R_i) = V_H2(R_i) - ^3E(R_i) 
C-----------------------------------------------------------------------
      XJ1=S1-T1
      XJ2=S2-T2
      XJ3=S3-T3

C-----------------------------------------------------------------------
C Sum_{i=1}^3 [ Q(R_i) ]
C-----------------------------------------------------------------------
      XQ=(XQ1+XQ2+XQ3)/2.D0

C-----------------------------------------------------------------------
C -Sqrt[ 0.5 Sum_{i>j}[ J(R_i) - J(R_j) ]**2 ]
C-----------------------------------------------------------------------
      XJ=SQRT(((XJ1-XJ2)**2+(XJ2-XJ3)**2+(XJ3-XJ1)**2)/8.D0)

      ELOND=XQ-XJ

C=======================================================================
C ENS is V_a (R_1,R_2,R_3) of Truhlar paper
C=======================================================================

C-----------------------------------------------------------------------
C Exp[ -alpha_5 (R1+R2+r3)**3]
C-----------------------------------------------------------------------
      RR    = X(1)+X(2)+X(3)
      RR2   = RR*RR
      RR3   = RR2*RR
      EXNS  = EXP(-FN*RR3)

      ENS = 0.D0
      IF (EXNS.EQ.0.D0) then
         if (icoll.eq.1) then
            goto 20
         else
            goto 10
         endif
      endif

C-----------------------------------------------------------------------
C WN is A(R1,R2,R3) of Truhlar paper
C-----------------------------------------------------------------------
      WNT = (X(1)-X(2))*(X(2)-X(3))*(X(3)-X(1))
      WN  = ABS(WNT)
      WN2 = WN*WN
      WN3 = WN2*WN
      WN4 = WN3*WN
      WN5 = WN4*WN

      ENS = (XN1*WN2+XN2*WN3+XN3*WN4+XN4*WN5)*EXNS

      if (icoll.eq.1) goto 20

C-----------------------------------------------------------------------
C NONLINEAR CORRECTIONS
C-----------------------------------------------------------------------
 10   COS =(X21+X22+X23)/2.D0
      COS1=(X21-COS)/X(2)/X(3)
      COS2=(X22-COS)/X(1)/X(3)
      COS3=(X23-COS)/X(1)/X(2) 
      WB=COS1+COS2+COS3+1.D0
      WB2=WB*WB
      WB3=WB2*WB 
      WB4=WB3*WB
      EXF1=EXP(-FB1*RR)
      EXF2=EXP(-FB2*RR2)
      EXF3=EXP(-FB3*RR)
      EB1T=(B1+B2*RR)*EXF1
      EB3T=(XL1+XL2*RR2)*EXF3
      EB1=WB*(EB1T+EB3T)
      EB2=(WB2*G1+WB3*G2+WB4*G3)*EXF2
      EQ=(X(1)-X(2))**2+(X(2)-X(3))**2+(X(3)-X(1))**2
      RI=1.D0/X(1)+1.D0/X(2)+1.D0/X(3)
      EB4A=WB*D1*EXF1+WB2*D2*EXF2
      EB4B=D3*EXF1+D4*EXF2
      EB4=EB4A*RI+EB4B*WB*EQ

C-----------------------------------------------------------------------
C Get collinear or 3D potential value in [au]
C-----------------------------------------------------------------------
 20   if (icoll.eq.1) then
         Epot=ELOND+ENS
      else
         Epot=ELOND+ENS+EB1+EB2+EB4 
      endif

C-----------------------------------------------------------------------
C Subtract H2 potential contribution depending on "imod"
C-----------------------------------------------------------------------
      if (imod.eq.1) then
         epot = epot-s1
      elseif (imod.eq.2) then
         epot = epot-s2         
      elseif (imod.eq.12) then
         epot = epot-s1-s2
      endif

      RETURN
      END



C***********************************************************************
C             
C                        VH2
C
C              {     V_spline(R)     0.4 au <= R <= 10 au
C    V_H2(R) = {
C              {  -C6/R^6 - C8/R^8         R > 10 au
C
C***********************************************************************

      subroutine vh2(r,v)


      real*8   r,v

      integer   nspl,one
      parameter (nspl=87,one=1)

      real*8 c6,c8,rkw(nspl),ekw(nspl),wkw(nspl)
      common /lsthdata/ c6,c8,rkw,ekw,wkw
      save /lsthdata/

      if (r.gt.10d0) then
         call h2vdw(r,v)
      elseif (r.ge.0.4d0) then
         call h2spline(nspl,rkw,ekw,wkw,one,r,v)
      else
         write (6,*) 
     +        'Potential not defined for distances smaller than 0.4 au'
         stop
      endif

      return
      end


C***********************************************************************
C             
C                        VPOTH2
C
C                {     V_spline(R_i)     0.4 au <= R_i <= 10 au
C    V_H2(R_i) = {
C                {  -C6/R_i^6 - C8/R_i^8         R_i > 10 au
C
C         i=1,2,3
C
C***********************************************************************

      SUBROUTINE VPOTH2(X,S1,S2,S3)


      real*8   x(3),s1,s2,s3

      real*8 c6,c8,rkw(87),ekw(87),wkw(87)
      COMMON /lsthdata/ C6,C8,RKW,EKW,WKW
      save /lsthdata/

      integer   n,ione
      parameter (n=87,ione=1)


      IF (X(1).GT.10.D0) CALL H2VDW(X(1),S1)
      IF (X(1).GT.10.D0) GO TO 2
      CALL H2SPLINE(n,RKW,EKW,WKW,ione,X(1),S1)

 2    IF (X(2).GT.10.D0) CALL H2VDW(X(2),S2)
      IF (X(2).GT.10.D0) GO TO 3
      CALL H2SPLINE(n,RKW,EKW,WKW,ione,X(2),S2)

 3    IF (X(3).GT.10.D0) CALL H2VDW(X(3),S3)
      IF (X(3).GT.10.D0) RETURN
      CALL H2SPLINE(n,RKW,EKW,WKW,ione,X(3),S3)

      RETURN
      END


C***********************************************************************
C
C                     H2SPLINE
C
C  Cubic spline representation of H2 potential 
C  (see e.g. Bronstein, p.759 for more details)
C
C Input:
C  n  :  number of spline points
C  x  :  spline points
C  f,w:  spline data 
C  ij :  1
C  y  :  point at which spline value is calculated
C
C Output:
C  tab:  spline value
C***********************************************************************

      SUBROUTINE H2SPLINE(N,X,F,W,IJ,Y,TAB)

      IMPLICIT REAL*8 (A-H,O-Z)
      implicit integer (i-n)

      dimension x(n),f(n),w(n)

      IF (Y-X(1)) 10,10,20
   10 I=1
      GO TO 30
   20 IF (Y-X(N)) 15,40,40
   40 I=N-1
      GO TO 30
   15 I=0
      do K=1,N
         IF (X(K).GT.Y) GO TO 30
         I   = I+1
      enddo
   30 MI  = (I-1)*IJ+1
      KI  = MI+IJ
      FLK = X(I+1)-X(I)
      A   = (W(MI)*(X(I+1)-Y)**3+W(KI)*(Y-X(I))**3)/(6.D0*FLK)
      B   = (F(KI)/FLK-W(KI)*FLK/6.D0)*(Y-X(I))
      C   = (F(MI)/FLK-FLK*W(MI)/6.D0)*(X(I+1)-Y)
      TAB = A+B+C

      RETURN
      END

C***********************************************************************
C
C                   H2VDW
C
C   Calculate H2 potential for x > 10 au
C 
C***********************************************************************

      SUBROUTINE H2VDW(X,S)

      IMPLICIT none

      real*8 x,s,c6,c8,x2,x3,x6,c8a

      parameter(c6=6.89992032D0, c8=219.9997304D0)

      X2   = X*X
      X3   = X2*X
      X6   = X3*X3
      C8A  = C8/X2
      S    = -(C6+C8A)/X6

      RETURN
      END



C***********************************************************************
C
C                     LSTHDAT
C
C***********************************************************************

      BLOCK DATA lsthdat

      IMPLICIT REAL*8 (A-H,O-Z)
      implicit integer (i-n)

      COMMON /lsthdata/ C6,C8,RKW(87),EKW(87),WKW(87)
      save /lsthdata/

      COMMON /lsthdatb/ C,A,A1,F,FN,FB1,FB2,FB3,XN1,XN2,XN3,XN4,B1,B2,B3
     1     ,G1,G2,G3,D1,D2,D3,D4,XL1,XL2
      save /lsthdatb/

      DATA C6,C8/6.89992032D0,219.9997304D0/

      DATA C,A,A1,F/-1.2148730613D0,-1.514663474D0,-1.46D0,2.088442D0/

      DATA FN,XN1,XN2,XN3,XN4/.0035D0,.0012646477D0,-.0001585792D0,
     1     .0000079707D0,-.0000001151D0/

      DATA FB1,B1,B2/.52D0,3.0231771503D0,-1.08935219D0/

      DATA FB2,G1,G2,G3/.052D0,1.7732141742D0,-2.0979468223D0,
     1     -3.978850217D0/

      DATA D1,D2,D3,D4/.4908116374D0,-.8718696387D0,.1612118092D0,
     1     -.1273731045D0/

      DATA FB3,XL2,XL1/.79D0,.9877930913D0,-13.3599568553D0/

      DATA (RKW(I),I=1,40)/
     1 .400000000D+00, .450000000D+00, .500000000D+00, .550000000D+00,
     2 .600000000D+00, .650000000D+00, .700000000D+00, .750000000D+00,
     3 .800000000D+00, .900000000D+00, .100000000D+01, .110000000D+01,
     4 .120000000D+01, .130000000D+01, .135000000D+01, .139000000D+01,
     5 .140000000D+01, .140100001D+01, .140109999D+01, .141000000D+01,
     6 .145000000D+01, .150000000D+01, .160000000D+01, .170000000D+01,
     7 .180000000D+01, .190000000D+01, .200000000D+01, .210000000D+01,
     8 .220000000D+01, .230000000D+01, .240000000D+01, .250000000D+01,
     9 .260000000D+01, .270000000D+01, .280000000D+01, .290000000D+01,
     9 .300000000D+01, .310000000D+01, .320000000D+01, .330000000D+01/
      DATA (RKW(I),I=41,87)/
     1 .340000000D+01, .350000000D+01, .360000000D+01, .370000000D+01,
     2 .380000000D+01, .390000000D+01, .400000000D+01, .410000000D+01,
     3 .420000000D+01, .430000000D+01, .440000000D+01, .450000000D+01,
     4 .460000000D+01, .470000000D+01, .480000000D+01, .490000000D+01,
     5 .500000000D+01, .510000000D+01, .520000000D+01, .530000000D+01,
     6 .540000000D+01, .550000000D+01, .560000000D+01, .570000000D+01,
     7 .580000000D+01, .590000000D+01, .600000000D+01, .610000000D+01,
     8 .620000000D+01, .630000000D+01, .640000000D+01, .650000000D+01,
     9 .660000000D+01, .670000000D+01, .680000000D+01, .690000000D+01,
     9 .700000000D+01, .720000000D+01, .740000000D+01, .760000000D+01,
     1 .780000000D+01, .800000000D+01, .824999991D+01, .850000000D+01,
     2 .900000000D+01, .950000000D+01, .100000000D+02/

      DATA (EKW(I),I=1,40)/
     1 .879796188D+00, .649071056D+00, .473372447D+00, .337228924D+00,
     2 .230365628D+00, .145638432D+00, .779738117D-01, .236642733D-01,
     3-.200555771D-01,-.836421044D-01,-.124538356D+00,-.150056027D+00,
     4-.164934012D+00,-.172345701D+00,-.173962500D+00,-.174451499D+00,
     5-.174474200D+00,-.174474400D+00,-.174474400D+00,-.174459699D+00,
     6-.174055600D+00,-.172853502D+00,-.168579707D+00,-.162456813D+00,
     7-.155066822D+00,-.146849432D+00,-.138131041D+00,-.129156051D+00,
     8-.120123163D+00,-.111172372D+00,-.102412583D+00,-.939271927D-01,
     9-.857809026D-01,-.780163108D-01,-.706699181D-01,-.637640270D-01,
     9-.573117349D-01,-.513184414D-01,-.457831464D-01,-.407002530D-01/
      DATA (EKW(I),I=41,87)/
     1-.360577581D-01,-.318401624D-01,-.280271683D-01,-.245977718D-01,
     2-.215296753D-01,-.187966785D-01,-.163688812D-01,-.142246837D-01,
     3-.123370858D-01,-.106809878D-01,-.923028934D-02,-.796819096D-02,
     4-.687029215D-02,-.591779314D-02,-.509229414D-02,-.437819496D-02,
     5-.376259562D-02,-.323089623D-02,-.277399691D-02,-.237999732D-02,
     6-.204229767D-02,-.175209799D-02,-.150299828D-02,-.128989853D-02,
     7-.110689874D-02,-.949798920D-03,-.814999069D-03,-.700199190D-03,
     8-.602999302D-03,-.516199400D-03,-.446599479D-03,-.386399548D-03,
     9-.332799617D-03,-.290599668D-03,-.246599722D-03,-.215399753D-03,
     9-.188899784D-03,-.143399836D-03,-.108599875D-03,-.867998994D-04,
     1-.681999214D-04,-.527999393D-04,-.403999540D-04,-.313999636D-04,
     2-.184999787D-04,-.120999861D-04,-.909998949D-05/

      DATA (WKW(I),I=1,40)/
     1 .308019605D+02, .214419954D+02, .154937452D+02, .115151545D+02,
     2 .871827707D+01, .673831756D+01, .527864661D+01, .419929947D+01,
     3 .333940643D+01, .219403463D+01, .149861953D+01, .103863661D+01,
     4 .730647471D+00, .518552387D+00, .441110777D+00, .383461006D+00,
     5 .373946396D+00, .358559402D+00, .372215569D+00, .356670198D+00,
     6 .312744133D+00, .261523038D+00, .180817537D+00, .124665543D+00,
     7 .807794104D-01, .486562494D-01, .251952492D-01, .452257820D-02,
     8-.854560161D-02,-.196001146D-01,-.276538076D-01,-.344244662D-01,
     9-.381080935D-01,-.421628973D-01,-.441600287D-01,-.454966841D-01,
     9-.460129217D-01,-.458513118D-01,-.453815149D-01,-.440623159D-01/
      DATA (WKW(I),I=41,87)/
     1-.426089183D-01,-.404417185D-01,-.383839285D-01,-.361823035D-01,
     2-.336666088D-01,-.302110314D-01,-.286090554D-01,-.255125522D-01,
     3-.233005599D-01,-.201850499D-01,-.191990995D-01,-.161784216D-01,
     4-.146071006D-01,-.126330766D-01,-.110605069D-01,-.996481997D-02,
     5-.818014482D-02,-.765454189D-02,-.608163613D-02,-.575887028D-02,
     6-.466284400D-02,-.408972107D-02,-.363824334D-02,-.295728079D-02,
     7-.259261281D-02,-.221225014D-02,-.193837141D-02,-.203425060D-02,
     8-.484614204D-03,-.226728547D-02,-.766232140D-03,-.307779418D-03,
     9-.196264565D-02, .131836977D-02,-.223083472D-02,-.750220030D-04,
     9-.289074004D-03,-.220265690D-03,-.434861384D-03, .971346041D-05,
     1-.839919101D-04,-.153745275D-03,-.369227366D-04,-.249634065D-04,
     2-.290482724D-04,-.148433244D-04, .682166282D-05/

      END

