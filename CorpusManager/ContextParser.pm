package CorpusManager::ContextParser;

use Moose;

use Lingua::EN::Sentence qw(get_sentences);
use Text::Fracture qw(init fract);

sub BUILD {
  init({ max_lines => 20, max_cpl => 300, max_chars => 2000 });
}

sub Parse {
  my ($self,%args) = @_;
  my @contexts;
  foreach my $contexttype (keys %{$args{ContextTypes}}) {
    push @contexts, @{$self->GetContexts
			(
			 Contents => $args{Contents},
			 ContextType => $contexttype,
			)};
  }
  return @contexts;
}

sub GetContexts {
  my ($self,%args) = @_;
  my $c = $args{Contents};
  if ($args{ContextType} eq 'sentence') {
    return $self->GetSentences
      (
       Contents => $c,
      );

    # what we have to do here is this - we must extract out each
    # sentence, each paragraph, each chapter, each section, etc hrm
    # context is tough, isn't it, maybe have a method for getting the
    # previous contexts

    # what do we have to work with


    # different NLP functions have different context requirements

    # I suppose we must annotate like semtag all of the aspects of the
    # text
  } elsif ($args{ContextType} eq 'fragment') {
    return $self->GetFragments
      (
       Contents => $c,
      );
  }
}

sub GetSentences {
  my ($self,%args) = @_;
  my $sentences = get_sentences($args{Contents});
  return $sentences;
}

sub GetFragments {
  my ($self,%args) = @_;
  my $aref = fract($args{Contents});
  return $aref;
}

1;
