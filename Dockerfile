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

RUN export LANG=en_GB.UTF-8
RUN export LC_ALL=en_GB
RUN sudo locale-gen en_GB
RUN sudo locale-gen en_GB.UTF-8
RUN sudo update-locale LANG=en_GB

RUN groupadd admin

RUN useradd -G admin -m -p '$6$WRefMr4fwYjaUdKZ$2TMkPsPTbJY4FVGnkNup7BdXVR2rK7cTWWhcA/X14UviQsObXI7q0YuWQQ4rxUCmvCAq2sowW/eXJ7/Vl2aeY/' luke

USER luke

RUN mkdir ~/.config
COPY --chown=luke:admin . /home/luke/.config/

WORKDIR /home/luke/.config

RUN git remote remove origin
RUN git remote add origin https://github.com/LukeChannings/.config.git

RUN shellcheck -s bash ./install*

RUN ./install

WORKDIR /home/luke

ENTRYPOINT ["/bin/bash"]
