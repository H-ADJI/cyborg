FROM archlinux:latest
LABEL maintainer="H-ADJI <https://github.com/H-ADJI>"

# Set noninteractive mode
ENV TERM xterm-256color
ENV LANG en_US.UTF-8

RUN pacman -Syu --noconfirm \
  && pacman -S --noconfirm git curl sudo base-devel

# Create a non-root user to run Ansible commands
ARG USER=khalil
ARG PASS
RUN useradd -m ${USER} &&  echo "${USER}:${PASS}" | chpasswd 
RUN echo "${USER} ALL=(ALL) ALL" >> /etc/sudoers
# Switch to the non-root user
USER ${USER}

# Set the working directory
WORKDIR /home/${USER}

CMD ["/bin/bash"]
