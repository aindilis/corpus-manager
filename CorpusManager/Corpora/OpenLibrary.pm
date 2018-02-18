package CorpusManager::Corpora::OpenLibrary;

use CorpusManager::Document::File;
use PerlLib::SwissArmyKnife;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Loaded Dir /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Dir("/var/lib/myfrdcsa/codebases/minor-data/corpus-manager/corpora/openlibrary/download");
  $self->Loaded(0);
}

sub UpdateCorpora {
  my ($self,%args) = @_;
}

sub LoadCorpora {
  my ($self,%args) = @_;
  $self->Loaded(1);
}

sub UnloadCorpora {
  my ($self,%args) = @_;
  $self->Loaded(0);
}

sub GetDocuments {
  my ($self,%args) = @_;
  my @docs;
  if ($self->Loaded) {
    chdir $self->Dir;
    foreach my $file (split /\n/, `find . | grep txt`) {
      print "<$file>\n";
      my $filename = ConcatDir($self->Dir,$file);
      if (-f $filename) {
	push @docs, CorpusManager::Document::File->new
	  (Filename => $filename);
      }
    }
  }
  return \@docs;
}

sub GetSentences {
  my ($self,%args) = @_;

}

1;
