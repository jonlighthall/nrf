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
      second=((floating_fractional_hour-real(hour))*60-real(minute))*60
      end subroutine

      real function frac_time_zone(gmt_offset_hours)
      real,intent(in) :: gmt_offset_hours
      frac_time_zone=gmt_offset_hours/24.
      end function      

      end module
