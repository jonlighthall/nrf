# compiler
your_f77 = gfortran
# compile flags
fcflags = -std=legacy
# link flags
flflags = -c $(fcflags)

all: flmoon.exe julday.exe badluk.exe caldat.exe

flmoon.exe: flmoon.dem.o flmoon.o julday.o caldat.o
	$(your_f77) $(fcflags) $? -o $@

julday.exe: julday.dem.o julday.o
	$(your_f77) $(fcflags) $? -o $@

badluk.exe: badluk.o flmoon.o julday.o
	$(your_f77) $(fcflags) $? -o $@

caldat.exe: caldat.dem.o julday.o caldat.o
	$(your_f77) $(fcflags) $? -o $@

%.o: %.f	
	 $(your_f77) $(flflags) $<

clean:
	rm -fv *.o
	rm -fv *.exe

