	PROGRAM D8R2
C	Driver for routine PIKSR3
	use piksrt_dim
	implicit none
	integer B,C
	DIMENSION B(X),C(X)
	CHARACTER(LEN = 256) :: iFMT
	call read_file
C	Generate B and C arrays
	DO 11 I=1,X
	   B(I)=I
	   C(I)=(A(I)+B(I))/2
 11	CONTINUE
	write(iFMT,'("(1x,",i0,"i3)")') DIV
C	Sort A and mix B,C
	CALL PIKSR3(X,A,real(B),real(C))
	WRITE(*,*) 'After sorting A and mixing B and C, array A is:'
	DO 12 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 12	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 13 I=1,X/DIV
	   WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
 13	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 16 I=1,X/DIV
	   WRITE(*,iFMT) (C(DIV*(I-1)+J), J=1,DIV)
 16	CONTINUE
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A,C
	CALL PIKSR3(X,real(B),A,real(C))
	WRITE(*,*) 'After sorting B and mixing A and C, array A is:'
	DO 14 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,X/DIV
	   WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
 15	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 17 I=1,X/DIV
	   WRITE(*,iFMT) (C(DIV*(I-1)+J), J=1,DIV)
 17	CONTINUE
	END
