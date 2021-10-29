

DOCKER_IMAGE := rustos
DOCKER_PATH := /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
DOCKER_CMD := docker run -t --rm -e PATH=$(DOCKER_PATH):/home/rustenv/.cargo/bin -v $(PWD):/home/rustenv/workdir -w /home/rustenv/workdir
DOCKER_CMD_I := $(DOCKER_CMD) -i

DOCKER_QEMU := $(DOCKER_CMD_I) $(DOCKER_IMAGE)
DOCKER_TOOLS := $(DOCKER_CMD) $(DOCKER_IMAGE)


KERNEL_BIN := kernel.elf

.PHONY: docker all clean
all: $(KERNEL_BIN)

$(KERNEL_BIN): 
	$(RISCVCC) $(CFLAGS) -T$(KERNEL_LDS) -o $@ $<


QEMU_BINARY := qemu-system-riscv64
MACH := virt
CPU := rv64
CPUS := 4
MEM := 128M
QEMUOPTS := -machine $(MACH) -cpu $(CPU) -smp $(CPUS) -m $(MEM) \
			-nographic -serial mon:stdio -bios none -kernel $(KERNEL_BIN)
qemu:
	@$(DOCKER_QEMU) $(QEMU_BINARY) $(QEMUOPTS)

qemudbg:
	@$(DOCKER_QEMU) $(QEMU_BINARY) $(QEMUOPTS) -d int -D qemu.log

qemuasm:
	@$(DOCKER_QEMU) $(QEMU_BINARY) $(QEMUOPTS) -d int,in_asm -D qemu.log

qemugdb:
	@$(DOCKER_QEMU) $(QEMU_BINARY) $(QEMUOPTS) -S -gdb tcp::1234
