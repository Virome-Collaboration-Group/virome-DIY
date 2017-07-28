#! /usr/bin/perl

=head1 NAME

    execute_pipeline.pl - A script to execute VIROME DIY Analysis pipeline docker
    container

=head1 SYNOPSIS

USAGE: execute_pipeline.pl --input_file=/path/to/input_file.fasta
                           --output_dir=/path/to/output_dir
                           --database_dir=/path/to/subject_db
                           [--threads=1
                            --version=1.0
                            --test_mode
                            --help]

=head1 OPTIONS

B<--input_file, -i>
    Required. Complete path of input file that need to be analyzed via VIROME-DIY
    docker image

B<--output_dir, -o>
    Required. Complete path of output location where all results and temp files are stored
    Temporary files will be deleted up on successful completion of VIROME-DIY analysis pipeline.
    Directory will be create if it does not exists.

B<--database_dir, -d>
    Required. Complete path of directory where subject_db related to VIROME-DIY is located
    (either if you previously ran VIROME-DIY container or manually downloaded that database.)
    If subject_db are not found in the location provided they will be downloaded at run time.
    Directory will be create if it does not exists

B<--threads>
    Optional. Improve performance by running VIROME-DIY multi-threaded [note on memory here?]
    Defaults to 1.

B<--version>
    Optional. Run specific version of VIROME-DIY analysis pipeline.  Check
        https://hub.docker.com/r/virome/virome-pipeline/tags/
    For all other version options.  Current version is 1.0

B<--test_mode>
    Optional. Run container in test-mode to confirm your environment is setup.
    If running container in test-mode input_file parameter is not required.

B<--help, -h>
    This help message


=head1  DESCRIPTION

    Run VIROME-DIY Analysis pipeline.  Pipeline is created as a Docker image which is
    self contained and completely configured.  For list of requirements visit

        https://github.com/Virome-Collaboration-Group/virome-DIY

=head1  INPUT

    Input fasta file to analyze

=head1  OUTPUT

    A complete tarball package that can be uploaded to
    VIROME Submission portal (http://virome.dbi.udel.edu/submission) and
    view data using VIROME data exploration app (http://virome.dbi.udel.edu/app)

=head1  CONTACT

    Jaysheel Bhavsar jaysheel@udel.edu
    Shawn Polson polson@dbi.udel.edu
    Dan Nasko dnasko@udel.edu

=cut


use strict;
use warnings;
use File::Basename;
use File::Path;
use File::Spec;
use Data::Dumper;
use Pod::Usage;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev pass_through);

my %options = ();
my $results = GetOptions (\%options,
                          'input_file|i=s',
                          'output_dir|o=s',
                          'database_dir|d=s',
                          'threads=i',
                          'version=s',
                          'test_mode',
                          'help|h') || pod2usage();

#### display documentation
if( $options{'help'} ){
    pod2usage( {-exitval => 0, -verbose => 2, -output => \*STDERR} );
}

#### make sure everything passed was peachy if not running in test mode
&check_parameters(\%options);

#### convert all file paths to absolute file paths
$options{output_dir} = File::Spec->rel2abs( $options{output_dir} ) ;
$options{database_dir} = File::Spec->rel2abs( $options{database_dir} ) ;
$options{input_file} = File::Spec->rel2abs( $options{input_file} ) ;
$options{output_dir}   =~ s/\.\.\/.*?\///g; ## Need to do this to get rid of ../blah/../blah
$options{database_dir} =~ s/\.\.\/.*?\///g; ## Again.
$options{input_file}   =~ s/\.\.\/.*?\///g; ## And again.

#### create output dir if they don't exists.
&create_output_dir();

#### TODO check docker install.

#### pull latest docker image.
my $cmd = "docker pull virome/virome-pipeline:$options{version}";
execute_cmd($cmd);

#### create a docker run statement
$cmd = "docker run -ti --rm -u `id -u`:`id -g` -v $options{output_dir}:/opt/output";
$cmd .= " -v $options{database_dir}:/opt/database";

if ($options{test_mode}) {
    $cmd .= " --entrypoint /opt/scripts/execute_pipeline_test.sh";
}

$cmd .= " virome/virome-pipeline:$options{version} --threads=$options{threads}";

if ($options{test_mode}) {
    $cmd .= " --test-case1";
} else {
    $cmd .= " $options{input_file}";
}
execute_cmd($cmd);

#### TODO capture and check output of docker run, if error display error and
#### display locaiton of persistent storate location where logs are available
#### if success display success message and pointer to virome submission message
#### for most part this will be just a pass through from the docker run output
#### except change the output_dir location.

exit(0);

###############################################################################
sub check_parameters {
    my $options = shift;

    #### make sure required arguments were passed
    my @required = qw(output_dir database_dir);

    #### if running in test-mode input is not required.
    unless(defined $options{'test_mode'}){
        push(@required, "input_file");
    }

    for my $key ( @required ) {
        unless  ( defined $options{$key} ) {
            pod2usage({-exitval => 2,  -message => "ERROR: Input $key not defined", -verbose => 1, -output => \*STDERR});
        }
    }

    $options{version} = "latest" unless(defined $options{version});
    $options{threads} = 1 unless(defined $options{threads});
}
###############################################################################
sub create_output_dir {
    my $dir = shift;

    #### make output_dir and output_dir/logs if it does not exists
    mkpath($options{output_dir}."/logs", 0, '0755');

    #### make database_dir if it does not exists
    mkpath($options{database_dir}, 0, '0755');
}

#############################################################################
sub execute_cmd {
	my $cmd = shift;

	system($cmd);

	while (( $? >> 8 ) != 0 ) {
		print "ERROR: Following command failed to execute. Exiting execution of workflow\n$cmd";
		exit(100);
	}
}

###############################################################################
sub timestamp {
	my @months   = qw(01 02 03 04 05 06 07 08 09 10 11 12);
	my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	my (
		$second,     $minute,    $hour,
		$dayOfMonth, $month,     $yearOffset,
		$dayOfWeek,  $dayOfYear, $daylightSavings
	  )
	  = localtime();

	my $year    = 1900 + $yearOffset;
	my $theTime = $year ."". $months[$month] ."". $dayOfMonth ."". $hour ."". $minute ."". $second;

    return $theTime;
}
