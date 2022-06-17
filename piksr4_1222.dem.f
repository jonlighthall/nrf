	PROGRAM D8R2
	use piksrt_dim, only : FMT,read_file,I,J
C	Driver for routine PIKSR4_1222
	implicit none
	interface
	   SUBROUTINE piksr4(n,arr,bn,brr,cn,crr,dn,drr)
	   INTEGER, intent(in) :: n,bn,cn,dn,brr(n,bn),crr(n,cn)
	   REAL, intent(in) :: arr(n)
	   character(len = dn), intent(in) :: drr(n,cn)
	   end subroutine
	end interface
	real A
	integer B,C
	INTEGER, PARAMETER :: X=6, Y=2, DIV=2, str_len=3
	DIMENSION A(X),B(X,Y),C(X,Y)
	CHARACTER(LEN = 256) :: iFMT,sFMT
	CHARACTER(LEN = str_len) :: D(X,Y)
	call read_file
C	Generate B and C arrays
	write(iFMT,'("(i",i0,")")') str_len
	DO 11 I=1,X
	   DO J=1,Y
	      B(I,J)=I-1+J-1
	      C(I,J)=(int(A(I))+B(I,J))/2+J-1
	      WRITE(D(I,J),iFMT)C(I,J)
	   ENDDO
 11	CONTINUE
c	Format printing
	write(FMT,'("(1x,",i0,"f7.2)")') DIV
	write(iFMT,'("(1x,",i0,"i",i0,")")') DIV, str_len
	write(sFMT,'("(1x,",i0,"A",i0,")")') DIV, str_len
C	Print original arrays
	WRITE(*,*) 'Before sorting, array A is:'
	DO 12 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 12	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 13 I=1,X/DIV
	   WRITE(*,iFMT) (B(DIV*(I-1)+J,:), J=1,DIV)
 13	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 16 I=1,X/DIV
	   WRITE(*,iFMT) (C(DIV*(I-1)+J,:), J=1,DIV)
 16	CONTINUE
	WRITE(*,*) '...and array D is:'
	DO I=1,X/DIV
	   WRITE(*,sFMT) (D(DIV*(I-1)+J,:), J=1,DIV)
	ENDDO
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A,C
	CALL PIKSR4(X,A,Y,B,Y,C,str_len,D)
	WRITE(*,*) 'After sorting A and mixing B and C, array A is:'
	DO 14 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,X/DIV
	   WRITE(*,iFMT) (B(DIV*(I-1)+J,:), J=1,DIV)
 15	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 17 I=1,X/DIV
	   WRITE(*,iFMT) (C(DIV*(I-1)+J,:), J=1,DIV)
 17	CONTINUE
	WRITE(*,*) '...and array D is:'
	DO I=1,X/DIV
	   WRITE(*,sFMT) (D(DIV*(I-1)+J,:), J=1,DIV)
	ENDDO
	END
