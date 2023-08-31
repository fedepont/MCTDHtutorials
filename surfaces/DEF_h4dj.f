      subroutine h4dj_complain
      write(6,'(a,/a)') '###########################################',
     +          'h4dj is not linked. Run compile with -i option.'
      write(2,'(a,/a)') '###########################################',
     +          'h4dj is not linked. Run compile with -i option.'
      stop
      end

      function h4dj (rr, theta1, theta2, phi12)
      real*8 h4dj, rr, theta1, theta2, phi12
      call h4dj_complain
      h4dj=0.d0
      end

      function h4dj_v000 (rr)
      real*8 h4dj_v000, rr
      call h4dj_complain
      h4dj_v000=0.d0
      end

      function h4dj_v022 (rr)
      real*8 h4dj_v022, rr
      call h4dj_complain
      h4dj_v022=0.d0
      end

      function h4dj_v224 (rr)
      real*8 h4dj_v224, rr
      h4dj_v224=0.d0
      call h4dj_complain
      end

