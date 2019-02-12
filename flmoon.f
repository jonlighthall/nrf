SUBROUTINE flmoon(n,nph,jd,frac)
INTEGER jd,n,nph
REAL frac,RAD
PARAMETER (RAD=3.14159265/180.)
Our programs begin with an introductory comment summarizing their purpose and explaining
their calling sequence. This routine calculates the phases of the moon. Given an integer
n and a code nph for the phase desired (nph = 0 for new moon, 1 for rst quarter, 2 for
full, 3 for last quarter), the routine returns the Julian Day Number jd, and the fractional
part of a day frac to be added to it, of the nth such phase since January, 1900. Greenwich
Mean Time is assumed.
INTEGER i
REAL am,as,c,t,t2,xtra
c=n+nph/4. This is how we comment an individual line.
t=c/1236.85
t2=t**2
1
2 Chapter 1. Preliminaries
Sample page from NUMERICAL RECIPES IN FORTRAN 77: THE ART OF SCIENTIFIC COMPUTING (ISBN 0-521-43064-X)
Copyright (C) 1986-1992 by Cambridge University Press.
Programs Copyright (C) 1986-1992 by Numerical Recipes Software.
Permission is granted for internet users to make one paper copy for their own personal use. Further reproduction, or any copying of machinereadable
files (including this one) to any server
computer, is strictly prohibited. To order Numerical Recipes books,
diskettes, or CDROMs
visit website http://www.nr.com or call 1-800-872-7423 (North America only),
or send email to trade@cup.cam.ac.uk (outside North America).
as=359.2242+29.105356*c You aren't really intended to understand this alam=
306.0253+385.816918*c+0.010730*t2 gorithm, but it does work!
jd=2415020+28*n+7*nph
xtra=0.75933+1.53058868*c+(1.178e-4-1.55e-7*t)*t2
if(nph.eq.0.or.nph.eq.2)then
xtra=xtra+(0.1734-3.93e-4*t)*sin(RAD*as)-0.4068*sin(RAD*am)
else if(nph.eq.1.or.nph.eq.3)then
xtra=xtra+(0.1721-4.e-4*t)*sin(RAD*as)-0.6280*sin(RAD*am)
else
pause 'nph is unknown in flmoon' This is how we will indicate error conditions.
endif
if(xtra.ge.0.)then
i=int(xtra)
else
i=int(xtra-1.)
endif
jd=jd+i
frac=xtra-i
return
END
