SUBROUTINE ludcmp(a,n,np,indx,d)
INTEGER n,np,indx(n),NMAX
REAL d,a(np,np),TINY
PARAMETER (NMAX=500,TINY=1.0e-20) Largest expected n, and a small number.
Given a matrix a(1:n,1:n), with physical dimension np by np, this routine replaces it by
the LU decomposition of a rowwise permutation of itself. a and n are input. a is output,
arranged as in equation (2.3.14) above; indx(1:n) is an output vector that records the
row permutation eected by the partial pivoting; d is output as 1 depending on whether
the number of row interchanges was even or odd, respectively. This routine is used in
combination with lubksb to solve linear equations or invert a matrix.
INTEGER i,imax,j,k
REAL aamax,dum,sum,vv(NMAX) vv stores the implicit scaling of each row.
d=1. No row interchanges yet.
do 12 i=1,n Loop over rows to get the implicit scaling informaaamax=
0. tion.
do 11 j=1,n
if (abs(a(i,j)).gt.aamax) aamax=abs(a(i,j))
enddo 11
if (aamax.eq.0.) pause 'singular matrix in ludcmp' No nonzero largest element.
vv(i)=1./aamax Save the scaling.
enddo 12
do 19 j=1,n This is the loop over columns of Crout's method.
do 14 i=1,j-1 This is equation (2.3.12) except for i = j.
sum=a(i,j)
do 13 k=1,i-1
sum=sum-a(i,k)*a(k,j)
enddo 13
a(i,j)=sum
enddo 14
aamax=0. Initialize for the search for largest pivot element.
do 16 i=j,n This is i = j of equation (2.3.12) and i = j+1: ::N
sum=a(i,j) of equation (2.3.13).
do 15 k=1,j-1
sum=sum-a(i,k)*a(k,j)
enddo 15
a(i,j)=sum
dum=vv(i)*abs(sum) Figure of merit for the pivot.
if (dum.ge.aamax) then Is it better than the best so far?
imax=i
aamax=dum
endif
enddo 16
if (j.ne.imax)then Do we need to interchange rows?
do 17 k=1,n Yes, do so...
dum=a(imax,k)
a(imax,k)=a(j,k)
a(j,k)=dum
enddo 17
d=-d ...and change the parity of d.
vv(imax)=vv(j) Also interchange the scale factor.
endif
indx(j)=imax
if(a(j,j).eq.0.)a(j,j)=TINY
If the pivot element is zero the matrix is singular (at least to the precision of the algorithm).
For some applications on singular matrices, it is desirable to substitute TINY
for zero.
2.3 LU Decomposition and Its Applications 39
Sample page from NUMERICAL RECIPES IN FORTRAN 77: THE ART OF SCIENTIFIC COMPUTING (ISBN 0-521-43064-X)
Copyright (C) 1986-1992 by Cambridge University Press.
Programs Copyright (C) 1986-1992 by Numerical Recipes Software.
Permission is granted for internet users to make one paper copy for their own personal use. Further reproduction, or any copying of machinereadable
files (including this one) to any server
computer, is strictly prohibited. To order Numerical Recipes books,
diskettes, or CDROMs
visit website http://www.nr.com or call 1-800-872-7423 (North America only),
or send email to trade@cup.cam.ac.uk (outside North America).
if(j.ne.n)then Now, nally, divide by the pivot element.
dum=1./a(j,j)
do 18 i=j+1,n
a(i,j)=a(i,j)*dum
enddo 18
endif
enddo 19 Go back for the next column in the reduction.
return
END
