use warnings;
use strict;
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0);
use ModuloCorretorOrtografico qw(:ALL);
use Scalar::Util qw(looks_like_number);
use utf8;

my $arq = "textoPontuacao.txt";
my $outputArq = "textoCorrigido4.txt";
my $controle = 0;
my $controleDeRepticao = 0;
my $palavraRepetida = "";

while ($controle != -1)
{
	print "Corretor Ortografico\n";
	print "Insira um arquivo com o nome 'arquivoDeEntrada.txt' na pasta do codigo\n"; 
	print "Digite um numero para realizar operacoes sobre o texto:\n";
	print "1 - Correcao de palvras escritas erradas\n";
	print "2 - Correcao de plural em sentencas\n";
	print "3 - Colocar letras maiusculas em nomes\n";
	print "4 - Trocar palavras repetidas por sinonimos\n";
	print "5 - Colocar ponto no final da sentenca\n";
	print "6 - Realizar correcao completa\n";
	print "-1 - Encerrar o programa\n";

	$controle = <STDIN>;
	if (looks_like_number($controle))
	{
		system "clear";
		if 		($controle == 1)
		{
			CorrecaoDePalavras();
		}
		elsif ($controle == 2)
		{
			CorrecaoDePlural();
		}
		elsif ($controle == 3)
		{
			ColocarLetrasMaiusculas();
		}
		elsif ($controle == 4)
		{
			print "Digite a palavra que se deseja trocar por sinonimos\n";
			$palavraRepetida = <STDIN>;
			$palavraRepetida =~ s/\n//g;
			SubstituirPalavrasRepetidas($palavraRepetida);
		}
		elsif ($controle == 5)
		{
			ColocarPontoFinal();
		}
		elsif ($controle == 6)
		{
			print "Digite a palavra que se deseja trocar por sinonimos\n";
			$palavraRepetida = <STDIN>;
			$palavraRepetida =~ s/\n//g;
			CorretorCompleto($palavraRepetida);
		}
		elsif ($controle == -1)
		{
			$controle = -1;
		}
		else
		{
			print "Funcao desconhecida\n";
		}
		if ($controle != -1)
		{
			print "Operacao realizada com sucesso!\n";
			print "Deseja realizar uma nova operacao? S = 1 e N = 0\n";	
			$controleDeRepticao = <STDIN>;		
		}
	

		if (looks_like_number($controleDeRepticao))
		{
			if ($controleDeRepticao == 0 || $controle == -1)
			{
				$controle = -1;
				print "Programa encerrado com sucesso!\n;";
			}			
		}
		else
		{
			system "clear";
			print "Por favor digite um numero\n";
		}

	}
	else
	{
		system "clear";
		print "Por favor digite um numero\n";
		$controle = 0;
		$controleDeRepticao = 0;
	}
}
