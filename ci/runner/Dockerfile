FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TERRAFORM_VERSION=1.10.5
ARG KUBECTL_VERSION=v1.30.8
ARG HELM_VERSION=v3.19.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl unzip git jq python3 python3-pip bash \
    && rm -rf /var/lib/apt/lists/*

# Ansible
RUN pip3 install --no-cache-dir ansible==10.7.0

# AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
  && unzip -q /tmp/awscliv2.zip -d /tmp \
  && /tmp/aws/install \
  && rm -rf /tmp/aws /tmp/awscliv2.zip

# Terraform
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /tmp/terraform.zip \
  && unzip -q /tmp/terraform.zip -d /usr/local/bin \
  && rm -f /tmp/terraform.zip

# kubectl
RUN curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl

# helm
RUN curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tgz \
  && tar -xzf /tmp/helm.tgz -C /tmp \
  && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm \
  && rm -rf /tmp/helm.tgz /tmp/linux-amd64

# docker client (for talking to dind)
RUN apt-get update && apt-get install -y --no-install-recommends docker.io \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

