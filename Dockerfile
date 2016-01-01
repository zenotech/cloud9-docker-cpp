FROM ubuntu:15.10

# Install C9
RUN apt-get update && apt-get -y upgrade && apt-get install -y git tmux bash curl wget build-essential python build-essential sudo
RUN git clone https://github.com/c9/core.git c9sdk
RUN cd c9sdk && bash scripts/install-sdk.sh
RUN rm /bin/sh && ln /bin/bash /bin/sh

# Install the C++ plugin
RUN apt-get install -y llvm-3.7 llvm-3.7-dev llvm-3.7-runtime libclang-3.7-dev libclang1-3.7 clang-format-3.7
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash
RUN source ~/.nvm/nvm.sh && nvm install v0.12 && nvm alias default v0.12 && cd c9sdk && npm install clang_tool && npm install -g c9 && \
    mkdir ~/.c9/plugins && git clone https://github.com/invokr/c9.ide.language.cpp ~/.c9/plugins/c9.ide.language.cpp && \
    cd ~/.c9/plugins/c9.ide.language.cpp && c9 build
RUN mkdir /workspace

# Run c9
EXPOSE 8080
ADD settings-state /settings-state
ADD settings-project /settings-project
ADD init.sh /init.sh

CMD ["/bin/bash", "-c", "/init.sh"]
