package CorpusManager::Manager;

use CorpusManager::CorporaManager;

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / MyCorporaManager /

  ];

sub init {
  my ($self,%args) = @_;
  $self->MyCorporaManager
    (CorpusManager::CorporaManager->new
     ());
}

sub Execute {
  my ($self,%args) = @_;
  $self->MyCorporaManager->LoadCorpora();

}

1;
