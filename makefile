# fortran compiler
FC = gfortran
#
# general flags
compile = -c $<
output = -o $@
includes = -J $(MODDIR)
options = -fimplicit-none
warnings = -Wall -Wsurprising -W -pedantic -Warray-temporaries	\
-Wcharacter-truncation -Wconversion-extra -Wimplicit-interface	\
-Wimplicit-procedure -Winteger-division -Wintrinsics-std	\
-Wreal-q-constant -Wuse-without-only -Wrealloc-lhs-all
debug = -g -fbacktrace -fcheck=all			\
-ffpe-trap=invalid,zero,overflow,underflow,denormal
#
# fortran compile flags
FCFLAGS = $(compile) $(includes) $(options) $(warnings)
F77.FLAGS = -fd-lines-as-comments
F90.FLAGS = -std=f2008 $(debug)
FC.COMPILE = $(FC) $(FCFLAGS)
FC.COMPILE.o = $(FC.COMPILE)  $(output) $(F77.FLAGS)
FC.COMPILE.o.f90 = $(FC.COMPILE) $(output) $(F90.FLAGS)
FC.COMPILE.mod = $(FC.COMPILE) -o $(OBJDIR)/$*.o $(F90.FLAGS)
#
# fortran link flags
FLFLAGS = $(output) $^
FC.LINK = $(FC) $(FLFLAGS)
#
# define subdirectories
OBJDIR := obj
MODDIR := mod
BINDIR := bin
#
# source files
SRC.F77 = $(wildcard *.f)
SRC.F90 = $(wildcard *.f90)
SRC = $(SRC.F77) $(SRC.F90)
#
# objects
OBJS.F77 = $(SRC.F77:.f=.o)
OBJS.F90 = $(SRC.F90:.f90=.o)
OBJS.all = $(OBJS.F77) $(OBJS.F90)
#
# dependencies (non-executables)
MODS. = piksrt_dim moon_calc dates
SUBS. = flmoon caldat
FUNS. = julday
DEPS. = $(MODS.) $(SUBS.) $(FUNS.)

DEPS.o = $(addsuffix .o,$(DEPS.))
OBJS.o = $(filter-out $(DEPS.o),$(OBJS.all))
MODS.mod = $(addsuffix .mod,$(MODS.))

DEPS := $(addprefix $(OBJDIR)/,$(DEPS.o))
OBJS := $(addprefix $(OBJDIR)/,$(OBJS.o))
MODS := $(addprefix $(MODDIR)/,$(MODS.mod))
#
# demo drivers
DEMOS=$(wildcard *.dem.f)
#
# executables
TARGET = badluk.exe
DRIVERS=$(addprefix $(BINDIR)/,$(DEMOS:.dem.f=.exe))
EXES = $(addprefix $(BINDIR)/,$(TARGET)) $(DRIVERS)

all: $(EXES) $(OBJS) $(DEPS) $(MODS)
	@echo "$@ done"
#
# specific recipies
sort=piksr
$(BINDIR)/$(sort)%.exe: $(addprefix $(OBJDIR)/, $(sort)%.dem.o $(sort)%.o $(sort)t_dim.o) | $(BINDIR)
	@echo "compiling pick sort executable $@..."
	$(FC.LINK)

$(BINDIR)/$(TARGET): $(addprefix $(OBJDIR)/, $(TARGET:.exe=.o) $(sort)4_1222.o) $(DEPS) | $(BINDIR)
	@echo "compiling target executable $@..."
	$(FC.LINK)
#
# generic recipies
$(BINDIR)/%.exe: $(OBJDIR)/%.dem.o $(DEPS) | $(BINDIR)
	@echo "\nlinking driver executable $@..."
	$(FC.LINK)
$(OBJDIR)/%.dem.o: %.dem.f %.f $(MODS) | $(OBJDIR)
	@echo "\ncompiling driver object $@..."
	$(FC.COMPILE.o)
$(OBJDIR)/%.o: %.f $(MODS) | $(OBJDIR)
	@echo "\ncompiling generic object $@..."
	$(FC.COMPILE.o)
$(OBJDIR)/%.o: %.f90 $(MODS) | $(OBJDIR)
	@echo "\ncompiling generic f90 object $@..."
	$(FC.COMPILE.o.f90)
$(MODDIR)/%.mod: %.f | $(OBJDIR) $(MODDIR)
	@echo "\ncompiling generic module $@..."
	$(FC.COMPILE.mod)
$(MODDIR)/%.mod: %.f90 | $(OBJDIR) $(MODDIR)
	@echo "\ncompiling generic f90 module $@..."
	$(FC.COMPILE.mod)
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
# recipes without outputs
.PHONY: clean distclean
#
# clean up routines
RM = @rm -vfrd
mostlyclean:
	@echo removing files...
# remove compiled binaries
	$(RM) $(OBJDIR)/*.o
	$(RM) $(OBJDIR)
	$(RM) *.o *.obj
	$(RM) $(MODDIR)/*.mod
	$(RM) $(MODDIR)
	$(RM) *.mod
	$(RM) fort.*
	@echo "$@ done"
clean: mostlyclean
# remove executables
	$(RM) $(TARGET)
	$(RM) $(BINDIR)/*.exe
	$(RM) $(BINDIR)
	$(RM) *.exe
	$(RM) *.out
distclean: clean
# remove Git versions
	$(RM) *.~*~
# remove Emacs backup files
	$(RM) *~ \#*\#
	@echo "$@ done"
#
# test the makefile
test: distclean all
	@echo "$@ done"
#
# run executables
run: $(EXES)
# run executables which do no require user input
	./$(BINDIR)/$(TARGET)
	./$(BINDIR)/caldat.exe
	./$(BINDIR)/piksrt.exe
	@echo "$@ done"
