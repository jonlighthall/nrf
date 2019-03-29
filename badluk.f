      PROGRAM badluk
      INTEGER ic,icon,idwk,ifrac,im,iybeg,iyend,iyyy,jd,jday,n,
     *     julday,timezone, badcount, badmin, badmax, badtotal, whichbad
     &     , ntz
      LOGICAL newbad, rollback, check, list
      INTEGER, PARAMETER :: zs=-12,ze=14 ! The range of time zones to be searched.
      REAL TIMZON,frac,ffrac
      character(len = 7) :: zn(zs:ze) ! Time zone name 
      character(len = 7) :: dzn(zs:ze), szn(zs:ze) ! Time zone name 
      character(len = 256) :: fmt
      DATA iybeg,iyend /1900,2050/ ! The range of dates to be searched.
      integer, parameter :: ba = 25
      integer :: bads(ba,2)
      integer :: times(ba,zs:ze)
      real :: fyears(ba)
C     USES flmoon,julday
      rollback = .true.        ! rollback to original output
      check = .false.           ! print check statements (debug)
      list = .false.            ! print list of dates
      if(rollback) then
         iybeg=1900
         iyend=2000
         check = .false.
      endif

      write (*,'(1x,a,i5,a,i5)') 'Full moons on Friday the 13th from',
     *     iybeg,' to',iyend
      bads = 0
      times = 0
      badmin = 0
      badmax = 0
      badtotal = 0
      whichbad = 0
      ntz=ze-zs+1
      do 10 timezone = zs, ze  
c     The full moon of Friday, June 13, 2014 did not (tecncially) occur
c     in the Easter Time Zone (the program default). This loop is added
c     to include other time zones.
      badcount = 0
      write (zn(timezone), '(sp,i3,a)') timezone, ' UTC' 
      szn=''
      szn(-8) = 'PST'
      szn(-7) = 'MST'
      szn(-6) = 'CST'
      zn(-5) = 'EST'            ! Time zone −5 is Eastern Standard Time.
      szn(-4) = 'AST'
      zn( 0) = 'GMT'
c      szn(+1) = 'CET'
      dzn=''
      dzn(-7) = 'PDT'
      dzn(-6) = 'MDT'
      dzn(-5) = 'CDT'
      dzn(-4) = 'EDT'
      dzn(-3) = 'ADT'
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
               if(ifrac.gt.12)then
                  jd=jd+1
                  ifrac=ifrac-12
                  ffrac=ffrac-12
               else
                  ifrac=ifrac+12
                  ffrac=ffrac+12
               endif
               if(jd.eq.jday)then ! Did we hit our target day?
                  if(badtotal.eq.0)then ! first?
                     if(check)write(*,*)'found first bad day!'
                     badtotal = 1
                     whichbad = badtotal
                  else          ! not first
                     if(check)write(*,*)'found a bad day. checking...'
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
     &                          'found new bad day! count = ',badtotal
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
                  write (*,*) 'Full moon ',ffrac,
     *                 ' hrs after midnight (',zn(timezone),').'
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
      if(check) write (*,'(a,i2,a)') 'found ',badcount
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
      call piksr3(ba,fyears,2,bads,ntz,times)
      k=ba-badtotal             ! calculate leading zeros in arrays
      if(check) then
         write(*,'(/a)') 'sorting...'
         do i=1,ba
            l=i-k
            if(i.gt.k)  write(*,fmt) l,fyears(i),bads(i,1)
     &           ,bads(i,2),times(i,:)
         enddo
      endif
      
      if(.not.rollback) then
         write (*,'(/19x,a,i2,a,i5,a,i5)') 'Found ',badtotal
     &        ,' bad days from',iybeg,' to',iyend
         write (*,'(1x,a,i2,a)') '  The luckiest zone had ',badmin
     &        ,' bad days'
         write (*,'(1x,a,i2,a/)') 'The unluckiest zone had ',badmax
     &        ,' bad days'
      write (fmt,'(a,i2,a)')'(14x,',ntz,'(1x,a3))'
      write (*,fmt) (dzn(j),j=zs,ze) ! print daylight names
      write (*,fmt) (szn(j),j=zs,ze) ! print standard names
      write (*,fmt) (zn(j),j=zs,ze) ! print zone names
      write (fmt,'(a,i2,a)')'(14x,',ntz,'(1x,sp,i3))'
      write (*,fmt) (j,j=zs,ze) ! print indicies
      write (fmt,'(a,i2,a)')'(1x,i2,1x,i2,a,i2,a,i4,',ntz,'(1x,i3))'
      write(*,*)'-----------------------------------------------------',
     &'---------------------------------------------------',
     &'-----------------'
      do, i=1,ba
         l=i-k
         if(i.gt.k) write (*,fmt) l,bads(i,2),'/',13,'/'
     $        ,bads(i,1),times(i,:)
      enddo
      endif
      END   
