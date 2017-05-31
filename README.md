# virome-DIY
VIROME Do It Yourself Analysis Pipeline

Analysis of viral shotgun metagenomic data proves especially challenging due to the relative under-representation of viral genetic diversity in sequence databases.   The Viral Information Resource for Metagenome Exploration (VIROME - http://virome.dbi.udel.edu) is a bioinformatics analysis pipeline and web-visualization environment that has been designed to maximize the utility of viral metagenomes by providing functional, taxonomic, and environmental context for metagenomic ORF sequences.  To provide the high-level of sensitivity that this analysis pipeline requires, has traditionally required it to be run on large high performance compute clusters resulting in a lengthy analysis queue.  

VIROME-DIY is a docker-based version of the VIROME analysis pipeline that allows users to bypass the virome analysis queue and run the analysis on their own.  Recent advances in our analysis pipeline, including the development of RUBBLE (Restricted clUster BLAST-Based PipeLinE), have greatly reduced the computational requirements for our pipeline allowing the VIROME-DIY pipeline to run on a single server or powerful desktop computer.  Once completed the results can be uploaded to the VIROME submission portal allowing users to explore, compare, and bin their results using our web-based visualization environment.

