FROM ubuntu:24.04
LABEL maintainer="H-ADJI <https://github.com/H-ADJI>"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl sudo

# Create a non-root user to run Ansible commands
ARG USER=khalil
ARG PASS
RUN useradd -m ${USER} &&  echo "${USER}:${PASS}" | chpasswd 
RUN usermod -aG sudo ${USER}
# Switch to the non-root user
USER ${USER}

# Set the working directory
WORKDIR /home/${USER}

# If you want to keep the container running for interactive use
CMD ["/bin/bash"]
