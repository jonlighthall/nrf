# fortran compiler
your_f77 = gfortran
# general flags
compile_flags = -c $<
output_flags = -o $@
# fortran compile flags
warnings = -Wall -Wsurprising -W -pedantic -Warray-temporaries	\
-Wcharacter-truncation -Wconversion-extra -Wimplicit-interface	\
-Wimplicit-procedure -Winteger-division -Wintrinsics-std	\
-Wreal-q-constant -Wuse-without-only -Wrealloc-lhs-all -Wno-tabs
warnings = -w
fcflags = -fimplicit-none -fd-lines-as-comments $(warnings) $(compile_flags) $(output_flags)
# fortran link flags
flflags = $^ $(output_flags)
OBJDIR=obj
OBJS=$(addprefix $(OBJDIR)/,julday.o flmoon.o caldat.o)
BINDIR=bin
# executable name
TARGET = badluk.exe

all: $(addprefix $(BINDIR)/,$(TARGET) flmoon.exe julday.exe caldat.exe piksrt.exe piksr2.exe piksr3.exe piksr3_122.exe piksr4_1222.exe)

$(BINDIR)/$(TARGET): $(OBJS) $(addprefix $(OBJDIR)/,badluk.o piksr4_1222.o) | $(BINDIR)
	$(your_f77) $(flflags) 

# object directory
$(OBJDIR):
	mkdir -pv $(OBJDIR)

# object directory
$(BINDIR):
	mkdir -pv $(BINDIR)

$(BINDIR)/%.exe: $(addprefix $(OBJDIR)/,%.dem.o %.o) $(OBJS) | $(BINDIR)
	$(your_f77) $(flflags) 

$(OBJDIR)/%.o: %.f | $(OBJDIR)
	 $(your_f77) $(fcflags) 

CMD = @rm -vfrd
clean:
# remove compiled binaries
	$(CMD) $(TARGET)
	$(CMD) $(OBJDIR)/*.o
	$(CMD) $(OBJDIR)
	$(CMD) *.o *.obj
	$(CMD) $(BINDIR)/*.exe
	$(CMD) $(BINDIR)
	$(CMD) *.exe
	$(CMD) *.out
	$(CMD) fort.*
distclean: clean
# remove Git versions
	$(CMD) *.~*~
test: distclean $(addprefix $(BINDIR)/,$(TARGET) caldat.exe piksrt.exe)
	./$(BINDIR)/$(TARGET)
	./$(BINDIR)/caldat.exe
	./$(BINDIR)/piksrt.exe
