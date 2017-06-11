CC = g++
CCFLAGS = -Wall -std=c++11 $(shell perl -MExtUtils::Embed -e ccopts) -lstdc++
LD = g++
LDFLAGS = -Wall $(shell perl -MExtUtils::Embed -e ldopts)


ALL = cperl\
			cperl2

CPERLC = cperl.cpp
CPERLEXE = cperl
CPERLOBJS = cperl.o
CPERL2C = cperl2.cpp
WRAPPERC = perlWrapper.cpp
CPERL2EXE = cperl2
CPERL2OBJS = cperl2.o perlWrapper.o
PROGRAMA_PRINCIPALC = Programa_Principal.cpp 
BIBLIOTECAC = biblioteca.cpp
TRABALHO03OBJS = Programa_Principal.o biblioteca.o
TRABALHO03EXEC = Programa_Principal

EXECS = $(CPERLEXE)\
				$(CPERL2EXE)\
				$(TRABALHO03EXEC)

OBJS = $(CPERLOBJS)\
			 $(CPERL2OBJS)\
			 $(TRABALHO03OBJS)

all: $(ALL)

Trabalho03: $(TRABALHO03OBJS)
	$(CC)	$(CCFLAGS)	-c 	$(PROGRAMA_PRINCIPALC)	
	$(CC)	$(CCFLAGS)	-c 	$(BIBLIOTECAC)
	$(LD) $(LFLAGS)	-o 	$@ 	$(TRABALHO03OBJS)

cperl2:
	$(CC)	$(CCFLAGS)	-c 	$(WRAPPERC)	
	$(CC)	$(CCFLAGS)	-c 	$(CPERL2C)
	$(LD)	-L/usr/lib	-o	$(CPERL2EXE)	$(CPERL2OBJS)	$(LDFLAGS)
cperl:
	$(CC)	$(CCFLAGS)	-c 	$(CPERLC)	
	$(LD) -L/usr/lib	-o	$(CPERLEXE)	$(CPERLOBJS)	$(LDFLAGS)

rebuild: clean cperl2
	
clean:
	rm	-f	$(EXECS) $(OBJS)