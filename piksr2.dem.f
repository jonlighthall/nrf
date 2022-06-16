	PROGRAM D8R2
C	Driver for routine PIKSR2
	implicit none
	interface
	   SUBROUTINE piksr2(n,arr,brr)
	   INTEGER, intent(in) :: n
	   REAL, intent(in) ::	arr(n),brr(n)
	   end subroutine
	end interface
	real A, B
	integer I,J
	DIMENSION A(100),B(100)
	INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
	CHARACTER(LEN = 256) :: FMT
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,100)
	CLOSE(UNIT)
C	Generate B array
	DO 11 I=1,100
	   B(I)=real(I)
 11	CONTINUE
C	Sort A and mix B
	CALL PIKSR2(100,A,B)
	WRITE(*,*) 'After sorting A and mixing B, array A is:'
	WRITE(FMT,'(A)')'(1X,10F6.2)'
	DO 12 I=1,10
	   WRITE(*,FMT) (A(10*(I-1)+J), J=1,10)
 12	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 13 I=1,10
	   WRITE(*,FMT) (B(10*(I-1)+J), J=1,10)
 13	CONTINUE
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A
	CALL PIKSR2(100,B,A)
	WRITE(*,*) 'After sorting B and mixing A, array A is:'
	DO 14 I=1,10
	   WRITE(*,FMT) (A(10*(I-1)+J), J=1,10)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,10
	   WRITE(*,FMT) (B(10*(I-1)+J), J=1,10)
 15	CONTINUE
	END
