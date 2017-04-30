use warnings;
use strict;
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0);
use ModuloCorretorOrtografico qw(:ALL);
my $arq = "textoSinonimos.txt";
my $outputArq = "textoCorrigido2.txt";

SubstituirPalavrasRepetidas($arq, $outputArq, "feliz");
$outputArq = "textoCorrigido3.txt";
SubstituirPalavrasRepetidas("textoCorrigido2.txt", $outputArq, "triste");