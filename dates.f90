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
  DATA NAME/'January','February','March','April','May','June','July','August','September','October','November','December'/


end module dates
