module dates
  implicit none
  ! define interfaces
  interface
     SUBROUTINE caldat(julian,mm,id,iyyy)
       INTEGER, intent(in) :: julian,mm,id,iyyy
     end subroutine caldat
     integer function JULDAY(IM,ID,IY)
       integer, intent(in) :: IM,ID,IY
     end function JULDAY
  end interface

  CHARACTER NAME(12)*10
  DATA NAME/'January','February','March','April','May','June','July','August','September'&
       &,'October','November','December'/

  CHARACTER TXT*40
  integer N
  integer,parameter :: unit = 1
contains
  subroutine read_file()
    ! read data files
    OPEN(unit,FILE='data/dates.dat',STATUS='OLD')
    READ(unit,'(A)') TXT
    READ(unit,*) N
  end subroutine read_file

end module dates
