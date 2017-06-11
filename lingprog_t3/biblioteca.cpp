#include <iostream>
#include <fstream>
#include <string>
#include "biblioteca.h" 

using namespace std;

Biblioteca::Biblioteca(int ultimo) : ultimo (0) {};

void Biblioteca::adicionarTexto(string texto, int func)
{
  string line,textoCompleto;

  int seletor=0;
  FILE *arquivo;
 
  
  ifstream novoTexto (texto); 
  if (novoTexto.is_open())
  {
    
    while (! novoTexto.eof() ) //enquanto end of file for false continua
    {
      
      getline (novoTexto,line); // como foi aberto em modo texto(padrão)
                             //e não binário(ios::bin) pega cada linha
	  textoCompleto = textoCompleto + line + "\n";
	 
    }
    novoTexto.close();
    
    if(func == 1)
     {
     arquivo=fopen("listaDeTextos.txt","a");
     fputs(textos[ultimo].c_str() ,arquivo);
     textos[ultimo] = texto;	
     fclose(arquivo);  
     ultimo = ultimo +1; 
     cout << textoCompleto;
     }
    else 
    { 
          
	 textos[ultimo] = texto;
          ultimo = ultimo +1; 
     }
  }

  else
  {
    cout << "O texto " << texto << "  não foi encontrado, o que deseja fazer? " << endl;
    cout << "(1) Escrever novo texto" << endl;  
    cout << "(2) Voltar ao Menu Principal" << endl;  
	cin >> line;
	seletor = atoi(line.c_str());
  
   }
       
   if(seletor == 1)
   {
     cout << "Digite o nome que deseja salvar seu novo texto: " << endl;
	 cin >> textos[ultimo];
        
     cout << "Digite o texto que deseja adicionar: " << endl;     
	 getline(cin,textoCompleto);
         getline(cin,textoCompleto);
	
     try
    { 
     arquivo=fopen(textos[ultimo].c_str(),"a");

     fputs(textoCompleto.c_str(),arquivo);
     fclose(arquivo);  
     arquivo=fopen("listaDeTextos.txt","a");
     fputs(textos[ultimo].c_str() ,arquivo);
     textos[ultimo] = textos[ultimo];

     fclose(arquivo);  
     ultimo = ultimo +1; 

    system("clear");
     
     cout << "Texto adicionado com sucesso! " << endl;
     }
     catch (int e)
    {
     cout << "Falha ao add texto" << "  " << textos[ultimo] << endl; 
     }
   }
   if(seletor == 2)
   return;
   
   if(seletor == 0)
   {
   
      system("clear");
	cout << "Texto adicionado com sucesso! " << endl;
   }
  return;   
}

void Biblioteca::exibirBiblioteca()
{     
 int seletor = -1, j = 0;
string line;
      system("clear");

   cout << "Indice/Nome do Texto" << endl;
   cout << endl;
      for(int i =0; i <= ultimo; i++)
   {
      if(textos[i] != "")
        {
	cout << "(" << j << ")" << " " << textos[i] << endl;
	j++;
        }
     }
   cout << endl;
    cout << "Caso deseje abrir algum texto, digite seu número, caso contrário tecle enter para voltar ao menu" << endl;
      getline(cin,line);
      getline(cin,line);
      if(line != "")
 	seletor = atoi(line.c_str());
     if(seletor > -1)
     exibirErros(textos[seletor]);

}

void Biblioteca::exibirErros(string texto)
{
 string line,textoCompleto;

 system("clear");
 ifstream novoTexto (texto); 
  if (novoTexto.is_open())
  {
    
    while (! novoTexto.eof() ) //enquanto end of file for false continua
    {
      
      getline (novoTexto,line); // como foi aberto em modo texto(padrão)
                             //e não binário(ios::bin) pega cada linha
	  textoCompleto = textoCompleto + line + "\n";
	 
    }
    novoTexto.close();
    cout << textoCompleto << endl;
 
  }
    cout << "Tecle enter para voltar" << endl;
    getline(cin,line);
	getline(cin,line);
    
  
	return;
}

void Biblioteca::excluirTexto(string texto)
{
  int excluido = 0;
  string line;
  FILE *arquivo;

   arquivo=fopen("listaDeTextos.txt","w");
   
  	for(int i = 0; i <= ultimo ; i++)
	{
		if(textos[i] == (texto))
		{
		textos[i] = "";
                excluido = 1;
             
                 }
		else
                {
			if(textos[i] != ""){
    			 fputs(textos[i].c_str() ,arquivo);
			}
		}

	}
 	 fclose(arquivo);  
    if(excluido == 0){
     cout << "Texto não encontrado, tecle enter para voltar ao menu" << endl;
     getline(cin,line);
     getline(cin,line);
      }
    if(excluido == 1){
     cout << "Texto excluído com sucesso! Tecle enter para voltar ao menu!" << endl;
     getline(cin,line);
      getline(cin,line);
     ultimo = 0;
     }
  

}

void Biblioteca::excluirTudo()
{
  ultimo = 0;
 
}
