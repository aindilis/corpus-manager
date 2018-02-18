package CorpusManager::CorporaManager;

use Manager::Dialog qw(Message SubsetSelect);
use PerlLib::Collection;
use PerlLib::SwissArmyKnife;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / ListOfCorpora MyCorpora /

  ];

sub init {
  my ($self,%args) = @_;
  Message(Message => "Initializing corpora...");
  my @names = map {$_ =~ s/.pm$//; $_}
    grep(/\.pm$/,split /\n/,
	 `ls $UNIVERSAL::systemdir/CorpusManager/Corpora`);
  $self->ListOfCorpora($args{Corpora} || \@names);
  $self->MyCorpora
    (PerlLib::Collection->new
     (Type => "CorpusManager::Corpora"));
  $self->MyCorpora->Contents({});
  foreach my $name (@{$self->ListOfCorpora}) {
    Message(Message => "Initializing CorpusManager/Corpora/$name.pm...");
    require "CorpusManager/Corpora/$name.pm";
    my $s = "CorpusManager::Corpora::$name"->new();
    $self->MyCorpora->Add
      ($name => $s);
  }
}

sub UpdateCorpora {
  my ($self,%args) = @_;
  Message(Message => "Updating corpora...");

  my @keys;
  if (defined $args{Corpora} and ref $args{Corpora} eq "ARRAY") {
    @keys = @{$args{Corpora}};
  }
  if (!@keys) {
    @keys = $self->MyCorpora->Keys;
  }
  delete $args{Corpora};

  foreach my $key (@keys) {
    Message(Message => "Updating $key...");
    $self->MyCorpora->Contents->{$key}->UpdateCorpora(%args);
  }
}

sub LoadCorpora {
  my ($self,%args) = @_;
  Message(Message => "Loading corpora...");
  my @keys;
  if (defined $args{Corpora} and ref $args{Corpora} eq "ARRAY") {
    @keys = @{$args{Corpora}};
  }
  if (!@keys) {
    @keys = $self->MyCorpora->Keys;
  }
  delete $args{Corpora};

  foreach my $key (@keys) {
    Message(Message => "Loading $key...");
    $self->MyCorpora->Contents->{$key}->LoadCorpora(%args);
  }
}

sub GetDocuments {
  my ($self,%args) = @_;
  Message(Message => "Getting Result List from corpora...");
  my @keys;
  if (defined $args{Corpora} and ref $args{Corpora} eq "ARRAY") {
    @keys = @{$args{Corpora}};
  }
  if (!@keys) {
    @keys = $self->MyCorpora->Keys;
  }
  delete $args{Corpora};

  foreach my $key (@keys) {
    my $corpora = $self->MyCorpora->Contents->{$key};
    if (! $corpora->Loaded) {
      Message(Message => "Loading $key...");
      $corpora->LoadCorpora(%args);
    }
    push @resultlist, @{$corpora->GetDocuments};
  }
  return \@resultlist;
}

sub Search {
  my ($self,%args) = @_;

}

1;
