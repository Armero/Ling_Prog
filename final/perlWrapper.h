#ifndef _PERLWRAPPER_H_
#define _PERLWRAPPER_H_ "perlWrapper.h"

#include <EXTERN.h>
#include <perl.h>
#include <iostream>
#include <fstream>
#include <string>
#include <cstring>
#include "ExcecaoTamanhoPalavra.h"

using namespace std;


enum funcoes {
			PALAVRA = 1,
			PLURAL,
			MAIUSCULO,
			REPETICAO,
			PONTO
		} ;


// Classe que torna transparente o uso da comunicacao entre o c++ e o perl
class PerlWrapper
{
	public:

		// Precisa ser inicializado com uma referencia para o numero de argumentos
		// na entrada, referência para o vetor com os textos de entrada 
		// e a referencia para o ambiente
		PerlWrapper(int *argc, char ***argv, char ***env);
		~PerlWrapper();

		// Arquivo de entrada pode ser diferente de arquvoDeEntrada.txt
		// porem, internamente o programa usa um arquivo de entrada e outro
		// de saida padrao

		// Esses sets e gets servem para informar ao programa em quais arquivos procurar conteudo
		// E em qual arquivo salvar o resultado processado

		// Lanca uma excecao caso a string seja maior que o comprimento maximo permitido
		// Ha possibilidade de alterar os arquivos utilizados para entrada e saida
		// durante o codigo utilizando estes metodos abaixo
		void setArquivoEntrada (const string);
		void getArquivoEntrada () const ;
		void setArquivoSaida (const string);
		void getArquivoSaida () const;


		// Funcoes presente no arquivo ModuloCorretorOrtografico.pm
		void ColocarPontoFinal ();

		// Necessita da palavra repetida a ser 
		// lanca a excecao ExcecaoTamanhoPalavra caso a pavavra colocada na entrada
		// seja maior que o tamanho permitido 
		void SubstituirPalavrasRepetidas (string palavraExterna = "");
		void ColocarLetrasMaiusculas ();
		void CorrecaoDePalavras ();
		void CorrecaoDePlural ();

		// Chama todas as funcoes e realiza a correcao completa sobre o arquivo de entrada
		void CorrecaoCompleta ();

	private:
		//Funcao auxiliar que so sera utilizada dentro da classe
		//copia o arquivo de entrada para o arquivo padrao
		void 			copiarArquivo (const char *, const char *);
		ifstream 	arquivoEntrada;
		ofstream 	arquivoSaida;
		string		nomeEntrada;
		string 		nomeSaida;

		// Tamanho maximo de uma palavra repetida que pode ser tratada
		static const unsigned MAX_TAMANHO_PALAVRA = 100; //para adicionar correcao_
		static const unsigned MAX_TAMANHO_ARQUIVO = 100 + 9;
};

#endif