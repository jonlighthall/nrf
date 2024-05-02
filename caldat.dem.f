      PROGRAM D1R4
C     Driver for routine CALDAT
      use dates, only: read_file,N,unit,JULDAY,CALDAT,NAME
      implicit none
      integer I,IM,ID,IY,IYCOPY,J,IMM,IDD,IYY
      call read_file()
C     Check whether CALDAT properly undoes the operation of JULDAY
      WRITE(*,'(1X,A,T40,A)') 'Original Date:','Reconstructed Date:'
      WRITE(*,'(1X,A,T12,A,T17,A,T25,A,T40,A,T50,A,T55,A/)')
     *     'Month','Day','Year','Julian Day','Month','Day','Year'
      DO I=1,N
         READ(unit,'(I2,I3,I5)') IM,ID,IY
         IYCOPY=IY
         J=JULDAY(IM,ID,IYCOPY)
         CALL CALDAT(J,IMM,IDD,IYY)
         WRITE(*,'(1X,A,I3,I6,4X,I9,6X,A,I3,I6)') NAME(IM),ID,
     *        IY,J,NAME(IMM),IDD,IYY
      enddo
      close(unit)
      END
