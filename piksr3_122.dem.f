	PROGRAM D8R2
C	Driver for routine PIKSR3_122
	implicit none
	interface
	   SUBROUTINE piksr3(n,arr,bn,brr,cn,crr)
	   INTEGER, intent(in) :: n,bn,cn,brr(n,bn),crr(n,cn)
	   REAL, intent(in) :: arr(n)
	   end subroutine
	end interface
	real A
	integer I,J,B,C
	INTEGER, PARAMETER :: X=6, Y=2, DIV=2
	DIMENSION A(X),B(X,Y),C(X,Y)
	INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
	CHARACTER(LEN = 256) :: FMT,iFMT
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,X)
	CLOSE(UNIT)
C	Generate B and C arrays
	DO 11 I=1,X
	   DO J=1,Y
	      B(I,J)=I-1+J-1
	      C(I,J)=(A(I)+B(I,J))/2+J-1
	   ENDDO
 11	CONTINUE
c	Format printing
	write(FMT,'("(1x,",i0,"f7.2)")') DIV
	write(iFMT,'("(1x,",i0,"i3)")') DIV
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
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A,C
	CALL PIKSR3(X,A,Y,B,Y,C)
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
	END
