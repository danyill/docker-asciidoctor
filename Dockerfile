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
    findutils \
    wget \
    python-all-dev \
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

RUN mkdir $BACKENDS \
  && (curl -LkSs https://api.github.com/repos/asciidoctor/asciidoctor-backends/tarball | tar xfz - -C $BACKENDS --strip-components=1) \
  && wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -O - | python \
  && easy_install "blockdiag[pdf]" \
  && easy_install seqdiag \
  && easy_install actdiag \
  && easy_install nwdiag \
  && (curl -s get.sdkman.io | bash) \
  && /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh" \
  && /bin/bash -c "echo sdkman_auto_answer=true > ~/.sdkman/etc/config" \
  && /bin/bash -c -l "sdk install lazybones"

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
