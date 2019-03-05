FROM ubuntu:latest

MAINTAINER Daniel Mulholland <dan.mulholland@gmail.com>

ENV JAVA_HOME /jdk1.8.0_112
ENV PATH $PATH:$JAVA_HOME/bin:/fopub/bin
ENV BACKENDS /asciidoctor-backends
ENV GVM_AUTO_ANSWER true
ENV ASCIIDOCTOR_VERSION "1.5.7.1"

# Set the locale
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

# No let's get cracking

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    findutils \
    gcc \
    git \
    gnupg2 \
    imagemagick \
    inkscape \
    libgit2-dev \
    libjpeg-dev \
    libssl-dev \
    libtool \
    make \
    openjdk-8-jdk \
    pkg-config \
    patch \
    python3 \
    python3-pip \
    python-all-dev \
    python-setuptools \
    ruby \
    ruby-all-dev \
    rubygems \
    graphviz \
    ruby-nokogiri \
    sudo \
    tar \
    unzip \
    zip \
    wget \
    zlib1g-dev

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN  gem install --no-ri --no-rdoc asciidoctor --version $ASCIIDOCTOR_VERSION \
  && gem install --no-ri --no-rdoc asciidoctor-diagram \
  && gem install --no-ri --no-rdoc asciidoctor-epub3 --version 1.5.0.alpha.6 \
  && gem install --no-ri --no-rdoc rake \
  && gem install --no-ri --no-rdoc epubcheck --version 3.0.1 \
  && gem install --no-ri --no-rdoc kindlegen --version 3.0.1 \
  && gem install --no-ri --no-rdoc asciidoctor-pdf --version 1.5.0.alpha.15 \
  && gem install --no-ri --no-rdoc asciidoctor-confluence \
  && gem install --no-ri --no-rdoc bundler \
  && gem install --no-ri --no-rdoc rouge coderay pygments.rb thread_safe epubcheck kindlegen \
  && gem install --no-ri --no-rdoc slim \
  && gem install --no-ri --no-rdoc haml tilt \
  && gem install --no-ri --no-rdoc asciidoctor-revealjs \
  && gem install --no-ri --no-rdoc rugged \
  && gem install --no-ri --no-rdoc asciidoctor-rouge \
  && gem install --no-ri --no-rdoc fastimage \
  && gem install --no-ri --no-rdoc html-proofer

RUN git clone https://github.com/danyill/htmldiff \
    && cd htmldiff \
    && python setup.py sdist \
    && python setup.py install

RUN  npm install -g yarn \
    && npm install -g gulp-cli

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
