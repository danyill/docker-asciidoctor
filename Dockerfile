FROM ubuntu:latest

MAINTAINER Daniel Mulholland <dan.mulholland@gmail.com>

ENV JAVA_HOME /jdk1.8.0_112
ENV PATH $PATH:$JAVA_HOME/bin:/fopub/bin
ENV BACKENDS /asciidoctor-backends
ENV GVM_AUTO_ANSWER true
ENV ASCIIDOCTOR_VERSION "1.5.6"

RUN apt-get update && apt-get install -y --no-install-recommends tar \
    curl \
    make \
    gcc \
    git \
    imagemagick \
    inkscape \
    openjdk-8-jdk \
    ruby \
    ruby-all-dev \
    rubygems \
    graphviz \
    ruby-nokogiri \
    unzip \
    zip \ 
    findutils \
    wget \
    python-all-dev \
    python-setuptools \
    zlib1g-dev \
    libjpeg-dev \
    patch \
    sudo \
  && rm -rf /var/lib/apt/lists/*

RUN  gem install --no-ri --no-rdoc asciidoctor --version $ASCIIDOCTOR_VERSION \
  && gem install --no-ri --no-rdoc asciidoctor-diagram \
  && gem install --no-ri --no-rdoc asciidoctor-epub3 --version 1.5.0.alpha.6 \
  && gem install --no-ri --no-rdoc rake \
  && gem install --no-ri --no-rdoc epubcheck --version 3.0.1 \
  && gem install --no-ri --no-rdoc kindlegen --version 3.0.1 \
  && gem install --no-ri --no-rdoc asciidoctor-pdf --version 1.5.0.alpha.13 \
  && gem install --no-ri --no-rdoc asciidoctor-confluence \
  && gem install --no-ri --no-rdoc rouge coderay pygments.rb thread_safe epubcheck kindlegen \
  && gem install --no-ri --no-rdoc slim \
  && gem install --no-ri --no-rdoc haml tilt \
  && gem install --no-ri --no-rdoc asciidoctor-revealjs
  
WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
