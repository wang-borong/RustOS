FROM archlinux

# backup mirrorlist
#RUN mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
# replace pacman mirror with ustc's 
RUN echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
RUN echo '[archlinuxcn]' >> /etc/pacman.conf
RUN echo 'Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf

# update ustc mirror repo
RUN pacman -Sy
# install qemu
RUN pacman -S --noconfirm qemu qemu-arch-extra

# install riscv64 bare-metal toolchain
RUN pacman -S --noconfirm riscv64-elf-gcc riscv64-elf-gdb riscv64-elf-binutils

# clean installation caches
RUN pacman -Scc

# install rust
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
ENV PATH="$HOME/.cargo/bin:${PATH}"
RUN cargo install cargo-binutils rustfilt cargo-xbuild
RUN rustup toolchain install nightly-2021-10-10 && \
    rustup component add rust-src llvm-tools-preview && \
    rustup target add riscv64gc-unknown-none-elf

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8  \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8