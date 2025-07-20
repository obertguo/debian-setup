FROM vanhauser/hydra:latest
ENV DEBIAN_FRONTEND=noninteractive

# Hacky workaround to use root user since an explicit root user is not present
USER 0:0
RUN apt-get -y update && apt-get -y install git
WORKDIR /my_workspace

# Clone some common wordlists to use with hydra
# RUN git clone https://github.com/danielmiessler/SecLists.git
RUN git clone https://github.com/kkrypt0nn/wordlists.git

# Hydra's Dockerfile clones some usernames and password wordlists as well, so we'll move them here to our workspace
# https://github.com/vanhauser-thc/thc-hydra/blob/master/Dockerfile
RUN mv /opt/usernames /my_workspace && mv /opt/passwords /my_workspace

# Use an unprivileged user
USER 10001:10001

# Enable bash terminal color support
ENV TERM=xterm-256color
RUN echo "PS1='\[\e[0;32m\]${debian_chroot:+($debian_chroot)}\[\e[1;32m\]\u\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '" >> ~/.bashrc

# Hydra's default entrypoint, but we're gonna reset it so that we can use the container interactively
# ENTRYPOINT ["hydra"]
ENTRYPOINT []
CMD ["bash"]
