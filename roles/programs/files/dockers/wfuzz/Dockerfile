FROM ghcr.io/xmendez/wfuzz

RUN apk add --no-cache git
WORKDIR wfuzz/

# Clone some common wordlists to use with wfuzz
# RUN git clone https://github.com/danielmiessler/SecLists.git
RUN git clone https://github.com/kkrypt0nn/wordlists.git

CMD ["/bin/sh"]
