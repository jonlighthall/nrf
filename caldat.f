      SUBROUTINE caldat(julian,mm,id,iyyy)
      INTEGER julian,mm,id,iyyy
      integer, PARAMETER :: IGREG=2299161
c     Inverse of the function julday given above. Here julian is input
c     as a Julian Day Number, and the routine outputs mm,id, and iyyy as
c     the month, day, and year on which the specified Julian Day started
c     at noon. 
      INTEGER ja,jalpha,jb,jc,jd,je
      if(julian.ge.IGREG)then   ! Cross-over to Gregorian Calendar produces this correction.
         jalpha=int((real(julian-1867216)-0.25)/36524.25) 
         ja=julian+1+jalpha-int(0.25*real(jalpha))
      else if(julian.lt.0)then  ! Make day number positive by adding integer number of Julian centuries, then subtract them off at the end.
         ja=julian+36525*(1-julian/36525)
      else
         ja=julian
      endif
      jb=ja+1524
      jc=int(6680.+(real(jb-2439870)-122.1)/365.25)
      jd=365*jc+int(0.25*real(jc))
      je=int(real(jb-jd)/30.6001)
      id=jb-jd-int(30.6001*real(je))
      mm=je-1
      if(mm.gt.12)mm=mm-12
      iyyy=jc-4715
      if(mm.gt.2)iyyy=iyyy-1
      if(iyyy.le.0)iyyy=iyyy-1
      if(julian.lt.0)iyyy=iyyy-100*(1-julian/36525)
      return
      END
