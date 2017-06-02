# ![VIROME DIY Analysis Pipeline](https://github.com/Virome-Collaboration-Group/virome-DIY/blob/master/assets/img/virome-diy.png)

### Introduction
VIROME Do It Yourself Analysis Pipeline

Analysis of viral shotgun metagenomic data can be especially challenging due to the relative under-representation of viral genetic diversity in sequence databases.   The Viral Information Resource for Metagenome Exploration (VIROME - http://virome.dbi.udel.edu) is a bioinformatics analysis pipeline and web-visualization environment that has been designed to maximize the utility of viral metagenomes by providing functional, taxonomic, and environmental context for metagenomic ORF sequences.  To provide the high-level of sensitivity that this analysis pipeline requires, has traditionally required it to be run on large high performance compute clusters resulting in a lengthy analysis queue.

VIROME-DIY is a docker-based version of the VIROME analysis pipeline that allows users to bypass the virome analysis queue and run the analysis on their own.  Recent advances in our analysis pipeline, including the development of [RUBBLE](https://github.com/dnasko/rubble) (Restricted clUster BLAST-Based PipeLinE), have greatly reduced the computational requirements for our pipeline allowing the VIROME-DIY pipeline to run on a single server or powerful desktop computer.  Once completed the results can be uploaded to the VIROME submission portal allowing users to explore, compare, and bin their results using our web-based visualization environment.

### Requirements

#### Hardware
The VIROME-DIY pipeline has been tested on a Linux server with 24 CPUs and 128 GB memory.  However, the pipeline has been designed to run on a medium-sized Linux server, but is capable of running on a well equipped desktop (e.g. at least 8 CPUs, 16GB of free memory, and 200GB of storage space).

The amount of RAM required to run a pipeline is contingent upon the number of CPUs you use to run it. It's approximately 1.5 GB per CPU used, but that's not very exact. The *exact* amount of RAM required for a pipeline run is calculated as *ceiling*(n CPUs / 4)*5.5 GB. Here are some examples:

| n CPUs | Total RAM Required |
|:------:| ------------------:|
|    1   | 5.5 GB             |
|    2   | 5.5 GB             |
|    4   | 11  GB             |
|    6   | 11  GB             |
|    8   | 11  GB             |
|   16   | 22  GB             |
|   32   | 44  GB             |

#### Software
- [Docker](https://docs.docker.com/installation/) for Linux / Windows / OSX
- Perl v5.18 or higher

### Performance

As we run more libraries with VIROME-DIY we will continue to report and improve performance. Using the current version of VIROME-DIY here are some wall clock estimates:

| n CPUs | Library Read Size | Library Contig Size | Wall Clock Time |
|:------:| -----------------:| -------------------:| ---------------:|
|    8   |   186 Mbp         |        16 Mbp       |     45 minutes  |
|   12   |   186 Mbp         |        16 Mbp       |     30 minutes  |

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

* --threads=N

    Optional (default = 1). Improve performance by running VIROME-DIY multi-threaded. Note you need approx. 1.5 GB
	of RAM for each thread you request. More specifically you need *ceiling*(n threads / 4)*5.5 GB.

* --version=SSS

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
Upon successful completion of VIROME-DIY analysis pipeline a compressed tar package
will be available in the **_output_dir_** with prefix of **_input_file_** and a
timestamp.  This file can be uploaded to
[VIROME Submission portal](http://virome.dbi.udel.edu/submission) and
results can be view data using [VIROME data exploration app](http://virome.dbi.udel.edu/app)

### Version

* 1.0 -> 2017/05

*Rev 02Jun2017 DJN*
