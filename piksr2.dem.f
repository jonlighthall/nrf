	PROGRAM D8R2
C	Driver for routine PIKSR2
	implicit none
	interface
	   SUBROUTINE piksr2(n,arr,brr)
	   INTEGER, intent(in) :: n
	   REAL, intent(in) ::	arr(n),brr(n)
	   end subroutine
	end interface
	real A,B
	integer I,J
	INTEGER, PARAMETER :: X=100, DIV=10
	DIMENSION A(X),B(X)
	INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
	CHARACTER(LEN = 256) :: FMT
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,X)
	CLOSE(UNIT)
C	Generate B array
	DO 11 I=1,X
	   B(I)=real(I)
 11	CONTINUE
C	Sort A and mix B
	CALL PIKSR2(X,A,B)
	WRITE(*,*) 'After sorting A and mixing B, array A is:'
	WRITE(FMT,'(A)')'(1X,10F6.2)'
	DO 12 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 12	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 13 I=1,X/DIV
	   WRITE(*,FMT) (B(DIV*(I-1)+J), J=1,DIV)
 13	CONTINUE
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A
	CALL PIKSR2(X,B,A)
	WRITE(*,*) 'After sorting B and mixing A, array A is:'
	DO 14 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,X/DIV
	   WRITE(*,FMT) (B(DIV*(I-1)+J), J=1,DIV)
 15	CONTINUE
	END
