FROM kalilinux/kali-rolling
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y kali-linux-headless
WORKDIR /my_workspace
# RUN git clone https://github.com/danielmiessler/SecLists.git
RUN git clone https://github.com/kkrypt0nn/wordlists.git
CMD ["bash"]
