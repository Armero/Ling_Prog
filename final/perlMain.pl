use warnings;
use strict;
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0);
use ModuloCorretorOrtografico qw(:ALL);
use utf8;

sub principal 
{
	my $controle = $_[0];
	my $palavraRepetida = $_[1];
	
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
		$palavraRepetida =~ s/\n//g;
		SubstituirPalavrasRepetidas($palavraRepetida);
	}
	elsif ($controle == 5)
	{
		ColocarPontoFinal();
	}
	elsif ($controle == 6)
	{
		$palavraRepetida =~ s/\n//g;
		CorretorCompleto($palavraRepetida);
	}
}