use warnings;
use strict;
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0);
use ModuloCorretorOrtografico qw(:ALL);
my $arq = "textoPontuacao.txt";
my $outputArq = "textoCorrigido4.txt";

ColocarPontoFinal($arq, $outputArq);