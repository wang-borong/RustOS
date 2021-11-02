
DOCKER_IMAGE := rustos
DOCKER_PATH := /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DOCKER_CMD := docker run -t --rm -e PATH=$(DOCKER_PATH):/home/rustenv/.cargo/bin -v $(PWD):/home/rustenv/workdir -w /home/rustenv/workdir
DOCKER_CMD_I := $(DOCKER_CMD) -i

DOCKER_QEMU := $(DOCKER_CMD_I)
DOCKER_TOOLS := $(DOCKER_CMD)
CARGO := $(DOCKER_TOOLS) cargo
RUST_OBJCOPY := $(DOCKER_TOOLS) rust-objcopy --binary-architecture=riscv64
RUST_OBJDUMP := $(DOCKER_TOOLS) rust-objdump --arch-name=riscv64

KERNEL_FILE := target/riscv64gc-unknown-none-elf/debug/kernel
KERNEL_BIN := kernel.bin

.PHONY: all clean asm
all: $(KERNEL_BIN)

$(KERNEL_BIN): $(KERNEL_FILE)
	@$(RUST_OBJCOPY) $< --strip-all -O binary $@

$(KERNEL_FILE):
	@$(CARGO) build --target=riscv64gc-unknown-none-elf

QEMU_BINARY := qemu-system-riscv64
MACH := virt
CPU := rv64
CPUS := 4
MEM := 128M
QEMUOPTS := -machine $(MACH) -cpu $(CPU) -smp $(CPUS) -m $(MEM) \
			-nographic -serial mon:stdio -bios default -device loader,file=$(KERNEL_BIN),addr=0x80200000

qemu: $(KERNEL_BIN)
	@$(DOCKER_QEMU) $(DOCKER_IMAGE) $(QEMU_BINARY) $(QEMUOPTS)

qemudbg: $(KERNEL_BIN)
	@$(DOCKER_QEMU) $(DOCKER_IMAGE) $(QEMU_BINARY) $(QEMUOPTS) -d int -D qemu.log

qemuasm: $(KERNEL_BIN)
	@$(DOCKER_QEMU) $(DOCKER_IMAGE) $(QEMU_BINARY) $(QEMUOPTS) -d int,in_asm -D qemu.log

# we should use host tools here
qemugdb: $(KERNEL_BIN)
	@echo Start qemu gdb debug
	@$(DOCKER_QEMU) --name qemugdb $(DOCKER_IMAGE) $(QEMU_BINARY) $(QEMUOPTS) -S -gdb tcp::1234

asm: $(KERNEL_FILE)
	@$(RUST_OBJDUMP) $< > kernel.asm

rungdb: $(KERNEL_FILE)
	@python3 ../tools/run_remote_gdb.py -k $(KERNEL_FILE)

clean:
	@$(CARGO) clean
	@$(RM) kernel.bin kernel.asm qemu.log
