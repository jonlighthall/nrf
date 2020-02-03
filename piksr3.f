      SUBROUTINE piksr3(n,arr,brr,crr)
      INTEGER n
      REAL arr(n),brr(n),crr(n)
c     Sorts an array arr(1:n) into ascending numerical order, by
c     straight insertion, while making the corresponding rearrangement
c     of the arrays brr(1:n) and crr(1:n).
      INTEGER i,j
      REAL a,b,c
      do 12 j=2,n               ! Pick out each element in turn.
         a=arr(j)
         b=brr(j)
         c=crr(j)
         do 11 i=j-1,1,-1       ! Look for the place to insert it.
            if(arr(i).le.a)goto 10
            arr(i+1)=arr(i)
            brr(i+1)=brr(i)
            crr(i+1)=crr(i)
 11      enddo 
         i=0
 10      arr(i+1)=a             ! Insert it.
         brr(i+1)=b
         crr(i+1)=c
 12   enddo 
      return
      END
