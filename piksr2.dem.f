	PROGRAM D8R2
C	Driver for routine PIKSR2
	use piksrt_dim
	implicit none
	integer B
	DIMENSION B(X)
	CHARACTER(LEN = 256) :: iFMT
	call read_file
C	Generate B array
	DO 11 I=1,X
	   B(I)=I
 11	CONTINUE
	write(iFMT,'("(1x,",i0,"i3)")') DIV
C	Sort A and mix B
	CALL PIKSR2(X,A,real(B))
	WRITE(*,*) 'After sorting A and mixing B, array A is:'
	DO 12 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 12	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 13 I=1,X/DIV
	   WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
 13	CONTINUE
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A
	CALL PIKSR2(X,real(B),A)
	WRITE(*,*) 'After sorting B and mixing A, array A is:'
	DO 14 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,X/DIV
	   WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
 15	CONTINUE
	END
