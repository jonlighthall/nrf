SUBROUTINE gaussj(a,n,np,b,m,mp)
INTEGER m,mp,n,np,NMAX
REAL a(np,np),b(np,mp)
PARAMETER (NMAX=50)
Linear equation solution by Gauss-Jordan elimination, equation (2.1.1) above. a(1:n,1:n)
is an input matrix stored in an array of physical dimensions np by np. b(1:n,1:m) is an input
matrix containing the m right-hand side vectors, stored in an array of physical dimensions
np by mp. On output, a(1:n,1:n) is replaced by its matrix inverse, and b(1:n,1:m) is
replaced by the corresponding set of solution vectors.
Parameter: NMAX is the largest anticipated value of n.
INTEGER i,icol,irow,j,k,l,ll,indxc(NMAX),indxr(NMAX),
* ipiv(NMAX) The integer arrays ipiv, indxr, and indxc are used
for REAL big,dum,pivinv bookkeeping on the pivoting.
do 11 j=1,n
ipiv(j)=0
enddo 11
do 22 i=1,n This is the main loop over the columns to be rebig=
0. duced.
do 13 j=1,n This is the outer loop of the search for a pivot eleif(
ipiv(j).ne.1)then ment.
do 12 k=1,n
if (ipiv(k).eq.0) then
if (abs(a(j,k)).ge.big)then
big=abs(a(j,k))
irow=j
icol=k
endif
else if (ipiv(k).gt.1) then
pause 'singular matrix in gaussj'
endif
enddo 12
endif
enddo 13
ipiv(icol)=ipiv(icol)+1
We now have the pivot element, so we interchange rows, if needed, to put the pivot
element on the diagonal. The columns are not physically interchanged, only relabeled:
2.1 Gauss-Jordan Elimination 31
Sample page from NUMERICAL RECIPES IN FORTRAN 77: THE ART OF SCIENTIFIC COMPUTING (ISBN 0-521-43064-X)
Copyright (C) 1986-1992 by Cambridge University Press.
Programs Copyright (C) 1986-1992 by Numerical Recipes Software.
Permission is granted for internet users to make one paper copy for their own personal use. Further reproduction, or any copying of machinereadable
files (including this one) to any server
computer, is strictly prohibited. To order Numerical Recipes books,
diskettes, or CDROMs
visit website http://www.nr.com or call 1-800-872-7423 (North America only),
or send email to trade@cup.cam.ac.uk (outside North America).
indxc(i), the column of the ith pivot element, is the ith column that is reduced, while
indxr(i) is the row in which that pivot element was originally located. If indxr(i) 6=
indxc(i) there is an implied column interchange. With this form of bookkeeping, the
solution b's will end up in the correct order, and the inverse matrix will be scrambled
by columns.
if (irow.ne.icol) then
do 14 l=1,n
dum=a(irow,l)
a(irow,l)=a(icol,l)
a(icol,l)=dum
enddo 14
do 15 l=1,m
dum=b(irow,l)
b(irow,l)=b(icol,l)
b(icol,l)=dum
enddo 15
endif
indxr(i)=irow We are now ready to divide the pivot row by the pivot
indxc(i)=icol element, located at irow and icol.
if (a(icol,icol).eq.0.) pause 'singular matrix in gaussj'
pivinv=1./a(icol,icol)
a(icol,icol)=1.
do 16 l=1,n
a(icol,l)=a(icol,l)*pivinv
enddo 16
do 17 l=1,m
b(icol,l)=b(icol,l)*pivinv
enddo 17
do 21 ll=1,n Next, we reduce the rows...
if(ll.ne.icol)then ...except for the pivot one, of course.
dum=a(ll,icol)
a(ll,icol)=0.
do 18 l=1,n
a(ll,l)=a(ll,l)-a(icol,l)*dum
enddo 18
do 19 l=1,m
b(ll,l)=b(ll,l)-b(icol,l)*dum
enddo 19
endif
enddo 21
enddo 22 This is the end of the main loop over columns of the reduction.
do 24 l=n,1,-1 It only remains to unscramble the solution in view
of the column interchanges. We do this by interchanging
pairs of columns in the reverse order
that the permutation was built up.
if(indxr(l).ne.indxc(l))then
do 23 k=1,n
dum=a(k,indxr(l))
a(k,indxr(l))=a(k,indxc(l))
a(k,indxc(l))=dum
enddo 23
endif
enddo 24
return And we are done.
END
