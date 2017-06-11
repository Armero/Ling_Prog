#include "perlWrapper.h"

int
main (int argc, char *argv[], char **env)
{
	PerlWrapper perl (&argc, &argv, &env);
  perl.setArquivoEntrada("teste.txt");
  perl.setArquivoSaida("testeSaida.txt");
  // perl.ColocarLetrasMaiusculas();
  // try
  // {
  // 	perl.SubstituirPalavrasRepetidas();
  // }
  // catch (ExcecaoTamanhoPalavra e)
  // {
  // 	cout << e.what();
  // }
  // perl.ColocarPontoFinal();

  try
  {
  	perl.CorrecaoCompleta();
  }
  catch (ExcecaoTamanhoPalavra e)
  {
  	cout << e.what();
  }
  
	return (0);
}