package CorpusManager::Processor;

use Moose;

use PerlLib::SwissArmyKnife;

has ContextParser =>
  (
   is => 'rw',
   isa => 'CorpusManager::ContextParser',
  );

has ContextTypes =>
  (
   is => 'rw',
   isa => 'HashRef',
  );

sub Process {
  my ($self,%args) = @_;
  foreach my $context
    ($self->ContextParser->Parse
     (
      ContextTypes => $self->ContextTypes,
      Contents => $args{Contents},
     )) {
    $self->ProcessContext(Context => $context);
  }
}

sub ProcessContext {
  my ($self,%args) = @_;
  
}

1;
