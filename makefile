# fortran compiler
your_f77 = gfortran
# fortran compile flags
warnings = -Wall -Wsurprising -W -pedantic -Warray-temporaries	\
-Wcharacter-truncation -Wconversion-extra -Wimplicit-interface	\
-Wimplicit-procedure -Winteger-division -Wintrinsics-std	\
-Wreal-q-constant -Wuse-without-only -Wrealloc-lhs-all -Wno-tabs
debug = -g							\
-ffpe-trap=invalid,zero,overflow,underflow,inexact,denormal	\
-fcheck=all -fbacktrace
output = -o $@
fcflags = -fimplicit-none -fd-lines-as-comments $(warnings) $(debug) $(output)
# fortran link flags
flflags = -c $(fcflags)

all: flmoon.exe julday.exe badluk.exe caldat.exe piksrt.exe piksr2.exe \
	 piksr3.exe piksr3_122.exe piksr4_1222.exe

flmoon.exe: flmoon.dem.o flmoon.o julday.o caldat.o
	$(your_f77) $(fcflags) $^

badluk.exe: badluk.o flmoon.o julday.o piksr4_1222.o
	$(your_f77) $(fcflags) $^

caldat.exe: caldat.dem.o julday.o caldat.o
	$(your_f77) $(fcflags) $^

%.exe: %.dem.o %.o
	$(your_f77) $(fcflags) $^

%.o: %.f	
	 $(your_f77) $(flflags) $<

clean:
	rm -fv *.o
	rm -fv *.exe
	rm -fv fort.*
CMD = @rm -vfrd
distclean: clean
# remove Git versions
	$(CMD) *.~*~
test:
	./badluck.exe
