package CorpusManager::Document::File;

use base qw(CorpusManager::Document);

use PerlLib::SwissArmyKnife;

use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

use Class::MethodMaker
  new_with_init => 'new',
  get_set       =>
  [

   qw / Filename /

  ];

sub init {
  my ($self,%args) = @_;
  $self->Filename($args{Filename});
  $self->SUPER::init(%args);
}

sub Contents {
  my ($self,%args) = @_;

  # figure out what type of file it is
  # handle gutenberg zip files
  if ($self->Filename =~ /\.zip$/i) {
    return $self->ExtractTextContents(Zip => $self->Filename);
  }

  # use totext on other types of files

  return read_file($self->Filename);
}

# sub GetSentences {
#   my ($self,%args) = @_;
#   $self->SUPER::GetSentences(%args);
# }

sub Segments {
  my ($self,%args) = @_;

}

sub LogicForms {
  my ($self,%args) = @_;

}

# my $zipfilename = "/var/lib/myfrdcsa/codebases/minor-data/corpus-manager/corpora/gutenberg/1/6/4/8/16481/16481_8.zip";
# print ExtractTextContents(Zip => $zipfilename);

sub ExtractTextContents {
  my ($self,%args) = @_;
  my $somezip = Archive::Zip->new();
  unless ( $somezip->read( $args{Zip} ) == AZ_OK ) {
    print 'read error';
    return;
  }
  foreach my $file ($somezip->memberNames()) {
    print "<$file>\n";
    if ($file =~ /\.txt$/i) {
      return $somezip->contents($file);
    }
  }
}

1;
