	PROGRAM D8R1
C	Driver for routine PIKSRT
	DIMENSION A(100)
	INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,100)
	CLOSE(UNIT)
C	Print original array
	WRITE(*,*) 'Original array:'
	DO 11 I=1,10
	   WRITE(*,'(1X,10F6.2)') (A(10*(I-1)+J),J=1,10)
 11	CONTINUE
C	Sort array
	CALL PIKSRT(100,A)
C	Print sorted array
	WRITE(*,*) 'Sorted array:'
	DO 12 I=1,10
	   WRITE(*,'(1X,10F6.2)') (A(10*(I-1)+J),J=1,10)
 12	CONTINUE
	END
