# compiler
your_f77 = pgfortran
#export PGI_OBJSUFFIX=o
# compile flags
fcflags =
# link flags
flflags = -c $(fcflags)

all: flmoon.exe julday.exe badluk.exe caldat.exe

flmoon.exe: flmoon.dem.o flmoon.o julday.o caldat.o
	$(your_f77) $(fcflags) $^ -o $@

julday.exe: julday.dem.o julday.o
	$(your_f77) $(fcflags) $^ -o $@

badluk.exe: badluk.o flmoon.o julday.o
	$(your_f77) $(fcflags) $^ -o $@

caldat.exe: caldat.dem.o julday.o caldat.o
	$(your_f77) $(fcflags) $^ -o $@

%.o: %.f	
	 @echo compiling $<...	
	 $(your_f77) $(flflags) $<

clean:
	rm -fv *.o
	rm -fv *.exe
	rm -fv *.out
	rm -fv fort.*
	rm -fv *.dwf
	rm -fv *.pdb

DEPS.o = $(addsuffix .o,$(DEPS.))
OBJS.o = $(filter-out $(DEPS.o),$(OBJS.all))
DEPS := $(addprefix $(OBJDIR)/,$(DEPS.o))
OBJS := $(addprefix $(OBJDIR)/,$(OBJS.o))
#
# demo drivers
DEMOS=$(wildcard *.dem.f)
#
# executables
TARGET = badluk
DRIVERS = $(DEMOS:.dem.f=)
EXES = $(addprefix $(BINDIR)/,$(TARGET) $(DRIVERS))
#
# sub-programs
SUBDIRS :=
#
# recipes
all: $(EXES) $(SUBDIRS)
	@/bin/echo -e "$(THISDIR) $@ done"
$(SUBDIRS):
	@$(MAKE) --no-print-directory -C $@
#
# specific recipes
sort=piksr
$(BINDIR)/$(sort)%: $(addprefix $(OBJDIR)/, $(sort)%.dem.o $(sort)%.o $(sort)t_dim.o) | $(BINDIR)
	@echo "compiling pick sort executable $@..."
	$(FC.LINK)
$(BINDIR)/$(TARGET): $(addprefix $(OBJDIR)/, $(TARGET).o $(sort)4_1222.o) $(DEPS) | $(BINDIR)
	@echo "compiling target executable $@..."
	$(FC.LINK)
#
# generic recipes
$(BINDIR)/%: $(OBJDIR)/%.dem.o $(DEPS) | $(BINDIR)
	@/bin/echo -e "\nlinking driver executable $@..."
	$(FC.LINK)
$(OBJDIR)/%.dem.o: %.dem.f %.f $(MODS) | $(OBJDIR)
	@/bin/echo -e "\ncompiling driver object $@..."
	$(FC.COMPILE.o)
$(OBJDIR)/%.o: %.f $(MODS) | $(OBJDIR)
	@/bin/echo -e "\ncompiling generic object $@..."
	$(FC.COMPILE.o)
$(OBJDIR)/%.o: %.f90 $(MODS) | $(OBJDIR)
	@/bin/echo -e "\ncompiling generic f90 object $@..."
	$(FC.COMPILE.o.f90)
$(MODDIR)/%.mod: %.f | $(MODDIR)
	@/bin/echo -e "\ncompiling generic module $@..."
	$(FC.COMPILE.mod)
$(MODDIR)/%.mod: %.f90 | $(MODDIR)
	@/bin/echo -e "\ncompiling generic f90 module $@..."
	$(FC.COMPILE.mod)
#
# define directory creation
$(BINDIR):
	@echo "making $(BINDIR)..."
	@mkdir -pv $(BINDIR)
$(OBJDIR):
	@echo "making $(OBJDIR)..."
	@mkdir -pv $(OBJDIR)
$(MODDIR):
ifeq ("$(wildcard $(MODS))",)
	@echo "no modules specified"
else
	@echo "making $(MODDIR)..."
	@mkdir -pv $(MODDIR)
endif
#
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
	@/bin/echo -e "\nremoving compiled executable files..."
	$(RM) $(BINDIR)/*
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
	@/bin/echo -e "\nremoving output files..."
	@$(optSUBDIRS)
	@echo "$(THISDIR) $@ done"
realclean: clean out
# remove binaries and outputs
	@$(optSUBDIRS)
distclean: realclean
# remove binaries, outputs, and backups
	@/bin/echo -e "\nremoving backup files..."
# remove Git versions
	$(RM) *.~*~
# remove Emacs backup files
	$(RM) *~ \#*\#
# clean sub-programs
	@$(optSUBDIRS)
	@echo "$(THISDIR) $@ done"
reset: distclean
# remove untracked files
	@/bin/echo -e "\nresetting repository..."
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
	@echo "running executables..."
	$(addsuffix ;, \
  $(addprefix ./$(BINDIR)/, \
	$(TARGET) \
	caldat \
	piksrt ))
	@$(optSUBDIRS)
