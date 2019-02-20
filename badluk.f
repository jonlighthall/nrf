      PROGRAM badluk
      INTEGER ic,icon,idwk,ifrac,im,iybeg,iyend,iyyy,jd,jday,n,
     *     julday
      REAL TIMZON,frac
      PARAMETER (TIMZON=-5./24.) ! Time zone −5 is Eastern Standard Time.
      DATA iybeg,iyend /1900,2100/ ! The range of dates to be searched.
C     USES flmoon,julday
      write (*,'(1x,a,i5,a,i5)') 'Full moons on Friday the 13th from',
     *     iybeg,' to',iyend
      do 12 iyyy=iybeg,iyend ! Loop over each year,
         do 11 im=1,12 ! and each month.
            jday=julday(im,13,iyyy) ! Is the 13th a Friday?
            idwk=mod(jday+1,7)
            if(idwk.eq.5) then
               n=12.37*(iyyy-1900+(im-0.5)/12.)
c     This value n is a first approximation to how many full moons have
c     occurred since 1900. We will feed it into the phase routine and
c     adjust it up or down until we determine that our desired 13th was
c     or was not a full moon. The variable icon signals the direction of
c     adjustment. 
               icon=0
 1             call flmoon(n,2,jd,frac) ! Get date of full moon n.
               ifrac=nint(24.*(frac+TIMZON)) ! Convert to hours in correct time zone.
               if(ifrac.lt.0)then ! Convert from Julian Days beginning at noon to civil jd=jd-1 days beginning at midnight.
                  ifrac=ifrac+24
               endif
               if(ifrac.gt.12)then
                  jd=jd+1
                  ifrac=ifrac-12
               else
                  ifrac=ifrac+12
               endif
               if(jd.eq.jday)then ! Did we hit our target day?
                  write (*,'(/1x,i2,a,i2,a,i4)') im,'/',13,'/',iyyy
                  write (*,'(1x,a,i2,a)') 'Full moon ',ifrac,
     *                 ' hrs after midnight (EST).'
c     Don't worry if you are unfamiliar with FORTRAN's esoteric input
c     /output statements; very few programs in this book do any input
c     /output. 
                  goto 2        ! Part of the break-structure, case of a match.
               else             ! Didn't hit it.
                  ic=isign(1,jday-jd)
                  if(ic.eq.-icon) goto 2 ! Another break, case of no match.
                  icon=ic
                  n=n+ic
               endif
               goto 1
 2             continue
            endif
 11      continue
 12   continue
      END
