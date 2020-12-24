#line 1 "C:/GitHub/PIC16F/LEITURA ANALOGICA/Leituras_Analogicas.c"



void main()
{
 unsigned int Leitura_ADC;
 unsigned char Text[6];

 ANSELA.ANSA0 = 0x01;
 TRISA.RA0 = 0x01;
 PORTA = 0x01;

 ANSELC = 0x0;
 TRISC = 0x0;
 PORTC = 0x0;
 LATC = 0x0;

 ADCON0 = 0x01;
 ADCON1 = 0b10100000;

 while(1)
 {
 ADCON0.GO = 1;
 while(ADCON0.GO_NOT_DONE);
 LATC = ((ADRESH << 8) | ADRESL);

 Delay_ms(20);
 }
}
