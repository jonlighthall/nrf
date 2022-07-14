# fortran compiler
FC = gfortran
# general flags
compile_flags = -c $<
output_flags = -o $@
module_flags = -J $(MODDIR)
#
# fortran compiler flags
FCFLAGS = -std=f2018 -fimplicit-none $(warnings)
F77CFLAGS = $(FCFLAGS) -fd-lines-as-comments
F90CFLAGS = $(FCFLAGS)

warnings = -Wall -Wsurprising -W -pedantic -Warray-temporaries		\
-Wcharacter-truncation -Wconversion-extra -Wimplicit-interface		\
-Wimplicit-procedure -Winteger-division -Wintrinsics-std		\
-Wreal-q-constant -Wuse-without-only -Wrealloc-lhs-all -Wno-tabs	\

#warnings = -w

#
# fortran link flags
flflags = $(output_flags) $^
#
# define subdirectories
OBJDIR := obj
MODDIR := mod
BINDIR := bin
#
# dependencies
SRC=$(wildcard *.f)
OBJS = $(addprefix $(OBJDIR)/,$(SRC:.f=.o))

DEMOS=$(wildcard *.dem.f)
DRIVERS=$(addprefix $(BINDIR)/,$(DEMOS:.dem.f=.exe))

MODS = piksrt_dim moon_calc dates
SUBS =  flmoon caldat
FUNS = julday
DEPS := $(addprefix $(OBJDIR)/,$(addsuffix .o,$(MODS) $(FUNS) $(SUBS)))
MODS := $(addprefix $(MODDIR)/,$(addsuffix .mod,$(MODS)))

#
# executable name
TARGET = badluk.exe

EXES = $(addprefix $(BINDIR)/,$(TARGET)) $(DRIVERS)

all: $(EXES) $(OBJS) $(DEPS) $(MODS)
	@echo "$@ done"

sort=piksr
$(BINDIR)/$(sort)%.exe: $(addprefix $(OBJDIR)/, $(sort)%.dem.o $(sort)%.o $(sort)t_dim.o) | $(BINDIR)
	@echo "compiling pick sort executable $@..."
	$(FC) $(FCFLAGS) $(flflags) $(module_flags)

$(BINDIR)/%.exe: $(addprefix $(OBJDIR)/, %.dem.o) $(DEPS) | $(BINDIR)
	@echo "compiling driver executable $@..."
	$(FC) $(FCFLAGS) $(flflags) $(module_flags)

$(BINDIR)/$(TARGET): $(addprefix $(OBJDIR)/, $(TARGET:.exe=.o) $(sort)4_1222.o) $(DEPS) | $(BINDIR)
	@echo "compiling target executable $@..."
	$(FC) $(FCFLAGS) $(flflags) $(module_flags)

$(OBJDIR)/%.dem.o : %.dem.f %.f | $(OBJDIR) $(MODS)
	@echo "compiling driver object $@..."
	$(FC) $(FCFLAGS) $(compile_flags) $(output_flags) $(module_flags)

$(OBJDIR)/%.o $(MODDIR)/%.mod : %.f | $(OBJDIR) $(MODDIR)
	@echo "compiling $@..."
	echo "$*"
	$(FC) $(FCFLAGS) $(compile_flags) -o $(OBJDIR)/$*.o $(module_flags)

$(OBJDIR)/%.o : %.f90 $(MODS) | $(OBJDIR)
	@echo "compiling f90 object $@..."
	$(FC) $(FCFLAGS) $(compile_flags) -o $(OBJDIR)/$*.o $(module_flags)

$(MODDIR)/%.mod : %.f90 | $(MODDIR)
	@echo "compiling f90 module $@..."
	$(FC) $(FCFLAGS) $(compile_flags) -o $(OBJDIR)/$*.o $(module_flags)
#
# define directory creation
$(OBJDIR):
	@mkdir -v $(OBJDIR)
$(BINDIR):
	@mkdir -v $(BINDIR)
$(MODDIR):
	@mkdir -v $(MODDIR)
# keep intermediate object files
.SECONDARY: $(OBJS) $(MODS)
#
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
	@echo "$@ done"
distclean: clean
# remove Git versions
	$(CMD) *.~*~
# remove Emacs backup files
	$(CMD) *~ \#*\#
	@echo "$@ done"
test: distclean all
# test the makefile
	@echo "$@ done"	
run: test
# run executables which do no require user input
	./$(BINDIR)/$(TARGET)
	./$(BINDIR)/caldat.exe
	./$(BINDIR)/piksrt.exe
	@echo "$@ done"
