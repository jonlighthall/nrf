	PROGRAM D8R2
C	Driver for routine PIKSR4_1222
	INTEGER, PARAMETER :: X=6, Y=2, DIV=2
	DIMENSION A(X),B(X,Y),C(X,Y)
	INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
	CHARACTER(LEN = 256) :: FMT
	CHARACTER(LEN = 3) :: D(X,Y)
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,X)
	CLOSE(UNIT)
C	Generate B and C arrays
	DO 11 I=1,X
	   DO J=1,Y
	   B(I,J)=I-1+J-1
	   C(I,J)=(A(I)+B(I,J))/2.+J-1
	   WRITE(D(I,J),'(F3.0)')C(I,J)
	   ENDDO
 11	CONTINUE
C	Print original arrays
	WRITE(*,*) 'Original arrys:'
	WRITE(FMT,'(A)')'(1X,10F7.2)'
	DO 12 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 12	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 13 I=1,X/DIV
	   WRITE(*,FMT) (B(DIV*(I-1)+J,:), J=1,DIV)
 13	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 16 I=1,X/DIV
	   WRITE(*,FMT) (C(DIV*(I-1)+J,:), J=1,DIV)
 16	CONTINUE
	WRITE(*,*) '...and array D is:'
	DO I=1,X/DIV
	   WRITE(*,'(3X,10(A,4X))') (D(DIV*(I-1)+J,:), J=1,DIV)
	ENDDO
	WRITE(*,*) 'press RETURN to continue...'
	READ(*,*)
C	Sort B and mix A,C
c	CALL PIKSR3(X,A,Y,B,Y,C)
	CALL PIKSR4(X,A,Y,B,Y,C,3,D)
	WRITE(*,*) 'After sorting A and mixing B and C, array A is:'
	DO 14 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
 14	CONTINUE
	WRITE(*,*) '...and array B is:'
	DO 15 I=1,X/DIV
	   WRITE(*,FMT) (B(DIV*(I-1)+J,:), J=1,DIV)
 15	CONTINUE
	WRITE(*,*) '...and array C is:'
	DO 17 I=1,X/DIV
	   WRITE(*,FMT) (C(DIV*(I-1)+J,:), J=1,DIV)
 17	CONTINUE
	WRITE(*,*) '...and array D is:'
	DO I=1,X/DIV
	   WRITE(*,'(3X,10(A,4X))') (D(DIV*(I-1)+J,:), J=1,DIV)
	ENDDO
	END
