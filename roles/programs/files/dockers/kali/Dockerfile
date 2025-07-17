FROM kalilinux/kali-rolling
ENV DEBIAN_FRONTEND=noninteractive

# This installs full suite of kali linux tools (takes a solid ~30mins and produces a 10GB image...)
# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y kali-linux-headless

# Install a subset of tools from kali repositories instead of the full kali suite
RUN apt-get update && apt-get install -y git curl wget hydra
WORKDIR /my_workspace

# Clone some common wordlists to use with hydra
# RUN git clone https://github.com/danielmiessler/SecLists.git
RUN git clone https://github.com/kkrypt0nn/wordlists.git
# Also, handy hydra reference: https://github.com/gnebbia/hydra_notes

CMD ["bash"]
