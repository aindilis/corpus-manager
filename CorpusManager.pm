package CorpusManager;

use BOSS::Config;
use MyFRDCSA;
use CorpusManager::CorporaManager;
use CorpusManager::CorporaProcessorManager;
use PerlLib::SwissArmyKnife;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Config MyCorporaManager MyCorporaProcessorManager /

  ];

sub init {
  my ($self,%args) = @_;
  $specification = "
	--lc				List available corpora
	-c [<corpus>...]		Process corpora

	--lp				List available processors
	-p [<processor>...]

	-u [<host> <port>]		Run as a UniLang agent

	-w				Require user input before exiting
";
  $UNIVERSAL::systemdir = ConcatDir(Dir("minor codebases"),"corpus-manager");
  $self->Config(BOSS::Config->new
		(Spec => $specification,
		 ConfFile => ""));
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  my $corpora = $args{Corpora} || $conf->{'-c'} ||
    [
     "Gutenberg",
     # "OpenLibrary",
    ];
  $self->MyCorporaManager
    (CorpusManager::CorporaManager->new
     (Corpora => $corpora));
  $self->MyCorporaManager->LoadCorpora
    (
     Corpora => $corpora,
    );

  my $processors = $args{Processors} || $conf->{'-p'} ||
    [
     # 'TextAnalysis',
     'ACERulesExtractor',
    ];
  $self->MyCorporaProcessorManager
    (CorpusManager::CorporaProcessorManager->new
     (
      Processors => $processors,
      CorpusManager => $self,
     ));

  if (exists $conf->{'-u'}) {
    # enter in to a listening loop
    while (1) {
      $UNIVERSAL::agent->Listen(TimeOut => 10);
    }
  }
  if (exists $conf->{'-w'}) {
    Message(Message => "Press any key to quit...");
    my $t = <STDIN>;
  }

  $self->MyCorporaProcessorManager->Process();
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  my $it = $m->Contents;
  if ($it) {
    if ($it =~ /^echo\s*(.*)/) {
      $UNIVERSAL::agent->SendContents
	(Contents => $1,
	 Receiver => $m->{Sender});
    } elsif ($it =~ /^(quit|exit)$/i) {
      $UNIVERSAL::agent->Deregister;
      exit(0);
    }
  }
}

1;
