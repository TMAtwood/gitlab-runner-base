FROM ubuntu:24.04

# Define build arguments
ARG BUILD_COMMIT
ARG BUILD_TIMESTAMP
ARG MAINTAINER="Thomas M. Atwood"
ARG VERSION="1.0.0"

LABEL maintainer=$MAINTAINER

# OCI Standard Labels
LABEL org.opencontainers.image.authors=$MAINTAINER
LABEL org.opencontainers.image.description="A base image for a GitLab Runner with minimal dependencies installed."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/tmatwood/gitlab-runner-base"
LABEL org.opencontainers.image.title="GitLab Runner Base Image"
LABEL org.opencontainers.image.url="https://hub.docker.com/repository/docker/tmatwood/gitlab-runner-base/general"
LABEL org.opencontainers.image.version=$VERSION

# Custom Labels
LABEL build.commit=$BUILD_COMMIT
LABEL build.timestamp=$BUILD_TIMESTAMP
LABEL ci.pipeline="GitLab CI/CD"
LABEL ci.usage="Base image for GitLab Runner"
LABEL com.tmatwood.department="Engineering"
LABEL com.tmatwood.project="GitLab Runner Base"


#  ██  ██      ███████ ███    ██ ██    ██     ██    ██  █████  ██████  ██  █████  ██████  ██      ███████ ███████
# ████████     ██      ████   ██ ██    ██     ██    ██ ██   ██ ██   ██ ██ ██   ██ ██   ██ ██      ██      ██
#  ██  ██      █████   ██ ██  ██ ██    ██     ██    ██ ███████ ██████  ██ ███████ ██████  ██      █████   ███████
# ████████     ██      ██  ██ ██  ██  ██       ██  ██  ██   ██ ██   ██ ██ ██   ██ ██   ██ ██      ██           ██
#  ██  ██      ███████ ██   ████   ████         ████   ██   ██ ██   ██ ██ ██   ██ ██████  ███████ ███████ ███████

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C
ENV NON_INTERACTIVE=1
ENV version=$VERSION


#  ██  ██      ███████  ██████  ██    ██ ███    ██ ██████   █████  ████████ ██  ██████  ███    ██ ███████
# ████████     ██      ██    ██ ██    ██ ████   ██ ██   ██ ██   ██    ██    ██ ██    ██ ████   ██ ██
#  ██  ██      █████   ██    ██ ██    ██ ██ ██  ██ ██   ██ ███████    ██    ██ ██    ██ ██ ██  ██ ███████
# ████████     ██      ██    ██ ██    ██ ██  ██ ██ ██   ██ ██   ██    ██    ██ ██    ██ ██  ██ ██      ██
#  ██  ██      ██       ██████   ██████  ██   ████ ██████  ██   ██    ██    ██  ██████  ██   ████ ███████

WORKDIR /home/root
USER root

# Preliminary foundation packages installed first
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends \
      adduser \
      apt-transport-https \
      apt-utils \
      axel \
      bash \
      bash-completion \
      bsdmainutils \
      build-essential \
      ca-certificates \
      cargo \
      curl \
      dkms \
      dpkg \
      git \
      gnupg \
      gnupg2 \
      jq \
      libffi-dev \
      libplist-utils \
      libssl-dev \
      libxi-dev \
      libxmu-dev \
      lsb-release \
      make \
      software-properties-common \
      systemd \
      systemd-container \
      systemd-cron \
      systemd-resolved \
      systemd-sysv \
      sudo \
      tzdata \
      ubuntu-keyring \
      ubuntu-wsl \
      uidmap \
      unzip \
      wsl-setup \
      wget \
      wslu \
      zip \
    && dpkg-reconfigure ca-certificates \
    && update-ca-certificates


#  ██  ██       ██████ ██████  ███████  █████  ████████ ███████     ██    ██ ███████ ███████ ██████  ███████
# ████████     ██      ██   ██ ██      ██   ██    ██    ██          ██    ██ ██      ██      ██   ██ ██
#  ██  ██      ██      ██████  █████   ███████    ██    █████       ██    ██ ███████ █████   ██████  ███████
# ████████     ██      ██   ██ ██      ██   ██    ██    ██          ██    ██      ██ ██      ██   ██      ██
#  ██  ██       ██████ ██   ██ ███████ ██   ██    ██    ███████      ██████  ███████ ███████ ██   ██ ███████

