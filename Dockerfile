FROM ubuntu:focal

SHELL ["/bin/bash", "-c"]

RUN apt-get update -y
RUN apt-get install -y build-essential curl file git locales sudo

RUN sed -i 's/%admin ALL=(ALL) ALL/%admin ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

RUN sudo locale-gen en_US
RUN sudo locale-gen en_US.UTF-8
RUN sudo locale-gen en_GB
RUN sudo locale-gen en_GB.UTF-8
RUN sudo update-locale LANG=en_GB

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN groupadd admin

RUN useradd -G admin -m -p '' luke

USER luke

RUN mkdir ~/.config
COPY --chown=luke:admin . /home/luke/.config/

WORKDIR /home/luke/.config

RUN git remote remove origin
RUN git remote add origin https://github.com/LukeChannings/.config.git

RUN ./install

RUN sudo apt-get remove -y build-essential
RUN sudo apt-get autoremove -y

WORKDIR /home/luke

ENTRYPOINT [ "/usr/bin/fish" ]
