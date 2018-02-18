package CorpusManager::Corpora::Gutenberg;

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
  $self->Dir("/var/lib/myfrdcsa/codebases/minor-data/corpus-manager/corpora/gutenberg");
  $self->Loaded(0);
}

sub UpdateCorpora {
  my ($self,%args) = @_;
}

sub LoadCorpora {
  my ($self,%args) = @_;
  # mount the file
  if (!IsMounted(Item => $self->Dir) and
      -f "/var/lib/myfrdcsa/datasets/pgdvd-201004/pgdvd-201004/pgdvd042010.iso") {
    system "sudo mount -t iso9660 -o loop,ro /var/lib/myfrdcsa/datasets/pgdvd-201004/pgdvd-201004/pgdvd042010.iso ".$self->Dir;
    $self->Loaded(1);
  } else {
    $self->Loaded(1);
  }
}

sub UnloadCorpora {
  my ($self,%args) = @_;
  # mount the file
  if (IsMounted(Item => $self->Dir)) {
    system "sudo umount ".$self->Dir;
    $self->Loaded(0);
  }
}

sub GetDocuments {
  my ($self,%args) = @_;
  my @docs;
  if ($self->Loaded) {
    chdir $self->Dir;
    foreach my $file (split /\n/, `find [0-9] etext[0-9][0-9] | grep zip`) {
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
