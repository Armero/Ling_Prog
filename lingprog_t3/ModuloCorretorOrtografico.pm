package ModuloCorretorOrtografico;

use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();

@EXPORT_OK   = qw(CompararPalavras ColocarLetrasMaiusculas FiltrarPalavra VerificarPrimeiraLetra SubstituirPalavrasRepetidas 
                  ProcurarNomeNosDados ColocarPontoFinal CorrecaoDePalavras CorrecaoDePlural CorretorCompleto);
%EXPORT_TAGS = ( ALL => [qw(&CompararPalavras &ColocarLetrasMaiusculas &FiltrarPalavra &VerificarPrimeiraLetra &SubstituirPalavrasRepetidas
                        &ProcurarNomeNosDados &ColocarPontoFinal &CorrecaoDePalavras &CorrecaoDePlural &CorretorCompleto)]);

#remove todos os caracteres especiais de uma palavra
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
sub ColocarLetrasMaiusculas
{
  my $nomeArquivo = "arquivoDeEntrada.txt";
  my $arquivoBase = "nomes.txt";
  my @palavras = [];
  my $palavraFiltrada = "";
  my $nomeBase = "";
  my $arquivoSaida = "SaidaCorrigida.txt";
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
            $novaPalavra = ucfirst ($palavraOriginal);
          } 
        }

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

