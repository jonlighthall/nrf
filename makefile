# compiler
your_f77 = gfortran
# compile flags
fcflags = -std=legacy
# link flags
flflags = -c $(fcflags)

objs = flmoon.dem.o flmoon.o julday.o caldat.o

flmoon.exe: $(objs)
	$(your_f77) $(fcflags) $(objs) -o flmoon.exe

%.o: %.f	
	 $(your_f77) $(flflags) $<

clean:
	rm -fv $(objs)
	rm -fv *.exe

