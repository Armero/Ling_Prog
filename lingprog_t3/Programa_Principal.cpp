#include <iostream>
#include <string>
#include <fstream>
#include "biblioteca.h"
#include <cstdlib>


using namespace std; 

string nomeTexto;
Biblioteca biblioteca(0);

 int menuPrincipal (void) 
{
    int seletor;
    bool valido = false;
  string line;
   system("clear"); 

 while (!valido){
  cout << "Selecione a opção desejada: " <<endl;
  cout << "(1) Adicionar texto a biblioteca" << endl;
  cout << "(2) Exibir textos contidos na biblioteca" << endl;
  cout << "(3) Selecionar texto para exibir informações" << endl;
  cout << "(4) Excluir texto da biblioteca" << endl;
  cout << "(8) Sair" << endl;
  cin >> line;
   try{
   seletor = atoi(line.c_str());

    }
    catch(int erro)
     {  
       cout << "Resposta Inválida, tente novamente com uma das opções abaixo: " << endl;
      }
   if(seletor > 0 && seletor < 9)
   valido = true;
     else
     cout << "Resposta Inválida, tente novamente com uma das opções abaixo: " << endl;
}
  
  if(seletor == 1){
  cout << "Escreva o nome do arquivo que deseja adicionar:" << endl;
  cin >> nomeTexto;
   }
  if(seletor == 3){
  cout << "Escreva o nome do texto que deseja exibir:" << endl;
  cin >> nomeTexto;
   }
 if(seletor == 4){
  cout << "Escreva o nome do texto que deseja excluir:" << endl;
  cin >> nomeTexto;
   }
    
   return seletor;

}

 void inicializar() // Carrega todos os textos armazenados na biblioteca
{
string texto = "listaDeTextos.txt";

ifstream novoTexto (texto.c_str()); 
string line;
  if (novoTexto.is_open())
  {
    
    while (! novoTexto.eof() ) //enquanto end of file for false continua
    {
      
      getline (novoTexto,line); // como foi aberto em modo texto(padrão)
                             //e não binário(ios::bin) pega cada linha

  if(line != "")
    biblioteca.adicionarTexto(line,0);
      
         
   
    }
    novoTexto.close();
    
 
  }
}
 
int main ()
{
int seletor=1;


inicializar();
while(seletor != 8){

seletor = menuPrincipal();
switch (seletor){
    case 1: 
    biblioteca.adicionarTexto(nomeTexto,1);
    break;
    case 2:
    biblioteca.exibirBiblioteca();
    break;
    case 3:
    biblioteca.exibirErros(nomeTexto);
    break;
    case 4:
    biblioteca.excluirTexto(nomeTexto);
    inicializar();
    break;   
    }

}
}