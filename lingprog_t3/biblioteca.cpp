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

void exibirCorrigido(string texto)
{

string line,textoCompleto;
int tamanho;

  system("clear");
 ifstream novoTexto (texto); 
  if (novoTexto.is_open())
  {
    
    while (! novoTexto.eof() ) 
    {
      
      getline (novoTexto,line); 
                            
	  textoCompleto = textoCompleto + line + "\n";
	 
    }
    novoTexto.close();
    cout << textoCompleto << endl;
 
  }
    tamanho = textoCompleto.size();

    cout << endl;
    cout << "O texto tem " << tamanho << " caracters" << endl;



}

void Biblioteca::exibirErros(string texto)
{
  string line,textoCompleto,saida,palavra;
  int tamanho,seletor;
 bool valido = false;
  int argc;
  char **argv;
  char **env;

  PerlWrapper perl (&argc, &argv, &env);
  perl.setArquivoEntrada(texto);
  saida = "correcao_" + texto;
  perl.setArquivoSaida(saida);

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
    tamanho = textoCompleto.size();

    cout << endl;
    cout << "O texto tem " << tamanho << " caracters" << endl;

while (valido != true)
{
    cout << "Que tipo de correção deseja fazer?" << endl;
    cout << "(1) Correção de plural" << endl;
    cout << "(2) Correção de palavras" << endl;
    cout << "(3) Correção de pontuação" << endl;
    cout << "(4) Colocar sinonimos em repetição" << endl;
    cout << "(5) Correção de letras maiusculas" << endl;
    cout << "(6) Correção completa " << endl;
    cout << "(8) Voltar ao Menu principal" << endl;
    cin >> seletor;
     
    if(seletor > 0 && seletor < 9)
   valido = true;
     else
     cout << "Resposta Inválida, tente novamente com uma das opções abaixo: " << endl;
   
 }

   switch (seletor){
    case 1: 
    perl.CorrecaoDePlural ();
    break;
    case 2:
    perl.CorrecaoDePalavras ();
    break;
    case 3:
    perl.ColocarPontoFinal ();
    break;
    case 4:
    cout << "Qual palavra repetida deseja alterar?" << endl;
    cin >> palavra;
    perl.SubstituirPalavrasRepetidas (palavra);
    break;   
    case 5:
    perl.ColocarLetrasMaiusculas ();
    case 6:
    perl.CorrecaoCompleta ();
    }

  if(seletor == 8)
  return;
  cout << "Texto com a correção selecionada: " << endl;
  exibirCorrigido(saida);

  cout << "Aperte qualquer tecla para voltar ao menu principal" << endl;
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
