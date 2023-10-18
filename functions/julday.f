      FUNCTION julday(mm,id,iyyy)
      INTEGER julday,id,iyyy,mm,IGREG
      PARAMETER (IGREG=15+31*(10+12*1582)) ! Gregorian Calendar adopted Oct. 15, 1582.
c     In this routine julday returns the Julian Day Number that begins
c     at noon of the calendar date specified by month mm, day id, and
c     year iyyy, all integer variables. Positive year signifies A.D.;
c     negative, B.C. Remember that the year after 1 B.C. was 1 A.D. 
      INTEGER ja,jm,jy
      jy=iyyy
      if (jy.eq.0) then
         write(*,*) 'julday: there is no year zero'
         write(*,*) 'enter a new year (hit Enter to conintue)'
         READ(*,'(i5)') iyyy
         jy=iyyy
      endif
      if (jy.lt.0) jy=jy+1
      if (mm.gt.2) then         ! Here is an example of a block IF-structure.
         jm=mm+1
      else
         jy=jy-1
         jm=mm+13
      endif
      julday=int(365.25*real(jy))+int(30.6001*real(jm))+id+1720995
      if (id+31*(mm+12*iyyy).ge.IGREG) then ! Test whether to change to Gregorian Calendar.
         ja=int(0.01*real(jy) )
         julday=julday+2-ja+int(0.25*real(ja))
      endif
      return
      END
