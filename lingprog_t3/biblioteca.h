#include <iostream>
#include <string>
using namespace std; 


class Biblioteca {
    public:
        Biblioteca(int ultimo);
        void adicionarTexto(string,int);
        void exibirBiblioteca();
        void exibirErros(string);
	    void excluirTexto(string);
	    void excluirTudo();

    private: 
        string textos[100];
        string nomeTexto;
        int ultimo;
};
