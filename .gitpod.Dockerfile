FROM gitpod/workspace-full

USER root


### Helm ###
RUN curl -fsSL https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz \
    | tar -xzvC /usr/local/bin --strip-components=1 \
    && helm completion bash > /usr/share/bash-completion/completions/helm

### kubernetes ###
RUN mkdir -p /usr/local/kubernetes/ && \
    curl -fsSL https://github.com/kubernetes/kubernetes/releases/download/v1.20.9/kubernetes.tar.gz \ 
    | tar -xzvC /usr/local/kubernetes/ --strip-components=1 && \
    KUBERNETES_SKIP_CONFIRM=true /usr/local/kubernetes/cluster/get-kube-binaries.sh && \
    chown gitpod:gitpod -R /usr/local/kubernetes
ENV PATH=$PATH:/usr/local/kubernetes/cluster/:/usr/local/kubernetes/client/bin/

RUN curl -o /usr/bin/kubectx https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && chmod +x /usr/bin/kubectx \
 && curl -o /usr/bin/kubens  https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens  && chmod +x /usr/bin/kubens

# yq - jq for YAML files
RUN cd /usr/bin && curl -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 > yq && chmod +x yq

#az for aks
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# install gettext for envsubst
RUN apt-get update
RUN apt-get install -y gettext-base

USER gitpod
