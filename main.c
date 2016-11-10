typedef unsigned int   uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char  uint8_t;

int kmain(void __attribute__((__unused__)) *foo, uint32_t __attribute__((__unused__)) bar) {
char str[]="Hello World";
char *ptr;
ptr=str;
volatile char *video = (volatile char*)0xB8000;
while(*ptr!=0){
*video++=*ptr++;
*video++ = 0x1B;
//*video++=25;
}


	return 0;
}

