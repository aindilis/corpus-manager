package CorpusManager::Document;

use PerlLib::Collection;

use Lingua::EN::Sentence qw(get_sentences);

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Corpus Name /

  ];

sub init {
  my ($self,%args) = @_;

}

sub Segments {
  my ($self,%args) = @_;

}

sub Sentences {
  my ($self,%args) = @_;
  my $sentences = get_sentences($self->Contents);
  return $sentences;
}

sub LogicForms {
  my ($self,%args) = @_;

}

1;
