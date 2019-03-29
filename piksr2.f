SUBROUTINE piksr2(n,arr,brr)
INTEGER n
REAL arr(n),brr(n)
Sorts an array arr(1:n) into ascending numerical order, by straight insertion, while making
the corresponding rearrangement of the array brr(1:n).
INTEGER i,j
REAL a,b
do 12 j=2,n Pick out each element in turn.
a=arr(j)
b=brr(j)
do 11 i=j-1,1,-1 Look for the place to insert it.
if(arr(i).le.a)goto 10
arr(i+1)=arr(i)
brr(i+1)=brr(i)
enddo 11
i=0
10 arr(i+1)=a Insert it.
brr(i+1)=b
enddo 12
return
END
