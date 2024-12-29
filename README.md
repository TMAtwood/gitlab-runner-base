# GitLab Runner Base Image

[![Build Status](https://github.com/tmatwood/gitlab-runner-base/actions/workflows/build.yml/badge.svg)](https://github.com/tmatwood/gitlab-runner-base/actions)

This project provides a minimal base Docker image for a GitLab Runner, pre-configured with essential tools and dependencies. The image is designed to simplify the setup of GitLab CI/CD pipelines.

## Table of Contents

- [Features](#features)
- [Usage](#usage)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)

## Features

- Based on Ubuntu 24.04
- Essential tools pre-installed:
  - `apt-transport-https`
  - `ca-certificates`
  - `curl`
  - `gnupg`
  - `sudo`
- GitLab Runner pre-installed
- Configured user and group:
  - `gitlab-runner` user with passwordless sudo access
- OCI-compliant labels for metadata
- Built with security and minimal dependencies in mind

## Usage

### Pull the Docker Image

You can pull the pre-built image from Docker Hub:

```bash
docker pull tmatwood/gitlab-runner-base:latest
```

### Build Locally

To build the image locally, clone this repository and run:

```bash
docker build -t gitlab-runner-base .
```

### Run the Container

Run the container with the default shell:

```bash
docker run -it --rm gitlab-runner-base
```

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/tmatwood/gitlab-runner-base.git
   cd gitlab-runner-base
   ```

2. Build the image:
   ```bash
   docker build -t gitlab-runner-base .
   ```

3. Run the container:
   ```bash
   docker run -it gitlab-runner-base
   ```

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push your branch to your fork.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE.md) file for details.

© 2024 Thomas M. Atwood, CFA. Licensed under the MIT License.

---

For any questions, feel free to open an issue in the repository.
