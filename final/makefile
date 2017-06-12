CC = g++
CCFLAGS = -Wall -std=c++11 $(shell perl -MExtUtils::Embed -e ccopts) -lstdc++
LD = g++
LDFLAGS = -Wall $(shell perl -MExtUtils::Embed -e ldopts)


ALL = cperl\
			cperl2

WRAPPERC = perlWrapper.cpp
PROGRAMA_PRINCIPALC = Programa_Principal.cpp 
BIBLIOTECAC = biblioteca.cpp
TRABALHO03OBJS = Programa_Principal.o perlWrapper.o biblioteca.o 
TRABALHO03EXEC = corretor

EXECS = $(TRABALHO03EXEC)

OBJS =  $(TRABALHO03OBJS)

all: $(ALL)

trabalho03:
	$(CC)	$(CCFLAGS)	-c 	$(WRAPPERC)
	$(CC)	$(CCFLAGS)	-c 	$(BIBLIOTECAC)	
	$(CC)	$(CCFLAGS)	-c 	$(PROGRAMA_PRINCIPALC)
	$(LD)	-L/usr/lib	-o	$(TRABALHO03EXEC)	$(TRABALHO03OBJS)	$(LDFLAGS)

install: trabalho03

rebuild: clean trabalho03
	
clean:
	rm	-f	$(EXECS) $(OBJS)