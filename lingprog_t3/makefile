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

EXECS = $(CPERLEXE)\
				$(CPERL2EXE)

OBJS = $(CPERLOBJS)\
			 $(CPERL2OBJS)

all: $(ALL)


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