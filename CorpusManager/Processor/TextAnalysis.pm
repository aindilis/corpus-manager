package CorpusManager::Processor::TextAnalysis;

# basic method is as follows

# iterate over sentences, run APE, if it is a valid parse, push it
# onto the list

use Moose;

extends 'CorpusManager::Processor';

use PerlLib::SwissArmyKnife;

after 'new' => sub {
  $self->ContextTypes({
		       sentence => 1,
		      });
};

sub ProcessContext {
  my ($self,%args) = @_;
  print Dumper
    ($self->APE->Parse
     (Text => $args{Context}));
}

__PACKAGE__->meta()->make_immutable();

1;
