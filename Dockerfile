FROM codercom/code-server:2.1697-vsc1.39.2

RUN sudo apt-get update
RUN sudo apt-get install -y vim wget curl iputils-ping build-essential

# prepare
RUN mkdir /home/coder/compiler
ENV COMPILER_PATH /home/coder/compiler

ENV CONDA_VERSION 4.7.12.1
# miniconda3
RUN wget -O /tmp/miniconda3.sh "https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh" && \
    chmod a+x /tmp/miniconda3.sh && /tmp/miniconda3.sh -p ${COMPILER_PATH}/miniconda3 -b

# miniconda2
# Something depend on python2
RUN wget -O /tmp/miniconda2.sh "https://repo.anaconda.com/miniconda/Miniconda2-${CONDA_VERSION}-Linux-x86_64.sh" && \
    chmod a+x /tmp/miniconda2.sh && /tmp/miniconda2.sh -p ${COMPILER_PATH}/miniconda2 -b

# golang
ENV GOLANG_VERSION 1.13.5
RUN wget -O /tmp/go.tgz "https://studygolang.com/dl/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz" && \
    mkdir ${COMPILER_PATH}/go && tar --extract --file /tmp/go.tgz --strip-components 1 --directory ${COMPILER_PATH}/go

# node
ENV NODE_VERSION v10.16.3
RUN wget -O /tmp/node.tgz "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" && \
    mkdir ${COMPILER_PATH}/node && tar --extract --file /tmp/node.tgz --strip-components 1 --directory ${COMPILER_PATH}/node

# docker client
ENV DOCKER_VERSION 18.09.8
# If you're using kubernetes you should run a docker:dind container in the same pod.
ENV DOCKER_HOST='tcp://localhost:2375'
RUN wget -O /tmp/docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz"
RUN sudo tar --extract --file /tmp/docker.tgz --strip-components 1 --directory /usr/local/bin/

# setup
ENV PATH=${COMPILER_PATH}/miniconda3/bin:${COMPILER_PATH}/miniconda2/bin:${COMPILER_PATH}/go/bin:${COMPILER_PATH}/node/bin:${PATH}
RUN python --version && python2 --version && go version && node --version && dockerd --version && docker --version

# clean
RUN rm -rf /tmp/*

# to mount ssh key
RUN mkdir /home/coder/.ssh

# install ssh-server
RUN sudo apt-get install -y openssh-server

# entrypoint
COPY entrypoint.py /entrypoint/
ENTRYPOINT ["python", "/entrypoint/entrypoint.py"]