FROM ubuntu:focal

RUN apt-get update -y
RUN apt-get install -y build-essential
RUN apt-get install -y curl
RUN apt-get install -y sudo
RUN apt-get install -y shellcheck
RUN apt-get install -y ruby
RUN apt-get install -y git
RUN apt-get install -y openssh-client
RUN apt-get install -y locales

RUN sed -i 's/%admin ALL=(ALL) ALL/%admin ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

RUN sudo locale-gen en_US
RUN sudo locale-gen en_US.UTF-8
RUN sudo locale-gen en_GB
RUN sudo locale-gen en_GB.UTF-8
RUN sudo update-locale LANG=en_GB

RUN groupadd admin

RUN useradd -G admin -m -p '' luke

USER luke

RUN mkdir ~/.config
COPY --chown=luke:admin . /home/luke/.config/

WORKDIR /home/luke/.config

RUN git remote remove origin
RUN git remote add origin https://github.com/LukeChannings/.config.git

RUN shellcheck -s bash ./install*

RUN ./install

WORKDIR /home/luke

ENTRYPOINT [ "/home/linuxbrew/.linuxbrew/bin/fish" ]
