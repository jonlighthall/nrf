      PROGRAM D1R2
C     Driver for JULDAY
      use dates
      implicit none
      CHARACTER TXT*40
      integer I,IM,ID,IY,N
      integer,parameter :: n_loop=20

      OPEN(1,FILE='dat/dates.dat',STATUS='OLD')
      READ(1,'(A)') TXT
      READ(1,*) N
      WRITE(*,'(/1X,A,T12,A,T17,A,T23,A,T37,A/)') 'Month','Day','Year'
     &     ,'Julian Day','Event'
      DO I=1,N
         READ(1,'(I2,I3,I5,A)') IM,ID,IY,TXT
         WRITE(*,'(1X,A10,I3,I6,3X,I7,5X,A)') NAME(IM),ID,IY,JULDAY(IM
     &        ,ID,IY),TXT
      enddo
      CLOSE(1)
      WRITE(*,'(/1X,A/)') 'Month,Day,Year (e.g. 1,13,1905)'
      DO I=1,n_loop
         WRITE(*,'(2(a,i2),a)') 'loop ',I,' of ',n_loop,':'
         WRITE(*,*) 'MM,DD,YYYY'
         READ(*,*) IM,ID,IY
         IF(IM.LT.0) STOP
         WRITE(*,'(1X,A12,I8/)') 'Julian Day: ',JULDAY(IM,ID,IY)
      enddo
      END
