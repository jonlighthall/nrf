      SUBROUTINE piksr4(n,arr,bn,brr,cn,crr,dn,drr)
      INTEGER n,bn,cn,dn,brr(n,bn),crr(n,cn)
      REAL arr(n)
      character(len = dn) drr(n,cn)
c     Sorts a 1D array arr(1:n) into ascending numerical order, by
c     straight insertion, while making the corresponding rearrangement
c     of the 2D arrays brr(1:n,1:bn) anc crr(1:n,1:cn).
      INTEGER i,j,b(bn),c(cn)
      REAL a
      character(len = dn) d(cn)
      do 12 j=2,n               ! Pick out each element in turn.
         a=arr(j)
         b=brr(j,:)
         c=crr(j, :)
         d=drr(j, :)
         do 11 i=j-1,1,-1       ! Look for the place to insert it.
            if(arr(i).le.a)goto 10
            arr(i+1)=arr(i)
            brr(i+1,:)=brr(i,:)
            crr(i+1,:)=crr(i,:)
            drr(i+1,:)=drr(i,:)
 11      enddo 
         i=0
 10      arr(i+1)=a             ! Insert it.
         brr(i+1,:)=b
         crr(i+1,:)=c
         drr(i+1,:)=d
 12   enddo 
      return
      END
