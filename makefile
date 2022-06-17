# fortran compiler
your_f77 = gfortran
#
# general flags
compile_flags = -c $<
output_flags = -o $@
mod_flags = -J $(MODDIR)
#
# fortran compile flags
warnings = -Wall -Wsurprising -W -pedantic -Warray-temporaries	\
-Wcharacter-truncation -Wconversion-extra -Wimplicit-interface	\
-Wimplicit-procedure -Winteger-division -Wintrinsics-std	\
-Wreal-q-constant -Wuse-without-only -Wrealloc-lhs-all -Wno-tabs
#warnings = -w
fcflags = $(f90cflags) -fd-lines-as-comments
f90cflags = -fimplicit-none $(warnings) $(compile_flags) $(output_flags) $(mod_flags)
#
# fortran link flags
flflags = $^ $(output_flags)
#
# define subdirectories
OBJDIR=obj
BINDIR=bin
MODDIR=mod
#
# dependencies
DEPS=$(addprefix $(OBJDIR)/,julday.o flmoon.o caldat.o moon_calc.o)
#
# executable name
TARGET = badluk.exe

all: $(addprefix $(BINDIR)/,$(TARGET) flmoon.exe julday.exe caldat.exe piksrt.exe piksr2.exe piksr3.exe piksr3_122.exe piksr4_1222.exe)

$(BINDIR)/$(TARGET): $(DEPS) $(addprefix $(OBJDIR)/,badluk.o piksr4_1222.o) | $(BINDIR)
	$(your_f77) $(flflags) #-free-form
#
# defin directory creation
$(OBJDIR):
	mkdir -pv $(OBJDIR)
$(BINDIR):
	mkdir -pv $(BINDIR)
$(MODDIR):
	mkdir -pv $(MODDIR)

$(BINDIR)/%.exe: $(addprefix $(OBJDIR)/,%.dem.o %.o piksrt_dim.o) $(DEPS) | $(BINDIR)
	$(your_f77) $(flflags) 

$(OBJDIR)/%.o: %.f | $(OBJDIR) $(MODDIR)
	 $(your_f77) $(fcflags)


$(OBJDIR)/%.o: %.f90 | $(OBJDIR) $(MODDIR)
	 $(your_f77) $(f90cflags)

CMD = @rm -vfrd
clean:
# remove compiled binaries
	$(CMD) $(TARGET)
	$(CMD) $(OBJDIR)/*.o
	$(CMD) $(OBJDIR)
	$(CMD) *.o *.obj
	$(CMD) $(MODDIR)/*.mod
	$(CMD) $(MODDIR)
	$(CMD) *.mod
	$(CMD) $(BINDIR)/*.exe
	$(CMD) $(BINDIR)
	$(CMD) *.exe
	$(CMD) *.out
	$(CMD) fort.*
distclean: clean
# remove Git versions
	$(CMD) *.~*~
# remove Emacs backup files
	$(CMD) *~ \#*\#
test: distclean $(addprefix $(BINDIR)/,$(TARGET) caldat.exe piksrt.exe)
# test executabiles that run without user input
	./$(BINDIR)/$(TARGET)
	./$(BINDIR)/caldat.exe
	./$(BINDIR)/piksrt.exe
