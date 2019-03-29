	PROGRAM D8R2
C	Driver for routine PIKSR2
	DIMENSION A(100),B(100),C(100)
	INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
	CHARACTER(LEN = 256) :: FMT
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,100)
	CLOSE(UNIT)
C	Generate B and C arrays
	DO 11 I=1,100
	   B(I)=I
	   C(I)=(A(I)+B(I))/2
 11	CONTINUE
C	Sort A and mix B,C
	CALL PIKSR3(100,A,B,C)
	WRITE(*,*) 'After sorting A and mixing B and C, array A is:'
	WRITE(FMT,'(A)')'(1X,10F7.2)'
	DO 12 I=1,10
	   WRITE(*,FMT) (A(10*(I-1)+J), J=1,10)
 12	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 13 I=1,10
	   WRITE(*,FMT) (B(10*(I-1)+J), J=1,10)
 13	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 16 I=1,10
	   WRITE(*,FMT) (C(10*(I-1)+J), J=1,10)
 16	CONTINUE
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A,C
	CALL PIKSR3(100,B,A,C)
	WRITE(*,*) 'After sorting B and mixing A and C, array A is:'
	DO 14 I=1,10
	   WRITE(*,FMT) (A(10*(I-1)+J), J=1,10)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,10
	   WRITE(*,FMT) (B(10*(I-1)+J), J=1,10)
 15	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 17 I=1,10
	   WRITE(*,FMT) (C(10*(I-1)+J), J=1,10)
 17	CONTINUE
	END
