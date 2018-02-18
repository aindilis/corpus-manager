package CorpusManager::Corpora::Personal;

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
  $self->Loaded(0);
  $self->Dir("/var/lib/myfrdcsa/datasets/personal-writings");
}

sub UpdateCorpora {
  my ($self,%args) = @_;
}

sub LoadCorpora {
  my ($self,%args) = @_;
  if (-d $self->Dir) {
    $self->Loaded(1);
  }
}

sub UnloadCorpora {
  my ($self,%args) = @_;
  $self->Loaded(0);
}

sub GetDocuments {
  my ($self,%args) = @_;
  my @docs;
  if ($self->Loaded) {
    my $dir = shell_quote($self->Dir);
    foreach my $file (split /\n/, `ls -1 $dir`) {
      my $filename = ConcatDir($dir,$file);
      if (-f $filename) {
	push @docs, CorpusManager::Document::File->new
	  (Filename => $filename);
      }
    }
  }
  return \@docs;
}

1;
