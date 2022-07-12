      SUBROUTINE piksr3(n,arr,bn,brr,cn,crr)
      INTEGER n,bn,cn
      REAL arr(n),brr(n,bn),crr(n,cn)
c     Sorts a 1D array arr(1:n) into ascending numerical order, by
c     straight insertion, while making the corresponding rearrangement
c     of the 2D arrays brr(1:n,1:bn) and crr(1:n,1:cn).
      INTEGER i,j
      REAL a
      real b(bn),c(cn)
      do j=2,n                  ! Pick out each element in turn.
         a=arr(j)
         b=brr(j,:)
         c=crr(j, :)
         do i=j-1,1,-1          ! Look for the place to insert it.
            if(arr(i).le.a)goto 10
            arr(i+1)=arr(i)
            brr(i+1,:)=brr(i,:)
            crr(i+1,:)=crr(i,:)
         enddo
         i=0
 10      arr(i+1)=a             ! Insert it.
         brr(i+1,:)=b
         crr(i+1,:)=c
      enddo
      return
      END
