THISDIR=$(shell \pwd | sed 's%^.*/%%')

# fortran compiler
FC = gfortran
#
# general flags
compile = -c $<
output = -o $@
#
# options
options = -fimplicit-none
warnings = -W -Wall -Warray-temporaries -Wcharacter-truncation -Wfatal-errors \
-Wimplicit-interface -Wintrinsics-std -Wsurprising -Wuninitialized -pedantic
debug = -g -fbacktrace -ffpe-trap=invalid,zero,overflow,underflow,denormal
#
# additional options for gfortran v4.5 and later
options_new = -std=f2018
warnings_new = -Wconversion-extra -Wimplicit-procedure -Winteger-division -Wreal-q-constant \
-Wrealloc-lhs-all -Wuse-without-only
debug_new = -fcheck=all
#
# concatenate options
options := $(options) $(options_new)
warnings := $(warnings) $(warnings_new)
debug := $(debug) $(debug_new)
#
# fortran compiler flags
FCFLAGS = $(includes) $(options) $(warnings) $(debug)
F77.FLAGS = -fd-lines-as-comments -std=legacy
F90.FLAGS =
FC.COMPILE = $(FC) $(FCFLAGS) $(compile)
FC.COMPILE.o = $(FC.COMPILE) $(output) $(F77.FLAGS)
FC.COMPILE.o.f90 = $(FC.COMPILE) $(output) $(F90.FLAGS)
FC.COMPILE.mod = $(FC.COMPILE) -o $(OBJDIR)/$*.o $(F90.FLAGS)
#
# fortran linker flags
FLFLAGS = $(output) $^
FC.LINK = $(FC) $(FLFLAGS)
#
# define build directories
BINDIR := bin
MODDIR := mod
OBJDIR := obj
#
# define source directories
SRCDIR := src
INCDIR := includes
FUNDIR := functions
MODDIR.in := modules
SUBDIR := subroutines
#
# source files - programs (executable)
SRC.F77 = $(wildcard *.f)
SRC.F90 = $(wildcard *.f90)
# add SRCDIR if present
ifneq ("$(strip $(wildcard $(SRCDIR)))","")
	VPATH += $(subst $(subst ,, ),:,$(strip $(SRCDIR)))
	SRC.F77 += $(wildcard $(SRCDIR)/*.f)
	SRC.F90 += $(wildcard $(SRCDIR)/*.f90)
endif
SRC = $(SRC.F77) $(SRC.F90)
#
# "include" files (not executable, not compilable)
# add INCDIR if present
ifneq ("$(strip $(wildcard $(INCDIR)))","")
	VPATH += $(subst $(subst ,, ),:,$(strip $(INCDIR)))
	includes = $(patsubst %,-I %,$(INCDIR))
	INCS.F77 = $(wildcard $(INCDIR)/*.f)
	INCS.F90 = $(wildcard $(INCDIR)/*.f90)
	INCS. +=  $(patsubst $(INCDIR)/%.f, %, $(INCS.F77)) \
	$(patsubst $(INCDIR)/%.f90, %, $(INCS.F90))
endif
#
# function files
# add FUNDIR if present
ifneq ("$(strip $(wildcard $(FUNDIR)))","")
	VPATH += $(subst $(subst ,, ),:,$(strip $(FUNDIR)))
	FUNS.F77 = $(wildcard $(FUNDIR)/*.f)
	FUNS.F90 = $(wildcard $(FUNDIR)/*.f90)
	FUNS. +=  $(patsubst $(FUNDIR)/%.f, %, $(FUNS.F77)) \
	$(patsubst $(FUNDIR)/%.f90, %, $(FUNS.F90))
endif
#
# module files
# add MODDIR.in if present
ifneq ("$(strip $(wildcard $(MODDIR.in)))","")
	VPATH += $(subst $(subst ,, ),:,$(strip $(MODDIR.in)))
	MODS.F77 = $(wildcard $(MODDIR.in)/*.f)
	MODS.F90 = $(wildcard $(MODDIR.in)/*.f90)
	MODS. +=  $(patsubst $(MODDIR.in)/%.f, %, $(MODS.F77)) \
	$(patsubst $(MODDIR.in)/%.f90, %, $(MODS.F90))
endif
#
# subroutine files
# add SUBDIR if present
ifneq ("$(strip $(wildcard $(SUBDIR)))","")
	VPATH += $(subst $(subst ,, ),:,$(strip $(SUBDIR)))
	SUBS.F77 = $(wildcard $(SUBDIR)/*.f)
	SUBS.F90 = $(wildcard $(SUBDIR)/*.f90)
	SUBS. +=  $(patsubst $(SUBDIR)/%.f, %, $(SUBS.F77)) \
	$(patsubst $(SUBDIR)/%.f90, %, $(SUBS.F90))
endif
#
# objects
OBJS.F77 = $(SRC.F77:.f=.o)
OBJS.F90 = $(SRC.F90:.f90=.o)
OBJS.all = $(OBJS.F77) $(OBJS.F90)
OBJS.all := $(OBJS.all:$(SRCDIR)/%=%)
#
# dependencies (non-executables)
MODS. += piksrt_dim moon_calc dates
SUBS. += flmoon caldat
FUNS. += julday
DEPS. = $(MODS.) $(SUBS.) $(FUNS.)

# add MODDIR to includes if MODS. not empty
ifneq ("$(MODS.)","")
	includes:=$(includes) -J $(MODDIR)
endif

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
DRIVERS = $(DEMOS:.dem.f=.exe)
EXES = $(addprefix $(BINDIR)/,$(TARGET) $(DRIVERS))
#
# sub-programs
SUBDIRS :=
#
# recipes
all: $(EXES) $(SUBDIRS)
	@echo "\n$(THISDIR) $@ done"
$(SUBDIRS):
	@$(MAKE) --no-print-directory -C $@
#
# specific recipes
sort=piksr
$(BINDIR)/$(sort)%.exe: $(addprefix $(OBJDIR)/, $(sort)%.dem.o $(sort)%.o $(sort)t_dim.o) | $(BINDIR)
	@echo "compiling pick sort executable $@..."
	$(FC.LINK)
$(BINDIR)/$(TARGET): $(addprefix $(OBJDIR)/, $(TARGET:.exe=.o) $(sort)4_1222.o) $(DEPS) | $(BINDIR)
	@echo "compiling target executable $@..."
	$(FC.LINK)
#
# generic recipes
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
$(MODDIR)/%.mod: %.f | $(MODDIR)
	@echo "\ncompiling generic module $@..."
	$(FC.COMPILE.mod)
$(MODDIR)/%.mod: %.f90 | $(MODDIR)
	@echo "\ncompiling generic f90 module $@..."
	$(FC.COMPILE.mod)
#
# define directory creation
$(BINDIR):
	@mkdir -v $(BINDIR)
$(OBJDIR):
	@mkdir -v $(OBJDIR)
$(MODDIR):
ifeq ("$(wildcard $(MODS))",)
	@echo "no modules specified"
else
	@echo "creating $(MODDIR)..."
	@mkdir -v $(MODDIR)
endif

# keep intermediate object files
.SECONDARY: $(DEPS) $(OBJS) $(MODS)
#
# recipes without outputs
.PHONY: all $(SUBDIRS) mostlyclean clean force out realclean distclean reset
#
# clean up
optSUBDIRS = $(addprefix $(MAKE) $@ --no-print-directory -C ,$(addsuffix ;,$(SUBDIRS)))
RM = @rm -vfrd
mostlyclean:
# remove compiled binaries
	@echo "removing compiled binary files..."
	$(RM) $(OBJDIR)/*.o
	$(RM) $(OBJDIR)
	$(RM) *.o *.obj
	$(RM) $(MODDIR)/*.mod
	$(RM) $(MODDIR)
	$(RM) *.mod
	$(RM) fort.*
	@$(optSUBDIRS)
	@echo "$(THISDIR) $@ done"
clean: mostlyclean
# remove binaries and executables
	@echo "\nremoving compiled executable files..."
	$(RM) $(BINDIR)/*.exe
	$(RM) $(BINDIR)
	$(RM) *.exe
	$(RM) *.out
	@$(optSUBDIRS)
	@echo "$(THISDIR) $@ done"
force: clean
# force re-make
	@$(MAKE) --no-print-directory
out:
# remove outputs produced by executables
	@echo "\nremoving output files..."
	@$(optSUBDIRS)
	@echo "$(THISDIR) $@ done"
realclean: clean out
# remove binaries and outputs
	@$(optSUBDIRS)
distclean: realclean
# remove binaries, outputs, and backups
	@echo "\nremoving backup files..."
# remove Git versions
	$(RM) *.~*~
# remove Emacs backup files
	$(RM) *~ \#*\#
# clean sub-programs
	@$(optSUBDIRS)
	@echo "$(THISDIR) $@ done"
reset: distclean
# remove untracked files
	@echo "\nresetting repository..."
	git reset HEAD
	git stash
	git clean -f
	@$(optSUBDIRS)
	@echo "$(THISDIR) $@ done"
#
# test the makefile
test: distclean all
	@echo "$(THISDIR) $@ done"
#
# run executables
run: all
# run executables which do no require user input
	$(addprefix ./$(BINDIR)/, \
	$(TARGET) \
	$(addsuffix .exe;,\
	caldat \
	piksrt ))
	@$(optSUBDIRS)
