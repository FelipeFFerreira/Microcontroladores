#line 1 "C:/GitHub/PIC16F/VARREDURA DE BOTOES/varredura_botoes.c"







void interrupt()
{
 if (T0IF_bit)
 {
 T0IF_bit = 0x00;
 TMR0 = 0x6C;

 if (! RA0_bit )
 {
  RA2_bit  = 0x01;
 }
 else if (! RA1_bit )
 {
  RA2_bit  = 0x00;
 }

 }
}
void main()
{

 TRISA.RA0 = 0x01;
 TRISA.RA1 = 0x01;
 TRISA.RA2 = 0x00;
 TRISB.RB4 = 0x00;
 PORTA = 0x03;
 ANSELA = 0x00;

 OPTION_REG = 0x86;
 GIE_bit = 0x01;
 PEIE_bit = 0x01;
 T0IE_bit = 0x01;
 TMR0 = 0x6C;

 while(1)
 {
  RB4_bit  = 0x01;
 delay_ms(500);
  RB4_bit  = 0x00;
 delay_ms(500);

 }
}
