FROM ubuntu:24.04

# Define build arguments
ARG BUILD_COMMIT
ARG BUILD_TIMESTAMP
ARG MAINTAINER="Thomas M. Atwood <tom@tmatwood.com>"
ARG VERSION="1.0.0"

LABEL maintainer=$MAINTINER

# OCI Standard Labels
# LABEL org.opencontainers.image.documentation=""
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

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \    
        ca-certificates \
        curl

# Install GitLab Runner
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash \
    && apt-get install -y gitlab-runner
