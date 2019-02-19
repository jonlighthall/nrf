# compiler
your_f77 = gfortran
# compile flags
fflags = -std=legacy
# link flags
lflags = -c $(fflags)

srcs = flmoon.dem.o flmoon.o julday.o caldat.o

flmoon.exe: $(srcs)
	$(your_f77) $(fflags) $(srcs) -o flmoon.exe


flmoon.dem.o: flmoon.dem.f flmoon.o julday.o caldat.o
	$(your_f77) $(lflags) flmoon.dem.f 

flmoon.o: flmoon.f
	 $(your_f77) $(lflags) flmoon.f

julday.o: julday.f
	 $(your_f77) $(lflags) julday.f

caldat.o: caldat.f
	 $(your_f77) $(lflags) caldat.f

clean:
	rm -fv *.o
	rm -fv *.exe
