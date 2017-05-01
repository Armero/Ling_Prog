package ModuloCorretorOrtografico;

use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();

@EXPORT_OK   = qw(CompararPalavras ColocarLetrasMaiusculas FiltrarPalavra VerificarPrimeiraLetra SubstituirPalavrasRepetidas 
                  ProcurarNomeNosDados ColocarPontoFinal);
%EXPORT_TAGS = ( ALL => [qw(&CompararPalavras &ColocarLetrasMaiusculas &FiltrarPalavra &VerificarPrimeiraLetra &SubstituirPalavrasRepetidas
                        &ProcurarNomeNosDados &ColocarPontoFinal)]);

sub FiltrarPalavra
{
  $_[0] =~ s/[\$#@~!&*()\[\];.,:?^ `\\\/]+//g;
}

#verifica se o nome a é igual ao b
sub CompararPalavras 
{
  if ($_[0] eq $_[1])
  {
    return 1;
  }
  return 0;
}

#Procura no texto os nomes presentes no arquivo "textoCorrigido.txt" e faz com que os mesmos iniciem com letras maiusculas
sub ColocarLetrasMaiusculas
{
  my $nomeArquivo = $_[0];
  my $arquivoBase = "nomes.txt";
  my @palavras = [];
  my $palavraFiltrada = "";
  my $nomeBase = "";
  my $arquivoSaida = $_[1];
  my $novaPalavra = "";
  my $palavraOriginal = "";
  my $achou = 0;
  my $ultimaLetra = "";
  my $vez = 0;

  #abre o arquivo passado pelo usuario, o arquivo padrao com todos os nomes listados e o arquivo de saída
  open (my $conteudoArquivo, "<", $nomeArquivo) or die "Impossivel abrir o conteudo do arquivo: $!";
  open (my $textoBase, "<", $arquivoBase) or die "Impossivel abrir o conteudo do arquivo: $!";
  open (my $textoCorrigido, ">", $arquivoSaida) or die "Impossivel criar o arquivos";
    
  #le as palavras no texto passado para a funcao
  while (<$conteudoArquivo>)
  {
    if ($vez > 0)
    {
      print $textoCorrigido "\n";
    }
    #separa a linha em palavras
    @palavras = split;
    foreach (@palavras)
    {
      $novaPalavra = $_;
      $palavraFiltrada = $_;
      $palavraOriginal = $_;

      #remove caracteres especiais da palavra assim como ',#@' etc que nao caracterizam uma palavra
      FiltrarPalavra ($palavraFiltrada);
      while (<$textoBase>)
      {
        $nomeBase = $_;
        if ($achou == 0)
        {
          #tira os pulas linhas dos nomes no arquivo padrao de nomes
          $nomeBase =~ s/\n//g;
          $achou = CompararPalavras ($nomeBase, $palavraFiltrada);
          if ($achou == 1)
          {
            $novaPalavra = ucfirst ($palavraFiltrada);
          } 
        }

      }

      #obtem a ultima letra da palavra lida para saber se é necessário adicionar alguma pontuação na string filtrada
      $ultimaLetra = substr ($palavraOriginal, -1);
      
      #concatena a palavra corrigida com a pontuacao adequada
      if ( ($ultimaLetra =~ /\W/) && ($achou == 1) )
      { 
        $novaPalavra .= $ultimaLetra;       
      }

      #Escreve no arquivo o texto corrigido
      print $textoCorrigido "$novaPalavra ";
      
      $achou = 0;
      #retorna para o comeco do arquivo
      seek $textoBase, 0, 0;
    }
    $vez = $vez + 1;
  }

  #fecha os arquivos -> nao esquecer isto de forma alguma
  close ($conteudoArquivo);
  close ($textoBase);
  close ($textoCorrigido);
}

sub VerificarPrimeiraLetra
{ 
    if (/^[[:upper:]]/) 
    {
        return 1;
    }
    else {
        return 0;
    }
}

#Procura no texto os nomes presentes no arquivo "textoCorrigido.txt" e faz com que os mesmos iniciem com letras maiusculas
sub SubstituirPalavrasRepetidas
{
  my $nomeArquivo = $_[0];
  my $arquivoBase = "sinonimos.txt";
  my $contador = 0;
  my $palavraFiltrada = "";
  my $nomeBase = "";
  my $arquivoSaida = $_[1];
  my $novaPalavra = "";
  my $palavraOriginal = "";
  my $achouSinonimo = 0;
  my $ultimaLetra = "";
  my @palavras = [];
  my @sinonimos = [];
  my $palavraRepetida = $_[2];
  my $existe = 0;
  my $contadorDeLinhas = 0;
  my $vez = 0;

  use File::Copy;
  copy($nomeArquivo, $arquivoSaida) or die "Impossivel copiar o arquivo: $!";

  #abre o arquivo passado pelo usuario, o arquivo padrao com todos os nomes listados e o arquivo de saída
  open (my $conteudoArquivo, "<", $nomeArquivo) or die "Impossivel abrir o conteudo do arquivo: $!";
  open (my $textoBase, "<", $arquivoBase) or die "Impossivel abrir o conteudo do arquivo: $!";
  open (my $textoCorrigido, ">", $arquivoSaida) or die "Impossivel criar o arquivos";
  
  #verifica se o sinonimo existe na base de dados
  $palavraRepetida = lc $palavraRepetida;
  while (<$textoBase>)
  {
    if ($existe == 0)
    {
      @palavras = split;
      @sinonimos = @palavras;
      foreach (@palavras)
      {
        $nomeBase = $_;
        $nomeBase =~ s/\n//g;
        $existe = $existe + CompararPalavras ($nomeBase, $palavraRepetida);
      }
    }

  }

  #sai da funcao caso o sinonimo nao exista
  if ($existe == 0)
  {
    print "Palavra Desconhecida\n";
    close ($conteudoArquivo);
    close ($textoBase);
    close ($textoCorrigido);
    return;
  }

  #encontra os sinonimos no texto e substitui por um dos sinonimos presentes 
  #no arquivo de texto de forma ciclica
  while (<$conteudoArquivo>)
  {
    @palavras = split;
    if ($vez > 0)
    {
      print $textoCorrigido "\n";
    }
    foreach (@palavras)
    {
      $novaPalavra = $_;
      $palavraOriginal = $_;
      $palavraFiltrada = $_;
      FiltrarPalavra ($palavraFiltrada);
      $palavraFiltrada =~ s/\n//g;
      $achouSinonimo = CompararPalavras ($palavraRepetida, $palavraFiltrada);
      if ($achouSinonimo == 1)
      {
        $novaPalavra = $sinonimos[$contador % 3];
        $contador = $contador + 1;
      }

      #obtem a ultima letra da palavra lida para saber se é necessário adicionar alguma pontuação na string filtrada
      $ultimaLetra = substr ($palavraOriginal, -1);

      #concatena a palavra corrigida com a pontuacao adequada
      if ( ($ultimaLetra =~ /\W/) && ($achouSinonimo == 1) )
      { 
        $novaPalavra .= $ultimaLetra;       
      }

      $achouSinonimo = 0;
      print $textoCorrigido "$novaPalavra ";
    }
    $vez = $vez + 1;
  }


  #fecha os arquivos -> nao esquecer isto de forma alguma
  close ($conteudoArquivo);
  close ($textoBase);
  close ($textoCorrigido);
}

#procura o nome passado no arquivo *.txt padrao do sistema
sub ProcurarNomeNosDados 
{
  my $palavraFornecida = $_[0];
  my $arquivoBase = "nomes.txt";
  my $palavraBase = "";
  my @palavras = [];
  open (my $textoBase, "<", $arquivoBase) or die "Impossivel abrir o conteudo do arquivo: $!";

  $palavraFornecida = lc $palavraFornecida;
  while (<$textoBase>)
  {
    @palavras = split;
    foreach (@palavras)
    {
      $palavraBase = $_;
      $palavraBase =~ s/\n//g;

      if (CompararPalavras($palavraFornecida, $palavraBase ) == 1)
      {
        close ($textoBase);
        return 1;
      }
    }
  }
  close ($textoBase);
  return 0; 
}

#Coloca ponto final em setencas onde a letra de uma palavra esta escrita em maiusculo e esta palavra nao eh um nome
sub ColocarPontoFinal
{
  my $nomeArquivo = $_[0];
  my $contador = 0;
  my $arquivoSaida = $_[1];
  my $novaPalavra = "";
  my @palavras = [];
  my $palavraAnterior = "";
  my $vez = 0;

  use File::Copy;
  copy($nomeArquivo, $arquivoSaida) or die "Impossivel copiar o arquivo: $!";


  #abre o arquivo passado pelo usuario, o arquivo padrao com todos os nomes listados e o arquivo de saída
  open (my $conteudoArquivo, "<", $nomeArquivo) or die "Impossivel abrir o conteudo do arquivo: $!";
  open (my $textoCorrigido, ">", $arquivoSaida) or die "Impossivel criar o arquivos";

  while (<$conteudoArquivo>)
  {
    @palavras = split;
    $contador = 0;
    if ($vez > 0)
    {
      print $textoCorrigido "\n";
    }

    foreach (@palavras)
    {
      #Compara a palavra atual com a anterior. Caso a atual nao seja um nome conhecido e 
      #tenha a sua primeira letra Maiuscula, coloca-se um ponto no final da palavra anterior
      if ( ($contador > 0) && ($contador < scalar @palavras) )
        {
          $palavraAnterior = $novaPalavra;
          $novaPalavra =~ s/\n//g;
          $novaPalavra = $_;
          if ( (substr ($palavraAnterior, -1) ne ".")
            && (VerificarPrimeiraLetra ($novaPalavra) == 1) 
            && (ProcurarNomeNosDados($novaPalavra) == 0) )
          {
            $palavraAnterior .= ".";
          }
          $contador = $contador + 1;
          print $textoCorrigido "$palavraAnterior ";
        }
        elsif ($contador == 0)
        {
          $novaPalavra = $_;
          $novaPalavra =~ s/\n//g;
          $contador = $contador + 1;
        }     
    }
    print $textoCorrigido "$novaPalavra.";
    $vez = $vez + 1;
  }

  #fecha os arquivos -> nao esquecer isto de forma alguma
  close ($conteudoArquivo);
  close ($textoCorrigido);
}