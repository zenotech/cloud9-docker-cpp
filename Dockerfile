FROM ubuntu:15.10

# Settings
ENV C9_USER=""
ENV C9_PASSWORD=""

# Install dependencies and common packages
RUN apt-get update && apt-get -y upgrade \
 && apt-get install -y git tmux bash curl wget build-essential python build-essential sudo \
    llvm-3.7 llvm-3.7-dev llvm-3.7-runtime libclang-3.7-dev libclang1-3.7 clang-format-3.7 \
    autoconf automake cmake gdb libtool m4 valgrind && apt-get clean

# Install dockerize and dumb-init
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.2.0.tar.gz && rm *.gz \
 && wget https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64 \
 && mv dumb-init_1.0.0_amd64 /usr/local/bin/dumb-init \
 && chmod +x /usr/local/bin/dumb-init

# Install cloud9
RUN git clone https://github.com/c9/core.git c9sdk && cd c9sdk \
 && bash scripts/install-sdk.sh
RUN rm /bin/sh && ln /bin/bash /bin/sh

# Install the C++ plugin
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash
RUN source ~/.nvm/nvm.sh && nvm install v0.12 && nvm alias default v0.12 && cd c9sdk && npm install && npm install clang_tool && npm install -g c9 \
 && mkdir ~/.c9/plugins && git clone https://github.com/invokr/c9.ide.language.cpp ~/.c9/plugins/c9.ide.language.cpp \
 && cd ~/.c9/plugins/c9.ide.language.cpp && c9 build && mkdir /workspace

# Add config and scripts
ADD config/settings-state /settings-state
ADD config/settings-project /settings-project
ADD scripts/init.sh /init.sh
ADD scripts/run-c9.sh /run-c9.sh.tpl

# Run c9
EXPOSE 8080
CMD ["/init.sh"]
