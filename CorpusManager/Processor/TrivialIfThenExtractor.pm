package CorpusManager::Processor::TrivialIfThenExtractor;

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
  my $sentence = $args{Context};
  if ($sentence =~ /\bshould\b/si or
      $sentence =~ /\bif\b.+\bthen\b/si) {
    $sentence =~ s/\s+/ /g;
    print $sentence."\n";
  }
}

__PACKAGE__->meta()->make_immutable();

1;


