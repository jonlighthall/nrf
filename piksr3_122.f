      SUBROUTINE piksr3(n,arr,bn,brr,cn,crr)
      INTEGER n,bn,cn
      REAL arr(n)
      integer brr(n,bn),crr(n,cn)
c     Sorts an array arr(1:n) into ascending numerical order, by
c     straight insertion, while making the corresponding rearrangement
c     of the array brr(1:n).
      INTEGER i,j
      REAL a
      real b(bn),c(cn)
c$$$      write(*,*) 'n=',n
c$$$      write(*,*) arr
c$$$      write(*,*) 'bn=',bn
c$$$      write(*,*) brr
c$$$      write(*,*) 'cn=',cn
c$$$      write(*,*) crr


      do 12 j=2,n               ! Pick out each element in turn.
         a=arr(j)
         b=brr(j,:)
c         write(*,*) b
         c=crr(j, :)
         do 11 i=j-1,1,-1       ! Look for the place to insert it.
            if(arr(i).le.a)goto 10
            arr(i+1)=arr(i)
            brr(i+1,:)=brr(i,:)
            crr(i+1,:)=crr(i,:)
 11      enddo 
         i=0
 10      arr(i+1)=a             ! Insert it.
         brr(i+1,:)=b
         crr(i+1,:)=c
 12   enddo 
      return
      END
