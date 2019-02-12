SUBROUTINE lubksb(a,n,np,indx,b)
INTEGER n,np,indx(n)
REAL a(np,np),b(n)
Solves the set of n linear equations A  X = B. Here a is input, not as the matrix A but
rather as its LU decomposition, determined by the routine ludcmp. indx is input as the
permutation vector returned by ludcmp. b(1:n) is input as the right-hand side vector B,
and returns with the solution vector X. a, n, np, and indx are not modied by this routine
and can be left in place for successive calls with dierent right-hand sides b. This routine
takes into account the possibility that b will begin with many zero elements, so it is ecient
for use in matrix inversion.
INTEGER i,ii,j,ll
REAL sum
ii=0 When ii is set to a positive value, it will become the index
of the rst nonvanishing element of b. We now do
the forward substitution, equation (2.3.6). The only new
wrinkle is to unscramble the permutation as we go.
do 12 i=1,n
ll=indx(i)
sum=b(ll)
b(ll)=b(i)
if (ii.ne.0)then
do 11 j=ii,i-1
sum=sum-a(i,j)*b(j)
enddo 11
else if (sum.ne.0.) then
ii=i A nonzero element was encountered, so from now on we will
have to endif do the sums in the loop above.
b(i)=sum
enddo 12
do 14 i=n,1,-1 Now we do the backsubstitution, equation (2.3.7).
sum=b(i)
do 13 j=i+1,n
sum=sum-a(i,j)*b(j)
enddo 13
b(i)=sum/a(i,i) Store a component of the solution vector X.
enddo 14
return All done!
END
