FROM ubuntu:24.04
LABEL maintainer="H-ADJI <https://github.com/H-ADJI>"
# Set noninteractive mode
ENV TERM xterm-256color
ENV LANG en_US.UTF-8
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
RUN echo "alias dotinstall='curl -SL https://raw.githubusercontent.com/H-ADJI/cyborg/refs/heads/master/install.sh | sh'" >> .bashrc
CMD ["/bin/bash"]
