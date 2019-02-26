SUBROUTINE piksrt(n,arr)
INTEGER n
REAL arr(n)
Sorts an array arr(1:n) into ascending numerical order, by straight insertion. n is input;
arr is replaced on output by its sorted rearrangement.
INTEGER i,j
REAL a
do 12 j=2,n Pick out each element in turn.
a=arr(j)
do 11 i=j-1,1,-1 Look for the place to insert it.
if(arr(i).le.a)goto 10
arr(i+1)=arr(i)
enddo 11
i=0
10 arr(i+1)=a Insert it.
enddo 12
return
END
