#include <EXTERN.h>
#include <perl.h>
#include <string.h>
/*#include <iostream*/
//#include <iostream>
//#include <cstdio>

PerlInterpreter *my_perl;

int Sum (int a, int b)
{
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK (SP);
	XPUSHs(sv_2mortal(newSViv(a)));
	XPUSHs(sv_2mortal(newSViv(b)));
	PUTBACK;
	call_pv("soma", G_SCALAR);
	SPAGAIN;

	int resultado = POPi;
	PUTBACK;
	FREETMPS;
	LEAVE;
	return resultado;
}

void prt (char * texto)
{
	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK (SP);
	XPUSHs(sv_2mortal(newSVpv(texto, strlen(texto))));
	PUTBACK;
	call_pv("printar", G_SCALAR);
	SPAGAIN;

	int resultado = POPi;
	PUTBACK;
	FREETMPS;
	LEAVE;
}
int
main (int argc, char *argv[], char **env)
{

	char *my_argv[] = {"", "testPerl.pl"};
	PERL_SYS_INIT3(&argc, &argv, &env);
	
	my_perl = perl_alloc();
	perl_construct(my_perl);
	PL_exit_flags |= PERL_EXIT_DESTRUCT_END;

/*	int perl_argc = 3;
	char * code = "print scalar (localtime).\"\\n\"";
	char *perl_argv [] = {argv[0], "-e", code};*/
	perl_parse(my_perl, NULL, 2, my_argv, (char **)NULL);
	perl_run(my_perl);

	//cout << "Resultado: " << sum (3, 4) << endl;
	//printf("Resultado: %d\n", Sum(3,4));
	prt("Ola, meu nome eh goku!");

	perl_destruct(my_perl);
	perl_free(my_perl);

	PERL_SYS_TERM();
	return (0);
}