RUN groupadd -r dev \
    && groupadd -r docker \
    && groupadd -r gitlab-runner \
    && groupadd -r linuxbrew \
    && useradd --create-home -g dev -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "dev:dev" | chpasswd \
    && adduser dev adm \
    && adduser dev sudo \
    && useradd --create-home -g gitlab-runner -s /bin/bash gitlab-runner \
    && echo "gitlab-runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "gitlab-runner:gitlab-runner" | chpasswd \
    && adduser gitlab-runner adm \
    && adduser gitlab-runner sudo \
    && useradd --create-home -g linuxbrew -s /bin/bash linuxbrew \
    && echo "linuxbrew ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && usermod -aG docker dev \
    && mkdir -p /home/linuxbrew/.linuxbrew \
    && chown -R linuxbrew:linuxbrew /home/linuxbrew/.linuxbrew


#  ██  ██       █████  ██████  ██████      ██████  ███████ ██████   ██████  ███████
# ████████     ██   ██ ██   ██ ██   ██     ██   ██ ██      ██   ██ ██    ██ ██
#  ██  ██      ███████ ██   ██ ██   ██     ██████  █████   ██████  ██    ██ ███████
# ████████     ██   ██ ██   ██ ██   ██     ██   ██ ██      ██      ██    ██      ██
#  ██  ██      ██   ██ ██████  ██████      ██   ██ ███████ ██       ██████  ███████

RUN add-apt-repository ppa:kubescape/kubescape \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && add-apt-repository ppa:cappelikan/ppa -y \
    && add-apt-repository ppa:dotnet/backports -y \
    && apt-get -y update

RUN wget -O - https://apt.corretto.aws/corretto.key | gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list

RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg \
    && chmod 644 /etc/apt/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" | sudo tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get clean \
    && apt-get update -y

RUN apt-get remove -y 'dotnet*' 'aspnet*' 'netstandard*' \
    && echo "Package: dotnet* aspnet* netstandard*" > /etc/apt/preferences \
    && echo "Pin: origin \"packages.microsoft.com\"" >> /etc/apt/preferences \
    && echo "Pin-Priority: -10" >> /etc/apt/preferences \
    && . /etc/os-release \
    && wget https://packages.microsoft.com/config/$ID/$VERSION_ID/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update


#  ██  ██       ██████  ██ ████████      ██████  ██████  ███    ██ ███████ ██  ██████
# ████████     ██       ██    ██        ██      ██    ██ ████   ██ ██      ██ ██
#  ██  ██      ██   ███ ██    ██        ██      ██    ██ ██ ██  ██ █████   ██ ██   ███
# ████████     ██    ██ ██    ██        ██      ██    ██ ██  ██ ██ ██      ██ ██    ██
#  ██  ██       ██████  ██    ██         ██████  ██████  ██   ████ ██      ██  ██████

WORKDIR /home/dev
USER dev

# Git config
RUN git config --global core.autocrlf false \
    && git config --global core.ignorecase false \
    && git config --global credential.helper store \
    && git config --global credential.https://github.com.provider github \
    && git config --global init.defaultBranch main \
    && git config --global filter.lfs.clean 'git-lfs clean -- %f' \
    && git config --global filter.lfs.process 'git-lfs filter-process' \
    && git config --global filter.lfs.required true \
    && git config --global filter.lfs.smudge 'git-lfs smudge -- %f' \
    && git config --global http.sslVerify true \
    && git config --global safe.directory /home/linuxbrew/.linuxbrew/Homebrew

WORKDIR /home/gitlab-runner
USER gitlab-runner

# Git config
RUN git config --global core.autocrlf false \
    && git config --global core.ignorecase false \
    && git config --global credential.helper store \
    && git config --global credential.https://github.com.provider github \
    && git config --global init.defaultBranch main \
    && git config --global filter.lfs.clean 'git-lfs clean -- %f' \
    && git config --global filter.lfs.process 'git-lfs filter-process' \
    && git config --global filter.lfs.required true \
    && git config --global filter.lfs.smudge 'git-lfs smudge -- %f' \
    && git config --global http.sslVerify true \
    && git config --global safe.directory /home/linuxbrew/.linuxbrew/Homebrew

