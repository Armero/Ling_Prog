package ModuloCorretorOrtografico;

use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(VerificarNome ColocarLetrasMaiusculas);
%EXPORT_TAGS = ( ALL => [qw(&VerificarNome &ColocarLetrasMaiusculas)]);

sub VerificarNome 
{
  if ($_[0] eq $_[1])
  {
    return 1;
  }
  return 0;
}

sub ColocarLetrasMaiusculas
{
  #abre o arquivo passado pelo usuario e o arquivo padrao com todos os nomes listados
  my $nomeArquivo = $_[0];
  my $arquivoBase = "nomes.txt";
  my @palavras = [];
  my $contador = 0;
  my $palavraFiltrada = "";
  my $nomeBase = "";
  my $arquivoSaida = "textoCorrigido.txt";
  my $novaPalavra = "";
  my $palavraOriginal = "";
  my $achou = 0;
  my $ultimaLetra = "";

  open (my $conteudoArquivo, "<", $nomeArquivo) or die "Impossivel abrir o conteudo do arquivo: $!";
  open (my $textoBase, "<", $arquivoBase) or die "Impossivel abrir o conteudo do arquivo: $!";
  open (my $textoCorrigido, ">", $arquivoSaida) or die "Impossivel criar o arquivos";
    
  #le as palavras no texto passado para a funcao
  while (<$conteudoArquivo>)
  {
    #separa a linha em palavras
    @palavras = split;
    foreach (@palavras)
    {
      $novaPalavra = $_;
      $palavraFiltrada = $_;
      $palavraOriginal = $_;

      #remove caracteres especiais da palavra assim como ',#@' etc que nao caracterizam uma palavra
      $palavraFiltrada =~ s/[\$#@~!&*()\[\];.,:?^ `\\\/]+//g;
      while (<$textoBase>)
      {
        $nomeBase = $_;
        if ($achou == 0)
        {
          #tira os pulas linhas dos nomes no arquivo padrao de nomes
          $nomeBase =~ s/\n//g;
          $achou = VerificarNome ($nomeBase, $palavraFiltrada);
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
    
    #pula linha no arquivo
    print $textoCorrigido "\n";
  }

  #fecha os arquivos -> nao esquecer isto de forma alguma
  close ($conteudoArquivo);
  close ($textoBase);
  close ($textoCorrigido);
}