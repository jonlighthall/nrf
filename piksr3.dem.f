	PROGRAM D8R2
C	Driver for routine PIKSR3
	implicit none
	interface
	   SUBROUTINE piksr3(n,arr,brr,crr)
	   INTEGER, intent(in) :: n
	   REAL, intent(in) ::	arr(n),brr(n),crr(n)
	   end subroutine
	end interface
	real A,B,C
	integer I,J
	INTEGER, PARAMETER :: X=100, DIV=10
	DIMENSION A(X),B(X),C(X)
	INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
	CHARACTER(LEN = 256) :: FMT
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,X)
	CLOSE(UNIT)
C	Generate B and C arrays
	DO 11 I=1,X
	   B(I)=real(I)
	   C(I)=(A(I)+B(I))/2.
 11	CONTINUE
C	Sort A and mix B,C
	CALL PIKSR3(X,A,B,C)
	WRITE(*,*) 'After sorting A and mixing B and C, array A is:'
	WRITE(FMT,'(A)')'(1X,10F7.2)'
	DO 12 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 12	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 13 I=1,X/DIV
	   WRITE(*,FMT) (B(DIV*(I-1)+J), J=1,DIV)
 13	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 16 I=1,X/DIV
	   WRITE(*,FMT) (C(DIV*(I-1)+J), J=1,DIV)
 16	CONTINUE
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A,C
	CALL PIKSR3(X,B,A,C)
	WRITE(*,*) 'After sorting B and mixing A and C, array A is:'
	DO 14 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,X/DIV
	   WRITE(*,FMT) (B(DIV*(I-1)+J), J=1,DIV)
 15	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 17 I=1,X/DIV
	   WRITE(*,FMT) (C(DIV*(I-1)+J), J=1,DIV)
 17	CONTINUE
	END
