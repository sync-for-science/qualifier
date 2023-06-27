# Build DBT (based on https://raw.githubusercontent.com/dbt-labs/dbt-core/main/docker/Dockerfile)

# Top level build args
ARG build_for=linux/amd64

FROM --platform=$build_for python:3.10.7-slim-bullseye as base

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    git \
    curl \
    gdebi \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Env vars
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Update python
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir

# dbt
COPY requirements-dbt.txt /usr/app/requirements-dbt.txt
WORKDIR /usr/app
RUN python -m pip install --no-cache-dir -r requirements-dbt.txt

# Quarto
RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

RUN quarto install tinytex

COPY requirements-jupyter.txt /usr/app/requirements-jupyter.txt
RUN python -m pip install --no-cache-dir -r requirements-jupyter.txt

# Add qualifier files
COPY ./dbt ./dbt
COPY ./reports ./reports

# Clean up notebooks if needed
RUN python -m pip install --no-cache-dir nbstripout
RUN nbstripout ./reports/characterization.ipynb
RUN nbstripout ./reports/quality.ipynb

VOLUME ["/usr/app/data"]

WORKDIR /usr/app/dbt
RUN dbt clean