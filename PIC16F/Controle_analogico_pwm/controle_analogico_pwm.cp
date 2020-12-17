#line 1 "C:/GitHub/Microcontroladores/PIC16F/Controle_analogico_pwm/controle_analogico_pwm.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdbool.h"



 typedef char _Bool;
#line 11 "C:/GitHub/Microcontroladores/PIC16F/Controle_analogico_pwm/controle_analogico_pwm.c"
 unsigned int leitura_ADC;
  _Bool  flag_pwm;
  _Bool  flag_analogica;


 void Configuracao_portas();
 void Configuracao_timer4();
 void Configuracao_timer6();
 void Configuracao_PWM();
 void Read_analogica();
 void Atualiza_PWM();


 void interrupt()
 {
 if (TMR4IF_bit)
 {
 PORTB.RB4 = ~PORTB.RB4;
 flag_analogica =  1 ;
 TMR4IF_bit = 0x00;
 }

 if (TMR6IF_bit)
 {
 PORTC.RA0 = ~PORTC.RA0;
 flag_pwm =  1 ;
 TMR6IF_bit = 0x00;
 }
 }



 void Refresh_pwm()
 {
 Atualiza_PWM();
 flag_pwm =  0 ;
 }


 void Refresh_analogica()
 {
 Read_analogica();
 flag_analogica =  0 ;
 }

 void Read_analogica()
 {
 ADCON0 = 0x01;
 ADCON1 = 0b10100000;
 ADCON0.GO = 0x01;
 while (ADCON0.GO_NOT_DONE);
 leitura_ADC = ((ADRESH << 8) | (int)ADRESL);
 delay_ms(20);
 }


 void Atualiza_PWM()
 {
 float adc_porc = (float)leitura_ADC * 100 / 1024;
 unsigned int value = adc_porc * 255 / 100;
 CCPR1L = value;;
 }


 void Configuracao_timer4()
 {
#line 82 "C:/GitHub/Microcontroladores/PIC16F/Controle_analogico_pwm/controle_analogico_pwm.c"
 T4CON = 0b00011101;
 PR4 = 0xFF;
 TMR4IE_bit = 0x01;
 }
void Configuracao_timer6()
{
#line 93 "C:/GitHub/Microcontroladores/PIC16F/Controle_analogico_pwm/controle_analogico_pwm.c"
 T6CON = 0b00000101;
 PR6 = 0xFF;
 TMR6IE_bit = 0x01;
}


void Configuracao_PWM()
{
#line 104 "C:/GitHub/Microcontroladores/PIC16F/Controle_analogico_pwm/controle_analogico_pwm.c"
 T2CON = 0b00011101;
 PR2 = 0xFF;
 CCP1CON = 0x0C;
 CCPR1L = 0x00;
}
void Configuracao_portas()
{

 TRISA.RA0 = 0x01;
 TRISB = 0x00;
 TRISC = 0x00;

 ANSELA.RA0 = 0x01;
 ANSELB = 0x00;
 ANSELC = 0x00;

 PORTA.RA0 = 0x01;
 PORTB = 0x00;
 PORTC =0x00;
}

void main()
{
 GIE_bit = 0x01;
 PEIE_bit = 0x01;

 Configuracao_portas();
 Configuracao_timer4();
 Configuracao_timer6();
 Configuracao_PWM();

 while (1)
 {
 if (flag_pwm) Refresh_pwm();
 if(flag_analogica) Refresh_analogica();
 }

}
