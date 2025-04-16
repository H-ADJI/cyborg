FROM archlinux:latest
LABEL maintainer="H-ADJI <https://github.com/H-ADJI>"

# Set noninteractive mode
ENV TERM xterm-256color
ENV LANG en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8

RUN pacman -Syu --noconfirm \
  && pacman -S --noconfirm curl base-devel

ARG USER=test-user
ARG PASS
RUN useradd -m ${USER} &&  echo "${USER}:${PASS}" | chpasswd 
RUN echo "${USER} ALL=(ALL) ALL" >> /etc/sudoers
# Switch to the non-root user
USER ${USER}

# Set the working directory
WORKDIR /home/${USER}
RUN echo "alias dotinstall='curl -SL https://raw.githubusercontent.com/H-ADJI/cyborg/refs/heads/master/init.sh | sh'" >> .bashrc
CMD ["/bin/bash"]
