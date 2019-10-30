      PROGRAM badluk
      INTEGER ic,icon,idwk,ifrac,im,iybeg,iyend,iyyy,jd,jday,n,
     *     julday,timezone, badcount, badmin, badmax, badtotal, whichbad
     &     , ntz, hour, min
      LOGICAL newbad, rollback, check, list, dofrac
      INTEGER, PARAMETER :: zs=-12,ze=14 ! The range of time zones to be searched.
      REAL TIMZON,frac,ffrac,sec
      character(len = 7) :: zn(zs:ze) ! Time zone name 
      character(len = 7) :: dzn(zs:ze), szn(zs:ze) ! Time zone name 
      character(len = 256) :: fmt
      DATA iybeg,iyend /1900,2050/ ! The range of dates to be searched.
      integer, parameter :: ba = 25
      integer :: bads(ba,2)
      integer :: times(ba,zs:ze)
      character(len = 3) :: stimes(ba,zs:ze) ! string times
      character(len = 5) :: sftimes(ba,zs:ze) ! string fractional times
      real :: fyears(ba)
C     USES flmoon,julday
      rollback = .false.        ! rollback to original output
      check = .false.           ! print check statements (debug)
      list = .false.            ! print dates as they are found
      dofrac = .false.          ! print hours and minutes
      if(rollback) then
         iybeg=1900
         iyend=2000
         check = .false.
      endif

      write (*,'(1x,a,i5,a,i5)') 'Full moons on Friday the 13th from',
     *     iybeg,' to',iyend
      bads = 0
      times = 0
      stimes = ' :'
      sftimes = '  :'
      badmin = 0
      badmax = 0
      badtotal = 0
      whichbad = 0
      ntz=ze-zs+1
      do 10 timezone = zs, ze  
c     The full moon of Friday, June 13, 2014 did not (tecncially) occur
c     in the Easter Time Zone (the program default). This loop is added
c     to include other time zones.
      if(check) write(*,'(a,sp,i4,a)')'testing zone',timezone,'...'
      badcount = 0
      write (zn(timezone), '(sp,i3,a)') timezone, ' UTC' 
c     zone names
      zn( 0) = 'GMT'
      if(rollback) zn(-5) = 'EST' ! Time zone −5 is Eastern Standard Time.
c     standard time names
      szn=''
      szn(-8) = 'PST'
      szn(-7) = 'MST'
      szn(-6) = 'CST'
      szn(-5) = 'EST'  
c      szn(-4) = 'AST'
c      szn(+1) = 'CET'
c     daylight saving time names
      dzn=''
      dzn(-7) = 'PDT'
      dzn(-6) = 'MDT'
      dzn(-5) = 'CDT'
      dzn(-4) = 'EDT'
c      dzn(-3) = 'ADT'
      TIMZON=timezone/24.    
      do 12 iyyy=iybeg,iyend ! Loop over each year,
         do 11 im=1,12       ! and each month.
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
               ffrac=(24.*(frac+TIMZON)) ! Convert to hours in correct time zone.
               if(ifrac.lt.0)then ! Convert from Julian Days beginning at noon 
                  jd=jd-1       ! to civil days beginning at midnight.
                  ifrac=ifrac+24
                  ffrac=ffrac+24
               endif
               if((ifrac.gt.12).or.(ffrac.gt.12.0))then
                  jd=jd+1
                  ifrac=ifrac-12
                  ffrac=ffrac-12
               else
                  ifrac=ifrac+12
                  ffrac=ffrac+12
               endif
