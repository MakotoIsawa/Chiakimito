use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'miki-mojo.pl',
  VERSION      => '1.0',
  AUTHOR       => 'Makoto Isawa <makoto.isawa@gmail.com>',
  EXE_FILES    => ['miki-mojo.pl'],
  PREREQ_PM    => {'Mojolicious' => '4.43'},
  PREREQ_PM    => {'WebService::YahooJapan::WebMA' => '0.01'},
  PREREQ_PM    => {'utf8' => '1.10'},
  PREREQ_PM    => {'Encode' => '2.55'},
  test         => {TESTS => 't/*.t'}
);
