	PROGRAM D1R4
C	Driver for routine CALDAT
	CHARACTER NAME(12)*10
C	Check whether CALDAT properly undoes the operation of JULDAY
	DATA NAME/'January','February','March','April','May',
     *		'June','July','August','September','October',
     *		'November','December'/
	OPEN(5,FILE='dates.dat',STATUS='OLD')
	READ(5,*)
	READ(5,*) N
	WRITE(*,'(/1X,A,T40,A)') 'Original Date:','Reconstructed Date:'
	WRITE(*,'(1X,A,T12,A,T17,A,T25,A,T40,A,T50,A,T55,A/)') 
     *		'Month','Day','Year','Julian Day','Month','Day','Year'
	DO 11 I=1,N
		READ(5,'(I2,I3,I5)') IM,ID,IY
		IYCOPY=IY
		J=JULDAY(IM,ID,IYCOPY)
		CALL CALDAT(J,IMM,IDD,IYY)
		WRITE(*,'(1X,A,I3,I6,4X,I9,6X,A,I3,I6)') NAME(IM),ID,
     *			IY,J,NAME(IMM),IDD,IYY
11	CONTINUE
	END
