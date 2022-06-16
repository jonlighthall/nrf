	PROGRAM D8R1
C	Driver for routine PIKSRT
	implicit none
	interface
	   SUBROUTINE piksrt(n,arr)
	   INTEGER, intent(in) :: n
	   REAL, intent(in) :: arr(n)
	   end subroutine
	end interface
	real A
	integer I,J
	INTEGER, PARAMETER :: X=100, DIV=10
	DIMENSION A(X)
	INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
	CHARACTER(LEN = 256) :: FMT
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,X)
	CLOSE(UNIT)
C	Print original array
	WRITE(*,*) 'Original array:'
	WRITE(FMT,'(A)')'(1X,10F6.2)'
	DO 11 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J),J=1,DIV)
 11	CONTINUE
C	Sort array
	CALL PIKSRT(X,A)
C	Print sorted array
	WRITE(*,*) 'Sorted array:'
	DO 12 I=1,X/DIV
	   WRITE(*,FMT) (A(DIV*(I-1)+J),J=1,DIV)
 12	CONTINUE
	END
