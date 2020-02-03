	PROGRAM D1R1
C	Driver for routine FLMOON
	PARAMETER(TZONE=-6.0)
	CHARACTER PHASE(4)*15,TIMSTR(2)*3
	DATA PHASE/'new moon','first quarter',
     *			'full moon','last quarter'/
	DATA TIMSTR/' AM',' PM'/
	INTEGER HOUR,MIN
	WRITE(*,*) 'Date of the next few phases of the moon'
	WRITE(*,*) 'Enter today''s date (e.g. 1,31,1982)'
	TIMZON=TZONE/24.0
	READ(*,*) IM,ID,IY
C	Approximate number of full moons since January 1900
	N=12.37*(IY-1900+(IM-0.5)/12.0)
	NPH=2
	J1=JULDAY(IM,ID,IY)
	CALL FLMOON(N,NPH,J2,FRAC)
	N=N+(J1-J2)/28.0
	WRITE(*,'(/1X,A,T15,A,T27,A,T38,A)') 'Lunation','Date'
	1    ,'Time(CST)','Phase'
	DO 11 I=1,20
		CALL FLMOON(N,NPH,J2,FRAC)
		IFRAC=NINT(24.*(FRAC+TIMZON))
		ffrac=(24.*(frac+TIMZON)) 
		IF (IFRAC.LT.0) THEN
			J2=J2-1
			IFRAC=IFRAC+24
			fFRAC=fFRAC+24
		ENDIF
		IF (IFRAC.GE.12) THEN
			J2=J2+1
			IFRAC=IFRAC-12
			fFRAC=fFRAC-12
		ELSE
			IFRAC=IFRAC+12
			fFRAC=fFRAC+12
		ENDIF
		hour=int(ffrac)
		min=int((ffrac-hour)*60)
		IF (IFRAC.GT.12) THEN
			IFRAC=IFRAC-12
			fFRAC=fFRAC-12
			ISTR=2
		ELSE
			ISTR=1
		ENDIF
		CALL CALDAT(J2,IM,ID,IY)
		WRITE(*,'(2X,I5,3X,2I3,I5,T28,I2,A,5X,A,i0.2,a,i0.2)') N-284
	1	     ,IM,ID,IY,IFRAC,TIMSTR(ISTR),PHASE(NPH+1),hour,':',min
		IF (NPH.EQ.3) THEN
			NPH=0
			N=N+1
		ELSE
			NPH=NPH+1
		ENDIF
11	CONTINUE
	END
