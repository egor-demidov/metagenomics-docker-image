FROM ubuntu:22.04

RUN apt update && apt install -y wget
RUN useradd -m dcuser

USER dcuser

WORKDIR /home/dcuser

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod a+x Miniconda3-latest-Linux-x86_64.sh
RUN ./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/anaconda3
RUN wget https://raw.githubusercontent.com/carpentries-lab/metagenomics-analysis/refs/heads/gh-pages/files/spec-file-Ubuntu22.txt

ENV PATH="/home/dcuser/anaconda3/bin:$PATH"

RUN conda create --name metagenomics --file spec-file-Ubuntu22.txt

ENV PATH="/home/dcuser/anaconda3/envs/metagenomics/bin:$PATH"

RUN bash ./anaconda3/envs/metagenomics/opt/krona/updateTaxonomy.sh
RUN wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
RUN tar -xzf taxdump.tar.gz
RUN mkdir .taxonkit
RUN cp names.dmp nodes.dmp delnodes.dmp merged.dmp /home/dcuser/.taxonkit
RUN rm *dmp readme.txt taxdump.tar.gz gc.prt

