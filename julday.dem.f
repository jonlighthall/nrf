	PROGRAM D1R2
C	Driver for JULDAY
	CHARACTER TXT*40,NAME(12)*15
	DATA NAME/'January','February','March','April','May','June',
     *		'July','August','September','October','November',
     *		'December'/
	OPEN(5,FILE='dates.dat',STATUS='OLD')
	READ(5,'(A)') TXT
	READ(5,*) N
	WRITE(*,'(/1X,A,T12,A,T17,A,T23,A,T37,A/)') 'Month','Day','Year',
     *		'Julian Day','Event'
	DO 11 I=1,N
		READ(5,'(I2,I3,I5,A)') IM,ID,IY,TXT
		WRITE(*,'(1X,A10,I3,I6,3X,I7,5X,A)') NAME(IM),ID,IY,
     *			JULDAY(IM,ID,IY),TXT
11	CONTINUE
	CLOSE(5)
	WRITE(*,'(/1X,A/)') 'Month,Day,Year (e.g. 1,13,1905)'
	DO 12 I=1,20
		WRITE(*,*) 'MM,DD,YYYY'
		READ(*,*) IM,ID,IY
		IF(IM.LT.0) STOP
		WRITE(*,'(1X,A12,I8/)') 'Julian Day: ',JULDAY(IM,ID,IY)
12	CONTINUE
	END
