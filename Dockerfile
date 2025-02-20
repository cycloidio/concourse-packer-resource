FROM python:3.9-alpine
ENV PYTHONUNBUFFERED=1
WORKDIR /opt/resource
CMD ["/bin/sh"]

RUN pip3 --no-cache-dir install --upgrade pip

ARG PACKER_VERSION=0.0.0

RUN set -x && \
    apk add --update \
        curl \
        git \
        gnupg \
        openssh \
        && \
    curl https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS.sig > packer_${PACKER_VERSION}_SHA256SUMS.sig && \
    curl https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS > packer_${PACKER_VERSION}_SHA256SUMS && \
    curl https://keybase.io/hashicorp/pgp_keys.asc > hashicorp.pgp.asc && \
    gpg --import hashicorp.pgp.asc && \
    gpg --verify packer_${PACKER_VERSION}_SHA256SUMS.sig packer_${PACKER_VERSION}_SHA256SUMS && \
    curl https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip > packer_${PACKER_VERSION}_linux_amd64.zip && \
    cat packer_${PACKER_VERSION}_SHA256SUMS | grep packer_${PACKER_VERSION}_linux_amd64.zip | sha256sum -c && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin && \
    rm -f packer_${PACKER_VERSION}_SHA256SUMS.sig \
      packer_${PACKER_VERSION}_SHA256SUMS \
      packer_${PACKER_VERSION}_linux_amd64.zip \
      hashicorp.pgp.asc

# COPY requirements.txt /app/requirements.txt

# RUN pip3 --no-cache-dir install -r /app/requirements.txt

# copy scripts
COPY \
  bin/check \
  bin/in \
  bin/out \
  /opt/resource/

# copy library files
COPY \
  lib/__init__.py \
  lib/concourse.py \
  lib/io.py \
  lib/log.py \
  lib/packer.py \
  /opt/resource/lib/
