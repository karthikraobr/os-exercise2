MBOOT_PAGE_ALIGN    equ 1<<0        ; setup the page alignment
MBOOT_MEM_INFO      equ 1<<1        ; memory information for the kernel
MBOOT_HEADER_MAGIC  equ 0x1BADB002  ; magic value to indicate the kernel
MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)


[BITS 32]                      ; instructions are 32 bit

[GLOBAL mboot]                 ; mboot accessible from C
[EXTERN code]                  ; start of the code section
[EXTERN bss]                   ; start of the bss section
[EXTERN end]                   ; end of the loadable sections

mboot:
                               ; embedding constants in the code:
	dd  0x0000000              ; TODO: fill in the correct value!
	dd  MBOOT_HEADER_FLAGS     ; tell grub what your file is
	dd  MBOOT_CHECKSUM         ; verify checksum

	dd  mboot
	dd  code                   ; start of code (.text) section
	dd  bss                    ; end of data section
	dd  end                    ; end of kernel
	dd  start                  ; entry point

[GLOBAL start]
[EXTERN kmain]                 ; entry point for the C code

start:

	push esp
	push ebx                   ; load multiboot header location

	cli                        ; disable interrupts
	call kmain                 ; call our C function
	jmp $                      ; infinite loop to not execute random memory