#Procura no texto os nomes presentes no arquivo "textoCorrigido.txt" e faz com que os mesmos iniciem com letras maiusculas
sub SubstituirPalavrasRepetidas
{
  my $nomeArquivo = "arquivoDeEntrada.txt";
  my $arquivoBase = "sinonimos.txt";
  my $contador = 0;
  my $palavraFiltrada = "";
  my $nomeBase = "";
  my $arquivoSaida = "SaidaCorrigida.txt";
  my $novaPalavra = "";
  my $palavraOriginal = "";
  my $achouSinonimo = 0;
  my $ultimaLetra = "";
  my @palavras = [];
  my @sinonimos = [];
  my $palavraRepetida = $_[0];
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


#Coloca ponto final em setencas onde a letra de uma palavra esta escrita em maiusculo e esta palavra nao eh um nome
sub ColocarPontoFinal
{
  my $nomeArquivo = "arquivoDeEntrada.txt";
  my $contador = 0;
  my $arquivoSaida = "SaidaCorrigida.txt";
  my $novaPalavra = "";
  my @palavras = [];
  my $palavraAnterior = "";
  my $vez = 0;
  my $ultimaPalavra = "";

  use File::Copy;
  copy($nomeArquivo, $arquivoSaida) or die "Impossivel copiar o arquivo: $!";
  

  #abre o arquivo passado pelo usuario, o arquivo padrao com todos os nomes listados e o arquivo de saída
  open (my $conteudoArquivo, "<", $nomeArquivo) or die "Impossivel abrir o conteudo do arquivo: $!";
  open (my $textoCorrigido, ">", $arquivoSaida) or die "Impossivel criar o arquivos";

  while (<$conteudoArquivo>)
  {
    @palavras = split;
    $contador = 0;

    foreach (@palavras)
    {
      #Colocar a ultima palavra lida na linah anterior e a pontua caso seja necessario
      if ( ($vez >= 1) && ($contador == 0) )
      {
        if ( (VerificarPrimeiraLetra($_) == 1) 
          && (substr($ultimaPalavra, - 1) ne ".")
          && (substr($ultimaPalavra, - 1) ne "?")
          && (substr($ultimaPalavra, - 1) ne "!"))
        {
          print $textoCorrigido "$ultimaPalavra.\n";
        }
        else
        {
          print $textoCorrigido "$ultimaPalavra\n";
        }
      }
      #Compara a palavra atual com a anterior. Caso a atual nao seja um nome conhecido e 
      #tenha a sua primeira letra Maiuscula, coloca-se um ponto no final da palavra anterior
      if ( ($contador > 0) && ($contador < scalar @palavras) )
        {
          $palavraAnterior = $novaPalavra;
          $novaPalavra =~ s/\n//g;
          $novaPalavra = $_;
          if ( (substr ($palavraAnterior, -1) ne ".")
            && (substr ($palavraAnterior, -1) ne "?") 
            && (substr ($palavraAnterior, -1) ne "!") 
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
    $ultimaPalavra = $novaPalavra;
    $vez = $vez + 1;
  }

  #Pontua a ultima palavra do texto
  if ( (substr ($novaPalavra, -1) ne ".")
    && (substr ($novaPalavra, -1) ne "?")
    && (substr ($novaPalavra, -1) ne "!") )
  {
    print $textoCorrigido "$novaPalavra.";
  }
  else
  {
    print $textoCorrigido "$novaPalavra";
  }

  #fecha os arquivos -> nao esquecer isto de forma alguma
  close ($conteudoArquivo);
  close ($textoCorrigido);
}

sub CorrecaoDePalavras
{
  my @listaDeErro;
  my $indice=0;
  my $count=0;
  my $listaDePalavras = 'listaDePalavras.txt';
  my $arqDeEntrada = 'arquivoDeEntrada.txt';
  my @palavrasDeEntrada;
  my @todasAsPalavras;
  my @novaLinha;
  my $textoDeSaida = '';
  my $arquivoDeSaida = 'saida.txt';
  my $ultimaLetra = "";
  my $palavraOriginal = "";
  my $achou = 0;

 if (open(my $fh, "<", $listaDePalavras)) {
    while (my $row = <$fh>) {
      chomp $row;
      $listaDeErro[$indice] = $row;
      $indice = $indice+1;
    }
    close $fh;
  } else {
    warn "Não foi possível abrir o arquivo '$listaDePalavras' $!"; 
  }
  
  $indice = 0;
  if (open(my $fh, "<", $arqDeEntrada)) {
    while (my $row = <$fh>) {
      $palavrasDeEntrada[$indice] = $row;
      $indice = $indice+1;
    }
    close $fh;
  } else {
    warn "Não foi possível abrir o arquivo '$arqDeEntrada' $!"; 
  }

 for(my $i = 0; $i < @palavrasDeEntrada.length; $i++)
 {
    @novaLinha = split(/ /,$palavrasDeEntrada[$i]);
    push @todasAsPalavras, @novaLinha;
   }
  $indice = 0;
  
  foreach my $palavra (@todasAsPalavras)
  {
   $count = 0;
   $ultimaLetra = substr($palavra, -1);
   $palavraOriginal = $palavra; 
   foreach my $erro (@listaDeErro)
   { 
     FiltrarPalavra($palavra);
     $erro =~ s/\n//g;
     $erro =~ s/\s+$//;
      if($palavra eq $erro)
      { 
        $achou = 1;
        if($count < 5){
          $todasAsPalavras[$indice] = 'você';
        }
        elsif($count < 10)
        {
          $todasAsPalavras[$indice] = 'também';
        }
        elsif($count < 15)
        {
          $todasAsPalavras[$indice] = 'porque';
        }
      } 
      $count = $count +1;  
   }
   
   $achou = 0;
   if ($achou == 0)
   {
    $todasAsPalavras[$indice] = $palavraOriginal;
   }
   $indice = $indice +1;
  }

  
  $textoDeSaida = $todasAsPalavras[0];
  $indice = 1;
  
  foreach (@todasAsPalavras)
  {
     $textoDeSaida = $textoDeSaida . ' ' . $todasAsPalavras[$indice]; 
     $indice = $indice+1;
  }
  open ( my $fh,'>', 'SaidaCorrigida.txt');
  print $fh  $textoDeSaida;
  close $fh;
}

sub CorrecaoDePlural
{
  my @plurais;
  my $arqDeEntrada = 'arquivoDeEntrada.txt';
  my $listaDePlural = 'listaDePlural.txt';
  my @palavrasDeEntrada;
  my @todasAsPalavras;
  my @novaLinha;
  my $textoDeSaida = '';
  my $arquivoDeSaida = 'saida.txt';
  my $aux = 0;
  my $atual = 0;
  my $palavraNoPlural = 0;
  my $procura =0;
  my $indice = 0;
  my $palavraTemporaria = "";
  my $ultimaLetra = "";

  if (open(my $fh, "<", $listaDePlural)) {
    while (my $row = <$fh>) {
      chomp $row;
      $plurais[$indice] = $row;
      $indice = $indice+1;
    }
    close $fh;
  } else {
    warn "Não foi possível abrir o arquivo '$listaDePlural' $!";
  }
  
  $indice = 0;
  if (open(my $fh, "<", $arqDeEntrada)) {
    while (my $row = <$fh>) {
      $palavrasDeEntrada[$indice] = $row;
      $indice = $indice+1;
    }
    close $fh;
  } else {
    warn "Não foi possível abrir o arquivo '$arqDeEntrada' $!";
  }


 for(my $i = 0; $i < @palavrasDeEntrada.length; $i++)
 {
    @novaLinha = split(/ /,$palavrasDeEntrada[$i]);
    push @todasAsPalavras, @novaLinha;
   }

  $indice = 0;
  foreach my $palavra (@todasAsPalavras)
  {
    $ultimaLetra = substr ($palavra, -1);
    $palavraNoPlural = 0;
    $atual = 0;
    $procura = 0;
    while($palavraNoPlural == 0 && $atual >= 0) {
    $atual =  index $palavra, 's',$procura;
    $aux =  length $palavra;
    $aux = $aux-1;
    if($atual == $aux)
    {
    $palavraNoPlural = 1;
    }
    elsif($atual >= 0)
    {
    $procura = $atual +1;
    }  
   }
    if($palavraNoPlural == 1)
    {
      foreach my $aCorrigir (@plurais)
      {
        $palavraTemporaria = $todasAsPalavras[$indice + 1];
        FiltrarPalavra($palavraTemporaria);
        $aCorrigir =~ s/\n//g;
        $aCorrigir =~ s/\s+$//;
     
        if($todasAsPalavras[$indice +1] eq $aCorrigir)
        {
          if($todasAsPalavras[$indice] eq 'nos'){
            if($palavraNoPlural == 1)
             {
              $todasAsPalavras[$indice+1] = 'vamos';
             }
            elsif($palavraNoPlural == 2){
              $todasAsPalavras[$indice+1] = 'cantávamos';
                }
             elsif($palavraNoPlural == 3){
             $todasAsPalavras[$indice+1] = 'estavámos';
               } elsif($palavraNoPlural == 4){
             $todasAsPalavras[$indice+1] = 'fazíamos';
              }
            } 
        else
        {
          if($palavraNoPlural == 1)
          {
            $todasAsPalavras[$indice+1] = 'vão';
          }
          elsif($palavraNoPlural == 2){
            $todasAsPalavras[$indice+1] = 'cantavam';
          }
          elsif($palavraNoPlural == 3){
           $todasAsPalavras[$indice+1] = 'estavam';
          } 
          elsif($palavraNoPlural == 4){
           $todasAsPalavras[$indice+1] = 'faziam';
         }        
        }
      }
        $palavraNoPlural = $palavraNoPlural + 1;   
    }
   }
    if ($ultimaLetra =~ /\W/ && $ultimaLetra ne "\n")
   {
    $palavraTemporaria .= $ultimaLetra;
   } 
    $indice = $indice+1;
  }


  $textoDeSaida = $todasAsPalavras[0];
  $indice = 1;
  foreach (@todasAsPalavras)
  {
     $textoDeSaida = $textoDeSaida . ' ' . $todasAsPalavras[$indice]; 
     $indice = $indice+1;
  }
  open ( my $fh,'>', 'SaidaCorrigida.txt');
  print $fh  $textoDeSaida;
  close $fh;
}

sub CorretorCompleto
{
  use File::Copy;
  copy ("arquivoDeEntrada.txt", "arquivoDeEntrada_original.txt");
  ColocarPontoFinal();
  rename ("SaidaCorrigida.txt", "arquivoDeEntrada.txt");
  SubstituirPalavrasRepetidas($_[0]);
  rename ("SaidaCorrigida.txt", "arquivoDeEntrada.txt");
  ColocarLetrasMaiusculas();
  rename ("SaidaCorrigida.txt", "arquivoDeEntrada.txt"); 
  CorrecaoDePalavras();
  rename ("SaidaCorrigida.txt", "arquivoDeEntrada.txt");
  CorrecaoDePlural();
  unlink "arquivoDeEntrada.txt";
  rename ("arquivoDeEntrada_original.txt", "arquivoDeEntrada.txt");
}