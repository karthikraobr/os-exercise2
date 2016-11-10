CFLAGS = -m32 -Isrc -Wall -Wextra -nostdlib -nostartfiles -nodefaultlibs -fno-builtin
LDFLAGS = -Tlink.ld -m elf_i386

.PHONY: clean run all

all: kernel grub.img
	sudo kpartx -as grub.img
	mkdir -p mnt
	sudo mount /dev/mapper/loop0p1 mnt
	sudo cp kernel mnt/boot/
	sudo umount mnt
	sudo kpartx -d grub.img

kernel: boot.o main.o
	ld $(LDFLAGS) -o kernel $^

boot.o: boot.s

main.o: main.c

clean:
	rm -fr *.o kernel grub.img mnt

grub.img:
	dd if=/dev/zero of=grub.img count=20 bs=1048576
	parted --script grub.img mklabel msdos mkpart p ext2 1 20 set 1 boot on
	sudo kpartx -as grub.img
	sudo mkfs.ext2 /dev/mapper/loop0p1
	mkdir -p mnt
	sudo mount /dev/mapper/loop0p1 mnt
	echo "(hd0) /dev/loop0" | sudo tee mnt/device.map
	sudo grub-install --no-floppy \
		      --grub-mkdevicemap=mnt/device.map \
		      --modules="biosdisk part_msdos ext2 configfile normal multiboot" \
		      --root-directory=`pwd`/mnt \
		      /dev/loop0

	sudo mkdir -p mnt/boot/grub
	sudo cp grub.cfg mnt/boot/grub
	sudo cp /boot/memtest86+_multiboot.bin mnt/boot/
	sudo umount mnt
	sudo kpartx -d grub.img

run: all
	qemu-system-i386 -hda grub.img

%.o: %.s
	nasm -felf -o $@ $<

