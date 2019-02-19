# compiler
your_f77 = gfortran
# compile flags
fcflags = -std=legacy
# link flags
flflags = -c $(fcflags)

objs = flmoon.dem.o flmoon.o julday.o caldat.o

flmoon.exe: $(objs)
	$(your_f77) $(fcflags) $(objs) -o flmoon.exe


flmoon.dem.o: flmoon.dem.f flmoon.o julday.o caldat.o
	$(your_f77) $(flflags) flmoon.dem.f 

flmoon.o: flmoon.f
	 $(your_f77) $(flflags) flmoon.f

julday.o: julday.f
	 $(your_f77) $(flflags) julday.f

caldat.o: caldat.f
	 $(your_f77) $(flflags) caldat.f

clean:
	rm -fv $(objs)
	rm -fv *.exe
