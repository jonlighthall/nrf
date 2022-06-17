	PROGRAM D8R2
C	Driver for routine PIKSR2
	use piksrt_dim, only : DIV,FMT,I,J,X,A,piksr2,read_file,iFMT
	implicit none
	integer B
	real Br
	DIMENSION B(X),Br(X)
	call read_file
C	Generate B array
	DO 11 I=1,X
	   B(I)=I
 11	CONTINUE
C	Sort A and mix B
	Br=real(B)
	CALL PIKSR2(X,A,Br)
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
	Br=real(B)
	CALL PIKSR2(X,Br,A)
	WRITE(*,*) 'After sorting B and mixing A, array A is:'
	DO 14 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,X/DIV
	   WRITE(*,iFMT) (B(DIV*(I-1)+J), J=1,DIV)
 15	CONTINUE
	END
