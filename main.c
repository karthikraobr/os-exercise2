typedef unsigned int   uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char  uint8_t;

int kmain(void __attribute__((__unused__)) *foo, uint32_t __attribute__((__unused__)) bar) {
char str[]="Hello World";
char *ptr;
ptr=str;
volatile char *video = (volatile char*)0xB8000;
int i=0;
for(i=0;i<sizeof(str);i++){
*video++=*ptr++;
*video++ = 0x1B;
//*video++=25;
}


	return 0;
}

