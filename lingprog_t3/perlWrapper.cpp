#include "perlWrapper.h"

static PerlInterpreter *my_perl;
PerlWrapper::PerlWrapper (int *argc, char ***argv, char ***env)
{
	PERL_SYS_INIT3(argc, argv, env);
	my_perl = perl_alloc();
	perl_construct(my_perl);
	PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
	setArquivoEntrada ("arquivoDeEntrada.txt");
	setArquivoSaida ("SaidaCorrigida.txt");
}

PerlWrapper::~PerlWrapper ()
{
	perl_destruct(my_perl);
	perl_free(my_perl);
	PERL_SYS_TERM();
	arquivoEntrada.close();
	arquivoSaida.close();
	copiarArquivo("SaidaCorrigida.txt", nomeSaida.c_str());
}

void PerlWrapper::setArquivoEntrada (const string nomeArquivo)
{
	if (arquivoEntrada.is_open())
		arquivoEntrada.close ();
	

	if (nomeArquivo.length() > MAX_TAMANHO_PALAVRA)
	{
		throw ExcecaoTamanhoPalavra();
	}
	copiarArquivo(nomeArquivo.c_str(), "arquivoDeEntrada.txt");
	arquivoEntrada.open(nomeArquivo.c_str());	
	nomeEntrada = nomeArquivo;
}		

void PerlWrapper::getArquivoEntrada () const
{
	cout << nomeEntrada;
}

void PerlWrapper::setArquivoSaida (const string nomeArquivo)
{
	if (arquivoSaida.is_open())
		arquivoSaida.close();

	if (nomeArquivo.length() > MAX_TAMANHO_PALAVRA)
	{
		throw ExcecaoTamanhoPalavra();
	}
	arquivoSaida.open(nomeArquivo.c_str());	
	nomeSaida = nomeArquivo;
}

void PerlWrapper::getArquivoSaida () const
{
	cout << nomeSaida;
}

void PerlWrapper::ColocarPontoFinal ()
{
	char *my_argv[] = {(char *)"", (char *) "perlMain.pl"};
	perl_parse(my_perl, NULL, 0, my_argv, (char **)NULL);
	perl_run(my_perl);

	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK (SP);
	XPUSHs(sv_2mortal(newSViv(PONTO)));
	PUTBACK;
	call_pv("principal", G_SCALAR);
	SPAGAIN;

	PUTBACK;
	FREETMPS;
	LEAVE;
}

void PerlWrapper::SubstituirPalavrasRepetidas (string palavraExterna)
{
	char *my_argv[] = {(char *)"", (char *) "perlMain.pl"};
	perl_parse(my_perl, NULL, 0, my_argv, (char **)NULL);
	perl_run(my_perl);
	char palavra[MAX_TAMANHO_PALAVRA];

	if (palavraExterna == "")
	{
			cout << "Digite a Palavra Repetida" <<endl;
			cin >> palavra;
	}
	else
	{
		strcpy(palavra, palavraExterna.c_str());
	}

	if (strlen(palavra) > MAX_TAMANHO_PALAVRA)
	{
		throw ExcecaoTamanhoPalavra();
	}

	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK (SP);
	XPUSHs(sv_2mortal(newSViv(REPETICAO)));
	XPUSHs(sv_2mortal(newSVpv(palavra, strlen(palavra))));
	PUTBACK;
	call_pv("principal", G_SCALAR);
	SPAGAIN;

	PUTBACK;
	FREETMPS;
	LEAVE;
}

void PerlWrapper::ColocarLetrasMaiusculas ()
{
	char *my_argv[] = {(char *)"", (char *) "perlMain.pl"};
	perl_parse(my_perl, NULL, 0, my_argv, (char **)NULL);
	perl_run(my_perl);

	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK (SP);
	XPUSHs(sv_2mortal(newSViv(MAIUSCULO)));
	PUTBACK;
	call_pv("principal", G_SCALAR);
	SPAGAIN;

	PUTBACK;
	FREETMPS;
	LEAVE;
}

void PerlWrapper::CorrecaoDePalavras ()
{
	char *my_argv[] = {(char *)"", (char *) "perlMain.pl"};
	perl_parse(my_perl, NULL, 0, my_argv, (char **)NULL);
	perl_run(my_perl);

	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK (SP);
	XPUSHs(sv_2mortal(newSViv(PALAVRA)));
	PUTBACK;
	call_pv("principal", G_SCALAR);
	SPAGAIN;

	PUTBACK;
	FREETMPS;
	LEAVE;
}

void PerlWrapper::CorrecaoDePlural ()
{
	char *my_argv[] = {(char *)"", (char *) "perlMain.pl"};
	perl_parse(my_perl, NULL, 0, my_argv, (char **)NULL);
	perl_run(my_perl);

	dSP;
	ENTER;
	SAVETMPS;
	PUSHMARK (SP);
	XPUSHs(sv_2mortal(newSViv(PLURAL)));
	PUTBACK;
	call_pv("principal", G_SCALAR);
	SPAGAIN;

	PUTBACK;
	FREETMPS;
	LEAVE;
}

void PerlWrapper::CorrecaoCompleta ()
{
	SubstituirPalavrasRepetidas();
	ColocarLetrasMaiusculas ();
	CorrecaoDePalavras ();
	CorrecaoDePlural ();
	ColocarPontoFinal ();
}


void PerlWrapper::copiarArquivo( const char* srce_file, const char* dest_file )
{
    std::ifstream srce( srce_file, std::ios::binary ) ;
    std::ofstream dest( dest_file, std::ios::binary ) ;
    dest << srce.rdbuf() ;
}