WORKDIR /home/linuxbrew
USER linuxbrew

# Git config
RUN git config --global core.autocrlf false \
    && git config --global core.ignorecase false \
    && git config --global credential.helper store \
    && git config --global credential.https://github.com.provider github \
    && git config --global init.defaultBranch main \
    && git config --global filter.lfs.clean 'git-lfs clean -- %f' \
    && git config --global filter.lfs.process 'git-lfs filter-process' \
    && git config --global filter.lfs.required true \
    && git config --global filter.lfs.smudge 'git-lfs smudge -- %f' \
    && git config --global http.sslVerify true \
    && git config --global safe.directory /home/linuxbrew/.linuxbrew/Homebrew

WORKDIR /home/root
USER root

# Git config
RUN git config --global core.autocrlf false \
    && git config --global core.ignorecase false \
    && git config --global credential.helper store \
    && git config --global credential.https://github.com.provider github \
    && git config --global init.defaultBranch main \
    && git config --global filter.lfs.clean 'git-lfs clean -- %f' \
    && git config --global filter.lfs.process 'git-lfs filter-process' \
    && git config --global filter.lfs.required true \
    && git config --global filter.lfs.smudge 'git-lfs smudge -- %f' \
    && git config --global http.sslVerify true \
    && git config --global safe.directory /home/linuxbrew/.linuxbrew/Homebrew


#  ██  ██      ██████  ██████  ███████ ██     ██
# ████████     ██   ██ ██   ██ ██      ██     ██
#  ██  ██      ██████  ██████  █████   ██  █  ██
# ████████     ██   ██ ██   ██ ██      ██ ███ ██
#  ██  ██      ██████  ██   ██ ███████  ███ ███

WORKDIR /home/linuxbrew
USER linuxbrew

ENV PATH="${PATH}:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin"

RUN git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew \
    && mkdir -p /home/linuxbrew/.linuxbrew/bin \
    && ln -s ../Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/ \
    && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) \
    && brew --version \
    && brew doctor \
    && brew upgrade \
    && sudo chown -R gitlab-runner:gitlab-runner /home/linuxbrew/.linuxbrew


#  ██  ██      ███    ██ ██    ██ ███    ███
# ████████     ████   ██ ██    ██ ████  ████
#  ██  ██      ██ ██  ██ ██    ██ ██ ████ ██
# ████████     ██  ██ ██  ██  ██  ██  ██  ██
#  ██  ██      ██   ████   ████   ██      ██

WORKDIR /home/dev
USER dev

