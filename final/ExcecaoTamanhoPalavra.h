#ifndef _EXCECAOTAMANHOPALAVRA_H
#define _EXCECAOTAMANHOPALAVRA_H "ExcecaoTamanhoPalavra.h"
#include <exception>

using namespace std;

class ExcecaoTamanhoPalavra : public exception
{
	public:
		ExcecaoTamanhoPalavra  () : exception() {}
		virtual const char * what () const throw()
		{ return "texto excede o tamanho maximo permitido na entrada da funcao\n"; }
};

#endif