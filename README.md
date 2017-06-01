# ![VIROME DIY Analysis Pipeline](https://github.com/Virome-Collaboration-Group/virome-DIY/blob/master/assets/img/virome-diy.png)

### Introduction
VIROME Do It Yourself Analysis Pipeline

Analysis of viral shotgun metagenomic data proves especially challenging due to the relative under-representation of viral genetic diversity in sequence databases.   The Viral Information Resource for Metagenome Exploration (VIROME - http://virome.dbi.udel.edu) is a bioinformatics analysis pipeline and web-visualization environment that has been designed to maximize the utility of viral metagenomes by providing functional, taxonomic, and environmental context for metagenomic ORF sequences.  To provide the high-level of sensitivity that this analysis pipeline requires, has traditionally required it to be run on large high performance compute clusters resulting in a lengthy analysis queue.  

VIROME-DIY is a docker-based version of the VIROME analysis pipeline that allows users to bypass the virome analysis queue and run the analysis on their own.  Recent advances in our analysis pipeline, including the development of RUBBLE (Restricted clUster BLAST-Based PipeLinE), have greatly reduced the computational requirements for our pipeline allowing the VIROME-DIY pipeline to run on a single server or powerful desktop computer.  Once completed the results can be uploaded to the VIROME submission portal allowing users to explore, compare, and bin their results using our web-based visualization environment.

VIROME-DIY pipeline has been tested on a Linux computer server with 24 cpus, 128GB memory.  However, the pipeline has been designed to run on modest
desktop or laptop with at least 8GB of free memory and at least 200GB of storage space [mention of subject_db size alone?]

### Requirements
#### Software
- [Docker](https://docs.docker.com/installation/) for Linux / Windows / OSX
- Perl v5.18 or higher

### Running the pipeline

#### Run default test case using web browser to monitor pipeline progress
```
execute_pipeline.pl --output_dir=/dir/to/store/output --database_dir=/dir/to/store/subject_db --test_mode
```

#### Run pipeline with use defined input
```
execute_pipeline.pl --output_dir=/dir/to/store/output --database_dir=/dir/to/store/subject_db —-input_file=/path/to/filename.fasta
```

#### OPTIONS
* --input_file=, -i

    Required. Complete path of input file that need to be analyzed via VIROME-DIY
    docker image

* --output_dir=, -o

    Required. Complete path of output location where all results and temp files are stored
    Temporary files will be deleted up on successful completion of VIROME-DIY analysis pipeline.
    Directory will be create if it does not exists.

* --database_dir=, -d

    Required. Complete path of directory where subject_db related to VIROME-DIY is located
    (either if you previously ran VIROME-DIY container or manually downloaded that database.)
    If subject_db are not found in the location provided they will be downloaded at run time.
    Directory will be create if it does not exists

* --version=

    Optional. Run specific version of VIROME-DIY analysis pipeline.  By default
    latest version of VIROME-DIY analysis pipeline will be executed.  Check
    [all available tags](https://hub.docker.com/r/virome/virome-pipeline/tags/)
    for **_version_** options

* --test_mode

    Optional. Run container in test-mode to confirm your environment is setup.
    If running container in test-mode **_input_file_** parameter is not required.

* --help, -h

    Display usage and help message.

### OUTPUT
Upon successful completion of VIROME-DIY analysis pipeline a complete tar package
will be available in the **_output_dir_** with prefix of **_input_file_** and a
timestamp.  This file can be uploaded to
[VIROME Submission portal](http://virome.dbi.udel.edu/submission) and
results can be view data using [VIROME data exploration app](http://virome.dbi.udel.edu/app)
