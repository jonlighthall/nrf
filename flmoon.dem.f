        PROGRAM D1R1
C       Driver for routine FLMOON
      use moon_calc, only : convert_time,IFRAC,FFRAC,FRAC,TIMZON,JD
     &     ,qtime,HOUR,MIN,IM,IYYY,N,NPH,TIMZON,frac_time_zone
     &     ,flmoon,caldat,julday,n_full_moons
        implicit none
        real, PARAMETER :: TZONE=-6.0
        CHARACTER PHASE(4)*15,TIMSTR(2)*3
        DATA PHASE/'new moon','first quarter','full moon',
     &       'last quarter'/
        DATA TIMSTR/' AM',' PM'/
        INTEGER I,ID,ISTR,J1
        WRITE(*,*) 'Date of the next few phases of the moon'
        WRITE(*,*) 'Enter today''s date (e.g. 1,31,1982)'
        TIMZON=frac_time_zone(TZONE)
        READ(*,*) IM,ID,IYYY
C       Approximate number of full moons since January 1900
        N=n_full_moons(IYYY,IM)
        NPH=2
        J1=JULDAY(IM,ID,IYYY)
        CALL FLMOON(N,NPH,JD,FRAC)
        N=N+int(real(J1-JD)/28.0)
        WRITE(*,'(/1X,A,T15,A,T27,A,T45,A)') 'Lunation','Date'
     &       ,'Time(CST)','Phase'
        DO I=1,20
           CALL FLMOON(N,NPH,JD,FRAC)
           call convert_time(IFRAC,FFRAC,FRAC,TIMZON,JD)
           call qtime(FFRAC,HOUR,MIN)
c       convert time string to AM/PM
           IF (IFRAC.GT.12) THEN
              IFRAC=IFRAC-12
              FFRAC=FFRAC-12
              ISTR=2
           ELSE
              ISTR=1
           ENDIF
           CALL CALDAT(JD,IM,ID,IYYY)
           WRITE(*,'(2X,I5,3X,2I3,I5,T26,i0.2,a,i0.2,1x,a,I2,2A,4X,A)')
     &          N-284,IM,ID,IYYY,hour,':',min,'-> ',IFRAC,TIMSTR(ISTR)
     &          ,'',PHASE(NPH+1)
           IF (NPH.EQ.3) THEN
              NPH=0
              N=N+1
           ELSE
              NPH=NPH+1
           ENDIF
        enddo
        END
