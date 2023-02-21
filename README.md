# RStudio in Devcontainer


## Introduction to Development Containers and Codespaces

If you are familiar with Visual Studio Code, the concept of devcontainer in VS Code, and Codespaces, skip to the next section.

If the concept of containers are new to you, I recommend reading the section on [containers in data science](https://the-turing-way.netlify.app/reproducible-research/renv/renv-containers.html) context in [The Turing Way handbook](https://the-turing-way.netlify.app/welcome.html). 

[Devcontainer in Visual Studio Code](https://code.visualstudio.com/docs/devcontainers/containers) allows VS Code to deploy and connect to a container instance and provide seamless access to software tools inside the container. [GitHub Codespaces](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers) is a way to start a web-based VS Code interface and connect to a container running on GitHub's infrastructure.

Devcontainer specification are given in file `.devcontainer/devcontainer.json`. The container images are [fully customizable](https://code.visualstudio.com/docs/devcontainers/create-dev-container#_path-to-creating-a-dev-container) using `Dockerfile` and `docker-compose.yml` that also live in `.devcontainer` directory.

## What this repository provides

Following files in this repository are the essential pieces for running RStudio in development containers.

* [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json)
* [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile)
* [`.devcontainer/docker-compose.yml`](.devcontainer/docker-compose.yml)


### `.devcontainer/devcontainer.json`

[`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json) is the main configuration file for specifying a devcontainer.

See here for the [documentation on `devcontiner.json`](https://containers.dev/implementors/json_reference/).

### `.devcontainer/Dockerfile`

[`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) specifies the content of the container image. Modifying this file will customize your devcontainer.

As the first line suggests, the `Dockerfile` extends a [`tidyverse` image](https://rocker-project.org/images/versioned/rstudio.html) from Rocker project. The additions in the `Dockerfile` are:

- Minimal python installation from [Jupyter project's base-notebook image](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-base-notebook). This is mostly to install `radian` package for R terminal.
- System libraries, `curl` and `libxt6` (to remove a warning message)
- [Quarto](https://quarto.org) publishing system and `tinytex`
- Other packages to support VS Code extensions for R and Rmarkdown: `languageserver`, 'httpgd', 'ManuelHentschel/vscDebugger`.

For example, adding the folliwng line installs an R package, `devtools`:
```Dockerfile
RUN install2.r devtools
```
Adding the following line installs a Python package using `pip`:
```Dockerfile
RUN pip install pyjoke
```
Adding the following lines install a system package for Ubuntu (underlying OS for the base image being used).
```Dockerfile
RUN apt update && \
    apt install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*
```
Reference: [installing system packages](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run) in `Dockerfile`.

### `.devcontainer/docker-compose.yml`

[`.devcontainer/docker-compose.yml`](.devcontainer/docker-compose.yml) specifies container initialization and sets environment variables.

In our usage, the password for accessing RStudio is set in this file.
```yml
environment:
    PASSWORD: 'changeme'
```
Environmental variables of [rocker container image are specified](https://rocker-project.org/images/versioned/rstudio.html#environment-variables).

Modifying `changeme` will set a custom password for Rstudio; however, doing this via the `docker-file.yml` would expose the custom password if your repository is private. My suggestion is to change the password right away when you start a new container: go to RStudio, open a terminal session, type `passwd` to interactively set a new password.