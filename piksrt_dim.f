      module piksrt_dim
      implicit none
      INTEGER, PARAMETER :: X=100, DIV=10

      interface
         SUBROUTINE piksrt(n,arr)
         INTEGER, intent(in) :: n
         REAL, intent(in) :: arr(n)
         end subroutine

      SUBROUTINE piksr2(n,arr,brr)
      INTEGER, intent(in) :: n
      REAL, intent(in) ::	arr(n),brr(n)
      end subroutine

      SUBROUTINE piksr3(n,arr,brr,crr)
      INTEGER, intent(in) :: n
      REAL, intent(in) :: arr(n),brr(n),crr(n)
      end subroutine

      end interface
      real A
      integer I,J
      DIMENSION A(X)
      INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
      CHARACTER(LEN = 256) :: FMT

      contains
      subroutine set_fmt()

c     Format printing
      write(FMT,'("(1x,",i0,"f7.2)")') DIV
      end subroutine

      subroutine read_file()
	OPEN(UNIT,FILE='tarray.dat',STATUS='OLD')
	READ(UNIT,*) (A(I),I=1,X)
	CLOSE(UNIT)
	call set_fmt()

      
      end subroutine


      end module piksrt_dim
