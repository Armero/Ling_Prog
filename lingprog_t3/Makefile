CC = g++
LD = g++

CFLAGS = -Wall
LFLAGS = -Wall

TRABALHO03OBJS = Programa_Principal.o biblioteca.o biblioteca.h

.cpp.o:
	$(CC) $(CFLAGS) -c $<

TRABALHO = Trabalho03
all: $(TRABALHO)

Trabalho03: $(TRABALHO03OBJS)
	$(LD) $(LFLAGS) -o $@ $(TRABALHO03OBJS) -lm

clean:
	rm -f *.o $(EXEMPLOS)