package CorpusManager::Processor::ACERulesExtractor;

# basic method is as follows

# iterate over sentences, run APE, if it is a valid parse, push it
# onto the list

use Moose;

extends 'CorpusManager::Processor';

use PerlLib::SwissArmyKnife;
use System::APE;

has 'APE' =>
  (
   is => 'rw',
   isa => 'System::APE',
   default => sub {
     System::APE->new();
   },
  );

sub BUILD {
  my ($self) = @_;
  $self->APE->StartServer;
  $self->APE->StartClient();
  $self->ContextTypes({
		       sentence => 1,
		      });
  print "Accepting...\n";
};

sub ProcessContext {
  my ($self,%args) = @_;
  print Dumper
    ($self->APE->Parse
     (Text => $args{Context}));
}

__PACKAGE__->meta()->make_immutable();

1;
