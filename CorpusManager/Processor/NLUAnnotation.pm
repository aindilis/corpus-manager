package CorpusManager::Processor::NLUAnnotation;

use Moose;

extends 'CorpusManager::Processor';

use NLU::Util::AnnotationStyle;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

after 'new' => sub {
  $self->ContextTypes({
		       fragment => 1,
		      });
};


# take this book, and run the NLU on it, to extract all the
# annotations that are necessary, as though it were being processed on
# workhorse

# have the intersplicing of the annotations done

# just handle the first paragraph for now

sub ProcessContext {
  my ($self,%args) = @_;
  # come up with a system for annotated with respect to a different text

  # split the book into paragraphs, and then perform the NLU analysis on
  # the paragraphs with the offsets marked

  AnalyzeFragment
    (
     Text => substr($text,$fragment->[0],$fragment->[1]),
     Offset => $fragment->[0],
    );
}

sub AnalyzeFragment {
  my %args = @_;
  my $tmpfile = "/tmp/kuranatron.txt";
  SafelyRemove
    (
     Items => [$tmpfile],
     AutoApprove => 1,
    );

  # send to the NLU for analysis
  my $fh = IO::File->new();
  $fh->open(">$tmpfile");
  print $fh $args{Text};
  $fh->close();

  my $tempagent = UniLang::Util::TempAgent->new();

  my $message = $tempagent->MyAgent->QueryAgent
    (
     Receiver => "NLU",
     Contents => "",
     Data => {
	      Database => "freekbs2",
	      Context => "Org::FRDCSA::NLU::Temp",
	      All => 1,
	      Run => 1,
	      # Clear => 1,
	      File => $tmpfile,
	      Start => $args{Offset},
	      # Tests => 1,
	      # Emacs => 1,
	     },
    );

  print $message->Generate();
}

__PACKAGE__->meta()->make_immutable();

1;
