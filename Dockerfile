FROM ubuntu:18.04

ENV SAMTOOLS='/usr/local/soft/samtools-1.19.2'
ENV HTSLIB='/usr/local/soft/htslib-1.19.1'
ENV LIBDEFLATE='/usr/local/soft/libdeflate-1.10'
ENV BCFTOOLS='/usr/local/soft/bcftools-1.19'
ENV VCFTOOLS='/usr/local/soft/vcftools-0.1.16'
ENV SOFT='usr/local/soft'

# Обновляем пакеты
RUN apt-get update && \
    apt-get install -y \
    wget \
    apt-utils \
    pkg-config \
    autoconf \
    automake \
    libtool \
    make \
    gcc \
    perl \
    zlibc \
    zlib1g \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libncurses5-dev && \
    apt-get clean && apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $SOFT


#samtools-1.19.2 released on 24 Jan 2024
RUN wget https://github.com/samtools/samtools/releases/download/1.19.2/samtools-1.19.2.tar.bz2 && \
    tar jxf samtools-1.19.2.tar.bz2 && \
    rm samtools-1.19.2.tar.bz2 && \
    cd samtools-1.19.2 && \
    autoheader && \
    autoconf -Wno-syntax && \
    ./configure --prefix $SAMTOOLS && \
    make && \
    make install

#htslib-1.19.1 released on 22 Jan 2024
RUN wget https://github.com/samtools/htslib/releases/download/1.19.1/htslib-1.19.1.tar.bz2 && \
    tar jxf htslib-1.19.1.tar.bz2 && \
    rm htslib-1.19.1.tar.bz2 && \
    cd htslib-1.19.1 && \
    autoreconf -i && \
    ./configure --prefix $HTSLIB && \
    make && \
    make install


#libdeflate-v.1.10 released on Feb 7, 2022 (последняя версию не удалось скачать)
RUN wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.10.tar.gz && \
    tar  -xvzf v1.10.tar.gz && \
    rm v1.10.tar.gz && \
    cd libdeflate-1.10 && \
    make && \
    make DESTDIR=$LIBDEFLATE install

# bcftools-1.19 released Dec 12, 2023
RUN wget https://github.com/samtools/bcftools/releases/download/1.19/bcftools-1.19.tar.bz2 && \
    tar jxf bcftools-1.19.tar.bz2 && \
    rm bcftools-1.19.tar.bz2 && \
    cd bcftools-1.19 && \
    autoheader && \
    autoconf -Wno-syntax && \
    ./configure --prefix $BCFTOOLS && \
    make && \
    make install
    
# vcftools-0.1.16 released Aug 2, 2018
RUN wget https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz && \
    tar  -xvzf vcftools-0.1.16.tar.gz && \
    rm vcftools-0.1.16.tar.gz && \
    cd vcftools-0.1.16 && \
    ./configure --prefix=$VCFTOOLS && \
    make && \
    make install



ENV PATH=${PATH}:$SAMTOOLS:$HTSLIB:$LIBDEFLATE:$BCFTOOLS:$VCFTOOLS:$SOFT

CMD ["bash"]
