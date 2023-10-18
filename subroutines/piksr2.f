      SUBROUTINE piksr2(n,arr,brr)
      INTEGER n
      REAL arr(n),brr(n)
c     Sorts an array arr(1:n) into ascending numerical order, by
c     straight insertion, while making the corresponding rearrangement
c     of the array brr(1:n).
      INTEGER i,j
      REAL a,b
      do j=2,n                  ! Pick out each element in turn.
         a=arr(j)
         b=brr(j)
         do i=j-1,1,-1          ! Look for the place to insert it.
            if(arr(i).le.a)goto 10
            arr(i+1)=arr(i)
            brr(i+1)=brr(i)
         enddo
         i=0
 10      arr(i+1)=a             ! Insert it.
         brr(i+1)=b
      enddo
      return
      END
