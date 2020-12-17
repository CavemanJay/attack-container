FROM archlinux:latest

ENV TERM=xterm

RUN pacman -Syu --noconfirm

WORKDIR /root/initial_install

#  Install blackarch
RUN curl -O https://blackarch.org/strap.sh && \
echo d062038042c5f141755ea39dbd615e6ff9e23121 strap.sh | sha1sum -c && \
chmod +x ./strap.sh && \
./strap.sh

WORKDIR /root

RUN pacman -S git \
--noconfirm

RUN git clone https://github.com/sindresorhus/pure.git .zsh/pure

RUN echo "./dotfiles" >> .gitignore && \
git clone --bare https://github.com/JayCuevas/dotfiles.git .dotfiles

COPY cfg /usr/bin/
RUN chmod +x /usr/bin/cfg
RUN cfg checkout
RUN cfg config --local status.showUntrackedFiles no
RUN rm -vf .gitignore
COPY command*.zsh /tmp/
RUN cat /tmp/command-not-found.zsh >> /root/.zshrc && mkdir -p /root/.cache/zsh
RUN pacman -S zsh zsh-syntax-highlighting zsh-autosuggestions --noconfirm
RUN pacman -S neovim exa thefuck neofetch --noconfirm
RUN pacman -S mlocate --noconfirm
RUN updatedb
RUN pacman -Fy
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
RUN pacman -S metasploit wfuzz nmap --noconfirm

CMD zsh