RUN mkdir -p /home/dev/.nvm \
    && chown dev:dev -R /home/dev/.nvm

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash \
    && export NVM_DIR="/home/dev/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
    && echo 'export NVM_DIR="/home/dev/.nvm"' >> /home/dev/.bashrc \
    && echo [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && echo [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
    && echo '\nnvm install node' >> /home/dev/.bashrc \
    && echo 'nvm use node' >> /home/dev/.bashrc \
    && nvm install node \
    && nvm use node \
    && node -v \
    && npm -v \
    && npm install -g npm dep-check npm-check newman snyk

WORKDIR /home/gitlab-runner
USER gitlab-runner

RUN mkdir -p /home/gitlab-runner/.nvm \
    && chown gitlab-runner:gitlab-runner -R /home/gitlab-runner/.nvm \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash \
    && export NVM_DIR="/home/gitlab-runner/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
    && echo 'export NVM_DIR="/home/gitlab-runner/.nvm"' >> /home/gitlab-runner/.bashrc \
    && echo [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && echo [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
    && echo '\nnvm install node' >> /home/gitlab-runner/.bashrc \
    && echo 'nvm use node' >> /home/gitlab-runner/.bashrc \
    && nvm install node \
    && nvm use node \
    && node -v \
    && npm -v \
    && npm install -g npm dep-check npm-check newman snyk


#  ██  ██       ██████   ██████  ██████  ██████  ███████ ██     ██
# ████████     ██       ██    ██ ██   ██ ██   ██ ██      ██     ██
#  ██  ██      ██   ███ ██    ██ ██████  ██████  █████   ██  █  ██
# ████████     ██    ██ ██    ██ ██   ██ ██   ██ ██      ██ ███ ██
#  ██  ██       ██████   ██████  ██████  ██   ██ ███████  ███ ███

WORKDIR /home/dev
USER dev

RUN curl -sLk https://git.io/gobrew | bash  # Install gobrew \
    && export "/home/dev/.gobrew/current/bin:/home/dev/.gobrew/bin:/home/dev/go/bin:/home/dev/go/pkg:$PATH" \
    && echo 'export "/home/dev/.gobrew/current/bin:/home/dev/.gobrew/bin:/home/dev/go/bin:/home/dev/go/pkg:$PATH"' >> /home/dev/.bashrc \
    && .gobrew/bin/gobrew install latest \
    && .gobrew/bin/gobrew use latest \
    && go install github.com/codesenberg/bombardier@latest \
    && gobrew --version \
    && go --version \
    && echo '\n.gobrew/bin/gobrew install latest' >> /home/dev/.bashrc  \
    && echo '.gobrew/bin/gobrew use latest' >> /home/dev/.bashrc

WORKDIR /home/gitlab-runner
USER gitlab-runner

ENV PATH="/home/gitlab-runner/.gobrew/current/bin:/home/gitlab-runner/.gobrew/bin:/home/gitlab-runner/go/bin:/home/gitlab-runner/go/pkg:$PATH"

RUN curl -sLk https://git.io/gobrew | bash  # Install gobrew \
    && export "/home/gitlab-runner/.gobrew/current/bin:/home/gitlab-runner/.gobrew/bin:/home/gitlab-runner/go/bin:/home/gitlab-runner/go/pkg:$PATH" \
    && echo 'export "/home/gitlab-runner/.gobrew/current/bin:/home/gitlab-runner/.gobrew/bin:/home/gitlab-runner/go/bin:/home/gitlab-runner/go/pkg:$PATH"' >> /home/gitlab-runner/.bashrc \
    && .gobrew/bin/gobrew install latest \
    && .gobrew/bin/gobrew use latest \
    && go install github.com/codesenberg/bombardier@latest \
    && gobrew --version \
    && go --version \
    && echo '\n.gobrew/bin/gobrew install latest' >> /home/gitlab-runner/.bashrc  \
    && echo '.gobrew/bin/gobrew use latest' >> /home/gitlab-runner/.bashrc


#  ██  ██       ██████  ██ ████████ ██       █████  ██████      ██████  ██    ██ ███    ██ ███    ██ ███████ ██████
# ████████     ██       ██    ██    ██      ██   ██ ██   ██     ██   ██ ██    ██ ████   ██ ████   ██ ██      ██   ██
#  ██  ██      ██   ███ ██    ██    ██      ███████ ██████      ██████  ██    ██ ██ ██  ██ ██ ██  ██ █████   ██████
# ████████     ██    ██ ██    ██    ██      ██   ██ ██   ██     ██   ██ ██    ██ ██  ██ ██ ██  ██ ██ ██      ██   ██
#  ██  ██       ██████  ██    ██    ███████ ██   ██ ██████      ██   ██  ██████  ██   ████ ██   ████ ███████ ██   ██

WORKDIR /home/root
USER root

RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash \
    && apt-get install -y gitlab-runner \
    && chown -R gitlab-runner:gitlab-runner /home/linuxbrew

ENV PATH_DEV_USER="${PATH}:/home/dev/.nvm/bin"
ENV PATH_GITLAB_RUNNER_USER="${PATH}:/home/gitlab-runner/.nvm/bin"

RUN echo "export PATH=${PATH_DEV_USER}" >> /home/dev/.bashrc \
    && echo "export PATH=${PATH_GITLAB_RUNNER_USER}" >> /home/gitlab-runner/.bashrc

# Switch to the gitlab-runner user
WORKDIR /home/gitlab-runner
USER gitlab-runner

# Set the default shell
CMD ["/bin/bash"]
