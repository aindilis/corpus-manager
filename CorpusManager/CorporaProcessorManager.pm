package CorpusManager::CorporaProcessorManager;

use Moose;

# foreach document in the corpus

# skip for now
# run the document through KBFS to extract features of the document

# iterate over documents, catting them, and processing them with the
# FRDCSA tools

use Capability::TextAnalysis;
use CorpusManager;
use CorpusManager::ContextParser;
use PerlLib::Collection;
use PerlLib::SwissArmyKnife;

has 'MyProcessors' =>
  (
   is => 'rw',
   isa => 'PerlLib::Collection',
   default => sub {
     my $myprocessors = PerlLib::Collection->new
	 (Type => "CorpusManager::Processor");
     $myprocessors->Contents({});
     return $myprocessors;
   },
  );

has 'CorpusManager' =>
  (
   is => 'rw',
   isa => 'CorpusManager',
  );

has 'Processors' =>
  (
   is => 'rw',
   isa => 'ArrayRef[Str]',
  );

has 'ContextParser' =>
  (
   is => 'rw',
   isa => 'CorpusManager::ContextParser',
   default => sub {
     CorpusManager::ContextParser->new();
   },
  );

sub BUILD {
  my ($self) = @_;
  Message(Message => "Initializing processors...");
  my @names = map {$_ =~ s/.pm$//; $_}
    grep(/\.pm$/,split /\n/,
	 `ls $UNIVERSAL::systemdir/CorpusManager/Processor`);
  foreach my $name (@{$self->Processors}) {
    Message(Message => "Initializing CorpusManager/Processor/$name.pm...");
    require "CorpusManager/Processor/$name.pm";
    my $s = "CorpusManager::Processor::$name"->new
      (ContextParser => $self->ContextParser);
    $self->MyProcessors->Add
      ($name => $s);
  }
};

sub Process {
  my ($self,%args) = @_;
  my $docs = $self->CorpusManager->MyCorporaManager->GetDocuments;
  foreach my $doc (@$docs) {
    # print $doc->Contents."\n\n\n";
    # extract contexts
    foreach my $processor ($self->MyProcessors->Values) {
      $processor->Process
	(
	 Contents => $doc->Contents,
	);
    }

    # get the innards of this: /var/lib/myfrdcsa/codebases/minor/nlu/systems/annotation/process-2.pl

    # process this with the NLU stuff

    # GetSignalFromUserToProceed();
    # see if the document has already been processed, if not, process it.
    # how to break up the document best?
    # we need document formatting/style/structure/etc extraction
    # use that fragment for now
  }
}

__PACKAGE__->meta()->make_immutable();

1;

