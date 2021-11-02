FROM archlinux

# backup mirrorlist
#RUN mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
# replace pacman mirror with ustc's 
RUN echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist; \
    echo '[archlinuxcn]' >> /etc/pacman.conf; \
    echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf; \
    pacman -Syu --noconfirm gcc wget \
    qemu qemu-arch-extra \
    riscv64-elf-gcc riscv64-elf-gdb riscv64-elf-binutils; \
    pacman -Scc; \
    locale-gen en_US.UTF-8; \
    useradd -m rustenv && \
    mkdir -p /home/rustenv/workdir; \
    chown -R rustenv:rustenv /home/rustenv; \
    mkdir /home/rustenv/.gdbinit.d

ENV LANG=en_US.UTF-8  \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

USER rustenv
COPY auto /home/rustenv/.gdbinit.d/auto

# install rust
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup \
    RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static

RUN wget -P ~ git.io/.gdbinit; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > ~/rustup.sh && \
    sh ~/rustup.sh -y --default-toolchain nightly-2021-10-10 \
    -c rust-src llvm-tools-preview \
    -t riscv64gc-unknown-none-elf \
    && rm ~/rustup.sh; \
    echo 'export PATH="$HOME/.cargo/bin:${PATH}"' >> ~/.bashrc; \
    source $HOME/.cargo/env && ~/.cargo/bin/cargo install cargo-binutils rustfilt cargo-xbuild
