# configure generated Makefile
#
# Makefile for Packmol: Read the comments if you have some
#                       problem while compiling.
#
# You may use the ./configure script to search automatically for
# some fortran compiler.
#
# This make file will try to compile packmol with the default
# fortran compiler, defined by the FC directive. For doing this,
# just type
#
#          make 
#
# The default compilation compiles only the serial version of packmol.
#
# If you want to compile with some specific fortran compiler, or
# to enable the parallel implementation, you must change the line
# below to the path of your fortran compiler. The parallel version
# must be compiled with a compiler compatible with gfortran version 4.2.
#
FORTRAN = /usr/bin/gfortran
#
# Change "AUTO" to the fortran command you want. After changing
# this line, you have two options: compile the parallel version
# of packmol (if the compiler is gfortran >= 4.2 or other openmp
# compatible compiler), or compile the serial version.
# To compile the parallel version type
#
#          make parallel
#
# Change the flags of the compilation if you want:
#
FLAGS= -O3 -ffast-math 
#
# Flags for the compilation of the parallel version
#
OPENMPFLAGS = -fopenmp 
 
###################################################################
#                                                                 #
# Generally no modifications are required after this.             #
#                                                                 #
###################################################################
#
# Get the default fortran compiler
#
 
ifeq ($(FORTRAN),AUTO)
FORTRAN = $(FC)
endif 
#
# Files required
#
oall = cenmass.o \
       gencan.o \
       pgencan.o \
       initial.o \
       io.o \
	 fgcommon.o \
       packmol.o \
       polartocart.o \
       heuristics.o \
       sizes.o \
       usegencan.o \
       molpa.o
oserial = feasy.o geasy.o
oparallel = feasyparallel.o geasyparallel.o compindexes.o
#
# Linking the serial version
#
serial : $(oall) $(oserial)
	@echo " ------------------------------------------------------ " 
	@echo " Compiling packmol with $(FORTRAN) " 
	@echo " Flags: $(FLAGS) " 
	@echo " ------------------------------------------------------ " 
	@$(FORTRAN) -o packmol $(oall) $(oserial) $(FLAGS) 
	@\rm -f *.mod *.o
	@echo " ------------------------------------------------------ " 
	@echo " Packmol succesfully built." 
	@echo " ------------------------------------------------------ " 
#
# Linking the parallel version
#
parallel : $(oall) $(oparallel) ppackmol
	@echo " ------------------------------------------------------ " 
	@echo " Compiling packmol with $(FORTRAN) " 
	@echo " Flags: $(FLAGS) $(OPENMPFLAGS)" 
	@echo " ------------------------------------------------------ "
	@$(FORTRAN) -o packmol $(oall) $(oparallel) $(FLAGS) $(OPENMPFLAGS) 
	@chmod +x ppackmol
	@\rm -f *.mod *.o
	@echo " ------------------------------------------------------ " 
	@echo " Packmol succesfully built. Paralell version available. " 
	@echo " ------------------------------------------------------ " 
#
# Compiling with flags for development
#
devel : $(oall) $(oserial)
	@echo " ------------------------------------------------------ " 
	@echo " Compiling packmol with $(FORTRAN) " 
	@echo " Flags: -Wunused"
	@echo " ------------------------------------------------------ "
	@$(FORTRAN) -o packmol $(oall) $(oserial) -Wunused 
	@echo " ------------------------------------------------------ " 
	@echo " Packmol succesfully built. " 
	@echo " ------------------------------------------------------ " 
#
# Modules
#
modules = sizes.o molpa.o usegencan.o
sizes.o : sizes.f90 
	@$(FORTRAN) $(FLAGS) -c sizes.f90
molpa.o : molpa.f90 sizes.o
	@$(FORTRAN) $(FLAGS) -c molpa.f90
usegencan.o : usegencan.f90 
	@$(FORTRAN) $(FLAGS) -c usegencan.f90
#
# Code compiled only for all versions
#
cenmass.o : cenmass.f90 $(modules)
	@$(FORTRAN) $(FLAGS) -c cenmass.f90
initial.o : initial.f90 $(modules)
	@$(FORTRAN) $(FLAGS) -c initial.f90
io.o : io.f90  $(modules)
	@$(FORTRAN) $(FLAGS) -c io.f90
fgcommon.o : fgcommon.f90 $(modules)
	@$(FORTRAN) $(FLAGS) -c fgcommon.f90
packmol.o : packmol.f90 $(modules)
	@$(FORTRAN) $(FLAGS) -c packmol.f90
polartocart.o : polartocart.f90 $(modules)   
	@$(FORTRAN) $(FLAGS) -c polartocart.f90
heuristics.o : heuristics.f90 $(modules)   
	@$(FORTRAN) $(FLAGS) -c heuristics.f90
pgencan.o : pgencan.f90 $(modules)
	@$(FORTRAN) $(FLAGS) -c pgencan.f90
gencan.o : gencan.f
	@$(FORTRAN) $(FLAGS) -c gencan.f 
# Compiled for serial version only
feasy.o : feasy.f90 $(modules)   
	@$(FORTRAN) $(FLAGS) -c feasy.f90
geasy.o : geasy.f90 $(modules)   
	@$(FORTRAN) $(FLAGS) -c geasy.f90
#
# Compiled for parallel version only
#
feasyparallel.o : feasyparallel.f90 $(modules)   
	@$(FORTRAN) $(FLAGS) $(OPENMPFLAGS) -c feasyparallel.f90
geasyparallel.o : geasyparallel.f90 $(modules)   
	@$(FORTRAN) $(FLAGS) $(OPENMPFLAGS) -c geasyparallel.f90
compindexes.o : compindexes.f90 $(modules)   
	@$(FORTRAN) $(FLAGS) $(OPENMPFLAGS) -c compindexes.f90
#
# Clean build files
#
clean: 
	@\rm -f ./*.o ./*.mod 
