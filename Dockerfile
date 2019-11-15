FROM ubuntu:latest

MAINTAINER Daniel Mulholland <dan.mulholland@gmail.com>

ENV JAVA_HOME /jdk1.8.0_112
ENV PATH $PATH:$JAVA_HOME/bin:/fopub/bin
ENV BACKENDS /asciidoctor-backends
ENV GVM_AUTO_ANSWER true
ENV ASCIIDOCTOR_VERSION "2.0.10"

# Set the locale
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

# Now let's get cracking

RUN apt-get update && apt-get install -y --no-install-recommends \
    bison \
    build-essential \
    cmake \
    curl \
    findutils \
    fonts-lyx \
    flex \
    gcc \
    git \
    gnupg2 \
    graphviz \
    imagemagick \
    inkscape \
    libcairo2-dev \
    libffi-dev \
    libgdk-pixbuf2.0-dev \
    libgif-dev \
    libgit2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libssl-dev \
    libtool \
    libxml2-dev \
    make \
    openjdk-8-jdk \
    pkg-config \
    pandoc \
    patch \
    plantuml \
    python3 \
    python3-pip \
    python-all-dev \
    python-setuptools \
    python3-setuptools \
    ruby \
    ruby-all-dev \
    rubygems \
    ruby-nokogiri \
    sudo \
    tar \
    unzip \
    zip \
    wget \
    zlib1g-dev

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN  gem install --no-ri --no-rdoc asciidoctor --version $ASCIIDOCTOR_VERSION \
  && gem install --no-ri --no-rdoc asciidoctor-pdf --version 1.5.0.beta.5 \
  && gem install --no-ri --no-rdoc asciidoctor-diagram \
  && gem install --no-ri --no-rdoc asciidoctor-katex \
  && gem install --no-ri --no-rdoc asciidoctor-mathematical \
  && gem install --no-ri --no-rdoc asciidoctor-epub3 --version 1.5.0.alpha.9 \
  && gem install --no-ri --no-rdoc rake \
  && gem install --no-ri --no-rdoc epubcheck --version 3.0.1 \
  && gem install --no-ri --no-rdoc kindlegen --version 3.0.1 \
  && gem install --no-ri --no-rdoc asciidoctor-confluence \
  && gem install --no-ri --no-rdoc bundler \
  && gem install --no-ri --no-rdoc rouge coderay pygments.rb thread_safe epubcheck kindlegen \
  && gem install --no-ri --no-rdoc slim \
  && gem install --no-ri --no-rdoc haml tilt \
  && gem install --no-ri --no-rdoc asciidoctor-revealjs \
  && gem install --no-ri --no-rdoc rugged \
  && gem install --no-ri --no-rdoc asciidoctor-rouge \
  && gem install --no-ri --no-rdoc fastimage \
  && gem install --no-ri --no-rdoc html-proofer \
  && gem install --no-ri --no-rdoc asciidoctor-question \
  && gem install --no-ri --no-rdoc specific_install



ARG TEST=STARTFROMHERE1

RUN gem specific_install -l https://gitlab.com/danyill/pdf-hyperlinking-play -b release_v0.2.0

RUN pip3 install actdiag blockdiag seqdiag nwdiag

RUN git clone https://github.com/danyill/htmldiff \
    && cd htmldiff \
    && python3 setup.py sdist \
    && python3 setup.py install

# Install puppeteer so it's available in the container.
RUN npm config set user 0 \
    && npm config set unsafe-perm true \
    && npm install -g yarn  \
    && npm install -g puppeteer \    
    && npm install -g @asciidoctor/core asciidoctor asciidoctor-pdf asciidoctor-cli asciidoctor-katex gulp-cli vega vega-cli vega-lite vega-embed

WORKDIR /documents
VOLUME /documents

CMD ["/bin/bash"]
