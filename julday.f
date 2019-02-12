FUNCTION julday(mm,id,iyyy)
INTEGER julday,id,iyyy,mm,IGREG
PARAMETER (IGREG=15+31*(10+12*1582)) Gregorian Calendar adopted Oct. 15, 1582.
In this routine julday returns the Julian Day Number that begins at noon of the calendar
date specied by month mm, day id, and year iyyy, all integer variables. Positive year
signies A.D.; negative, B.C. Remember that the year after 1 B.C. was 1 A.D.
INTEGER ja,jm,jy
jy=iyyy
if (jy.eq.0) pause 'julday: there is no year zero'
if (jy.lt.0) jy=jy+1
if (mm.gt.2) then Here is an example of a block IF-structure.
jm=mm+1
else
jy=jy-1
jm=mm+13
endif
julday=int(365.25*jy)+int(30.6001*jm)+id+1720995
if (id+31*(mm+12*iyyy).ge.IGREG) then Test whether to change to Gregorian Calenja=
int(0.01*jy) dar.
julday=julday+2-ja+int(0.25*ja)
endif
return
END
