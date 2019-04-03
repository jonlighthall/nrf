# compiler
your_f77 = gfortran
# compile flags
fcflags = -std=legacy
# link flags
flflags = -c $(fcflags)

all: flmoon.exe julday.exe badluk.exe caldat.exe piksrt.exe piksr2.exe \
	 piksr3.exe piksr3_122.exe piksr4_1222.exe

flmoon.exe: flmoon.dem.o flmoon.o julday.o caldat.o
	$(your_f77) $(fcflags) $^ -o $@

badluk.exe: badluk.o flmoon.o julday.o piksr4_1222.o
	$(your_f77) $(fcflags) $^ -o $@

caldat.exe: caldat.dem.o julday.o caldat.o
	$(your_f77) $(fcflags) $^ -o $@

%.exe: %.dem.o %.o
	$(your_f77) $(fcflags) $^ -o $@

%.o: %.f	
	 $(your_f77) $(flflags) $<

clean:
	rm -fv *.o
	rm -fv *.exe
	rm -fv fort.*
