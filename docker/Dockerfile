FROM ailispaw/ubuntu-essential:14.04-nodoc

WORKDIR /src
VOLUME /src

RUN apt-get -q update && \
    apt-get -q -y install --no-install-recommends build-essential make libyaml-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
