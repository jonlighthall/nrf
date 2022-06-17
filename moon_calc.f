      module moon_calc
      implicit none
c     define interfaces
      interface
         SUBROUTINE flmoon(n,nph,jd,FRAC)
         INTEGER, intent(in) :: n,nph,jd
         REAL, intent(in) :: FRAC
         end subroutine
      SUBROUTINE caldat(julian,mm,id,iyyy)
      INTEGER, intent(in) :: julian,mm,id,iyyy
      end subroutine
      integer function JULDAY(IM,ID,IY)
      integer, intent(in) :: IM,ID,IY
      end function
      SUBROUTINE piksr4(n,arr,bn,brr,cn,crr,dn,drr)
      INTEGER, intent(in) :: n,bn,cn,dn,brr(n,bn),crr(n,cn)
      REAL, intent(in) :: arr(n)
      character(len = dn), intent(in) :: drr(n,cn)
      end subroutine
      end interface

      integer N,NPH,JD
      real FRAC
      integer IYYY,IM
      integer HOUR,MIN
      real FFRAC,SEC
      real TIMZON
      integer IFRAC
      logical debug_messages

      contains
      integer function n_full_moons(int_year,int_month)
      integer, intent(in) :: int_year, int_month

C     Approximate number of full moons since January 1900
      n_full_moons=int(12.37*(real(int_year-1900)+(real(int_month)-0.5)
     &     /12.0))
c     This value n is a first approximation to how many full moons have
c     occurred since 1900. We will feed it into the phase routine and
c     adjust it up or down until we determine that our desired 13th was
c     or was not a full moon. The variable icon signals the direction of
c     adjustment.

      end function

      subroutine qtime(floating_fractional_hour,hour,minute,second)
      real,intent(in) :: floating_fractional_hour
      integer,intent(out) :: hour,minute
      real,optional,intent(out) :: second
      hour=int(floating_fractional_hour)
      minute=int((floating_fractional_hour-real(hour))*60)
      if(present(second))then
         second=((floating_fractional_hour-real(hour))*60-real(minute))
     &        *60
      endif
      end subroutine

      real function frac_time_zone(gmt_offset_hours)
      real,intent(in) :: gmt_offset_hours
      frac_time_zone=gmt_offset_hours/24.
      end function

      subroutine convert_time(IFRAC,FFRAC,FRAC,TIMZON,JD)
      integer JD,IFRAC
      real FRAC,FFRAC
      real, intent(in) :: TIMZON
c     First, convert times to the local time zone
      IFRAC=NINT(24.*(FRAC+TIMZON))
      FFRAC=(24.*(FRAC+TIMZON))
c     Then, convert from Julian Days beginning at noon to civil days
c     beginning at midnight
      IF (IFRAC.LT.0) THEN
         JD=JD-1
         IFRAC=IFRAC+24
         FFRAC=FFRAC+24
      ENDIF
c     If the time is after noon, increment the Julian Day and reset the
c     time
      IF((IFRAC.GE.12).AND.(FFRAC.GE.12.0)) THEN ! flmoon.dem uses IFRAC.GE.12
         if(IFRAC.EQ.12) write(*,'(a,i3,a,i4,a,i2,a,i7,a,f4.1,a,f4.1,a
     &        ,f5.1)')' found overflow: N=',N,' yr=',iyyy,' m=',im,' d0
     &        =',JD,' t0=',FFRAC,'; t=',FFRAC-12,' TZ=',TIMZON*24

         JD=JD+1
         IFRAC=IFRAC-12
         FFRAC=FFRAC-12
c     Otherwise, just set the time
      ELSE
         IFRAC=IFRAC+12
         FFRAC=FFRAC+12
      ENDIF
c     Valid timezones range from -12 to +14 hours
c     The following check is required for timezones > +12
      if((IFRAC.gt.24).or.(FFRAC.gt.24.0))then
         if(debug_messages) write(*
     &        ,'(a,i4,a,i2,a,i7,a,f4.1,a,i7,a,f4.1,a,f5.1)'
     &        )' found overflow: yr=',iyyy,' m=',im,' d0=',JD,' t0='
     &        ,FFRAC,'; d=',JD+1,', t=',FFRAC-24,' TZ=',TIMZON*24
         JD=JD+1
         IFRAC=IFRAC-24
         FFRAC=FFRAC-24
      endif
      end subroutine

      subroutine print_stats(place,year,month,target_day,test_day,n_moon
     &     ,ic,icon)
      character(len=*),intent(in) :: place
      integer,intent(in) :: year,month,target_day,test_day,n_moon,ic
     &     ,icon
      if(debug_messages) write(*,'(2a,i4,a,i2,2(a,i7),3(a,i3))') place
     &     ,' year=',year,' mon=',month,' jday=',target_day,' JD='
     &     ,test_day,' N=',n_moon,' ic=',ic,' icon=',icon

      end subroutine

      end module
