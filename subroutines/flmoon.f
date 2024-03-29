      SUBROUTINE flmoon(n,nph,jd,frac)
      implicit none
      INTEGER n,nph,jd
      REAL frac
c     This routine calculates the phases of the moon. Given an integer n
c     and a code nph for the phase desired (nph = 0 for new moon, 1 for
c     first quarter, 2 for full, 3 for last quarter), the routine
c     returns the Julian Day Number jd, and the fractional part of a day
c     frac to be added to it, of the nth such phase since January, 1900.
c     Greenwich Mean Time is assumed.

      real, PARAMETER :: RAD=3.14159265/180.
      INTEGER i
      REAL am,as,c,t,t2,xtra
 1    c=real(n)+real(nph)/4.    ! This is how we comment an individual line.
      t=c/1236.85
      t2=t**2
      as=359.2242+29.105356*c   ! You aren't really intended to understand this algorithm, but it does work!
      am=306.0253+385.81692*c+0.010730*t2
      jd=2415020+28*n+7*nph
      xtra=0.75933+1.53058868*c+(1.178e-4-1.55e-7*t)*t2
      if(nph.eq.0.or.nph.eq.2)then
         xtra=xtra+(0.1734-3.93e-4*t)*sin(RAD*as)-0.4068*sin(RAD*am)
      else if(nph.eq.1.or.nph.eq.3)then
         xtra=xtra+(0.1721-4.e-4*t)*sin(RAD*as)-0.6280*sin(RAD*am)
      else
         write(*,*) 'flmoon: nph = ',nph,' is undefined'
         write(*,*) 'enter a valid value: either 0, 1, 2, or 3'
     &        ,'(hit Enter to conintue)'
         READ(*,'(i5)') nph
         goto 1
      endif
      if(xtra.ge.0.)then
         i=int(xtra)
      else
         i=int(xtra-1.)
      endif
      jd=jd+i
      frac=xtra-real(i)
      return
      END