c     The following check is required for timezones > +12
               if((ifrac.gt.24).or.(ffrac.gt.24.0))then
                  if(check)write(*,'(a,i4,a,i2,a,f4.1,a,f4.1)'
     &                 )' found overflow: yr=',iyyy,' m=',im
     &                 ,' d0=13 t0=',ffrac,'; d=14, t=',ffrac-24
                  jd=jd+1
                  ifrac=ifrac-24
                  ffrac=ffrac-24
              endif
               hour=int(ffrac)
               min=int((ffrac-hour)*60)
               sec=((ffrac-hour)*60-min)*60
               if(jd.eq.jday)then ! Did we hit our target day?
                  if(badtotal.eq.0)then ! first?
                     if(check)write(*,*)'found first bad day!'
                     badtotal = 1
                     whichbad = badtotal
                  else          ! not first
                     if(check)write(*,'(a,i0.2,a,i0.2,a)',advance='no'
     &                    )' found a bad day at ',hour,':',min
     &                    ,'. checking...'
                     newbad = .true.
                     do i=1,badtotal ! check
                      if((iyyy.eq.bads(i,1)).and.(im.eq.bads(i,2))) then
                           whichbad = i
                           if(check)write(*,'(1x,i2,a,i2,a,i4,a)'
     &                          )im,'/',13,'/',iyyy,' already found'
                           newbad = .false.
                        endif
                     enddo
                     if(newbad)then ! new?
                        badtotal = badtotal +1
                        whichbad = badtotal
                        if(badtotal.lt.ba)then
                           if(check) write(*,'(a,i2)')
     &                          ' found new bad day! count = ',badtotal
                        else
                           write(*,*) 'too many bad days. 
     &increase array size!'
                           return
                        endif
                     endif      ! end new?
                  endif         ! end first?                 
                  bads(whichbad,1)=iyyy
                  bads(whichbad,2)=im
                  times(whichbad,timezone)=ifrac
                  write(sftimes(whichbad,timezone),'(i0.2,a,i0.2)')hour
     &                 ,':',min
                  if((ffrac.gt.1).and.(ffrac.lt.1.5)) then
                     if(check) then 
                        write(*,'(a,i4,a,i2,a,a5,a,a5)'
     &                       )'  found margin: yr=',iyyy,' m=',im,' t0='
     &                       ,sftimes(whichbad,timezone),'; t='
     &                       ,sftimes(whichbad,timezone-1)
                        write(*,'(a,i0.2,a,i0.2,a,sp,i3)')
     &                       '  new time should be ',hour-1,':',min,
     &                       ' in zone ',timezone-1
                     endif
                     write(sftimes(whichbad,timezone-1),
     &                    '(i0.2,a,i0.2)')hour-1,':',min
                  endif
                  if( (rollback.and.(timezone.eq.-5).or.
     &                 (.not.rollback).and.list.and.newbad) ) then
                  write (*,'(/1x,i2,a,i2,a,i4)') im,'/',13,'/',iyyy
                  if(len_trim(zn(timezone)).gt.0)then
                     write (fmt,'(a,i1,a)')'(1x,a,i2,a,a'
     &                    ,len_trim(zn(timezone)),',a)'
                  else
                     write (fmt,*)'(1x,a,i2,a,a,a)'
                  endif
                  write (*,fmt) 'Full moon ',ifrac,
     *                 ' hrs after midnight (',zn(timezone),').'
                  if((.not.rollback).and.dofrac) then
                     write (*,*) 'Full moon ',ffrac,
     *                    ' hrs after midnight (',zn(timezone),').'
     &                    ,hour,min,sec
                     write(*,'(i2,a,i2,a,f4.1)')int(hour),':',int(min)
     &                    ,':',sec
                  endif
               endif
               badcount = badcount + 1
                 
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
      if(check) write (*,'(a,i2,a)') ' found ',badcount
     &     ,' bad days in zone'
         if(badcount.gt.badmax)then
            badmax=badcount
         endif
         if(badcount.lt.badmax)then
            badmin=badcount
         endif
 10   continue
      if(check) write(*,'(/a)') 'copying...'
      write(fmt,'(a,i2,a)')'(1x,i2,1x,f6.1,i5,i3,',ntz,'(i3))'
      do i=1,ba
         fyears(i)=bads(i,1)+bads(i,2)/12.
         if((i.le.badtotal).and.check)  write(*,fmt) i,fyears(i),bads(i
     &        ,1),bads(i,2),times(i,:)
      enddo
c      call piksr3(ba,fyears,2,bads,ntz,times)
      call piksr4(ba,fyears,2,bads,ntz,times,5,sftimes)
      k=ba-badtotal             ! calculate leading zeros in arrays
c      k=0
      if(check) then
         write(*,'(/a)') 'sorting...'
         do i=1,ba
            l=i-k
            if(i.gt.k)  write(*,fmt) l,fyears(i),bads(i,1)
     &           ,bads(i,2),times(i,:)
         enddo
      endif

      do i=1,ba
         do j=zs,ze 
            if(times(i,j).ne.0) write(stimes(i,j),'(i2)')times(i,j)
            if((times(i,j).eq.0).and.(sftimes(i,j).ne.'  :'))
     &           write(stimes(i,j),'(i2)')0
         enddo
      enddo
      
      if(.not.rollback) then
         write (*,'(/19x,a,i2,a,i5,a,i5)') 'Found ',badtotal
     &        ,' bad days from',iybeg,' to',iyend
         write (*,'(1x,a,i2,a)') '  The luckiest zone had ',badmin
     &        ,' bad days'
         write (*,'(1x,a,i2,a/)') 'The unluckiest zone had ',badmax
     &        ,' bad days'
         if(.not.dofrac) then
         write (fmt,'(a,i2,a)')'(a,',ntz,'(1x,a3))'
      write (*,fmt) 'Daylight time ',(dzn(j),j=zs,ze) ! print daylight names
      write (*,fmt) 'Standard time ',(szn(j),j=zs,ze) ! print standard names
      write (*,fmt) 'UTC Offset    ',(zn(j),j=zs,ze) ! print zone names
      write (fmt,'(a,i2,a)')'(14x,',ntz,'(1x,sp,i3))'

      write (fmt,'(a,i2,a)')'(1x,i2,1x,i2,a,i2,a,i4,',ntz,'(1x,a3))'
         write(*,*) repeat('-',13+4*ntz)
      do, i=1,ba
         l=i-k
         if(i.gt.k) write (*,fmt) l,bads(i,2),'/',13,'/'
     $        ,bads(i,1),stimes(i,:)
      enddo
      else
      write (fmt,'(a,i2,a)')'(a,',ntz,'(3x,a3))'
      write (*,fmt) 'Daylight time ',(dzn(j),j=zs,ze) ! print daylight names
      write (*,fmt) 'Standard time ',(szn(j),j=zs,ze) ! print standard names
      write (*,fmt) 'UTC Offset    ',(zn(j),j=zs,ze) ! print zone names      
      write (fmt,'(a,i2,a)')'(1x,i2,1x,i2,a,i2,a,i4,',ntz,'(1x,a5))'
      write(*,*) repeat('-',13+6*ntz)
  
      do, i=1,ba
         l=i-k
         if(i.gt.k) write (*,fmt) l,bads(i,2),'/',13,'/'
     $        ,bads(i,1),sftimes(i,:)
      enddo
      endif
      endif
      END   
