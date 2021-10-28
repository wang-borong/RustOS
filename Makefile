
KERNEL_BIN := kernel.elf

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
	$(QEMU_BINARY) $(QEMUOPTS)

qemudbg:
	$(QEMU_BINARY) $(QEMUOPTS) -d int -D qemu.log

qemuasm:
	$(QEMU_BINARY) $(QEMUOPTS) -d int,in_asm -D qemu.log

qemugdb:
	$(QEMU_BINARY) $(QEMUOPTS) -S -gdb tcp::1234
