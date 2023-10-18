module piksrt_dim
  implicit none
  ! define interfaces
  interface
     SUBROUTINE piksrt(n,arr)
       INTEGER, intent(in) :: n
       REAL, intent(in) :: arr(n)
     end subroutine piksrt

     SUBROUTINE piksr2(n,arr,brr)
       INTEGER, intent(in) :: n
       REAL, intent(in) :: arr(n),brr(n)
     end subroutine piksr2

     SUBROUTINE piksr3(n,arr,brr,crr)
       INTEGER, intent(in) :: n
       REAL, intent(in) :: arr(n),brr(n),crr(n)
     end subroutine piksr3
  end interface
  ! define array dimensions
  INTEGER, PARAMETER :: X=100, DIV=10
  real A
  DIMENSION A(X)
  ! define common varialbes
  integer I,J
  INTEGER, PARAMETER :: UNIT=1 ! unit 5 reserved for keyboard
  CHARACTER(LEN = 256) :: FMT, iFMT

contains
  subroutine set_fmt()
    ! format printing
    write(FMT,'("(1x,",i0,"f7.2)")') DIV
    write(iFMT,'("(1x,",i0,"i4)")') DIV
  end subroutine set_fmt

  subroutine read_file()
    ! read data files
    OPEN(UNIT,FILE='dat/tarray.dat',STATUS='OLD')
    READ(UNIT,*) (A(I),I=1,X)
    CLOSE(UNIT)
    write(*,*) 'Contents of tarray.dat:'
    call write_a()
  end subroutine read_file

  subroutine write_a()
    call set_fmt()
    ! print array
    DO I=1,X/DIV
       WRITE(*,FMT) (A(DIV*(I-1)+J), J=1,DIV)
    enddo
  end subroutine write_a
end module piksrt_dim
