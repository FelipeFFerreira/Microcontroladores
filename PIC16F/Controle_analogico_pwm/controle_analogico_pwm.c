/*
* Controle de luminosidade de um led com pwm, utilizando
* a referencia de leitura analogica de um potenciometro.
* Frequencia externa de clock 8MHz.
* Autor: Felipe Ferreira
*/

#include <stdbool.h>

/*Variaveis Globais*/
 unsigned int leitura_ADC;
 bool flag_pwm;
 bool flag_analogica;

 /*Definicao dos prototipos de funcoes*/
 void Configuracao_portas();
 void Configuracao_timer4();
 void Configuracao_timer6();
 void Configuracao_PWM();
 void Read_analogica();
 void Atualiza_PWM();

 /*Area de interrupcao global*/
 void interrupt()
 {
  if (TMR4IF_bit) //Atualiza leitura analogica, 2.048ms
  {
   PORTB.RB4 = ~PORTB.RB4;
   flag_analogica = true;
   TMR4IF_bit = 0x00;
  }

  if (TMR6IF_bit) //Atualiza saida do pwm, 512us
  {
   PORTC.RA0 = ~PORTC.RA0;
   flag_pwm = true;
   TMR6IF_bit = 0x00;
  }
 }
 /*Implementacao das funcoes definidas nos prototipos*/
 
/*Atualizacao pwm*/
 void Refresh_pwm()
 {
  Atualiza_PWM();
  flag_pwm = false;
 }
 
/*Atualizacao leitura analogica*/
 void Refresh_analogica()
 {
   Read_analogica();
   flag_analogica = false;
 }
  /*Configura registradores ADCON para realizacao da leitura analogica*/
 void Read_analogica()
 {
  ADCON0 = 0x01; //Habilita o modulo ADC e seleciona canal AN0, pin RA0
  ADCON1 = 0b10100000; //Utiliza Fosc/32, referencia VDD e VSS justifica a direita
  ADCON0.GO = 0x01; //Inicia conversao
  while (ADCON0.GO_NOT_DONE); //Aguarda o termino da conversao
  leitura_ADC = ((ADRESH << 8) | (int)ADRESL); //Concatena o resultado em 16bits
  delay_ms(20);
 }

 /*Atualiza registrador com novo valor de duty cicle definido pela regra de negocio*/
 void Atualiza_PWM()
 {
  float adc_porc = (float)leitura_ADC * 100 / 1024;
  unsigned int value = adc_porc * 255 / 100;
  CCPR1L = value;;
 }

 /*Configuracao timers*/
 void Configuracao_timer4()
 {
 /*
  * fosc/4= 1 / (8M / 4) = 500ns
  * periodo timer2 =  500ns PR4 * prescaler * postscaler
  * periodo timer = 500ns * 256 * 4 * 4 =~ 2.048ms
  */
  T4CON = 0b00011101; //Habilita o timer 4 com prescaler 1:4 e postscaler 1:4
  PR4   = 0xFF; //Compara com 255
  TMR4IE_bit = 0x01; //Habilita interrupcao do timer4
 }
void Configuracao_timer6()
{
 /*
  * fosc/4 = (8M / 4) = 500ns
  * periodo_timer6 = 500ns * PR6 * prescaler * postscaler
  * periodo_timer6 = 500ns * 256 * 4 * 1 = 512us
  */
   T6CON = 0b00000101; //Habilita timer6 prescaler 1:4 postscaler 1: 1
   PR6   = 0xFF;
   TMR6IE_bit   = 0x01; //Habilita interrupcao do timer6
}

/*Configuracao PWM*/
void Configuracao_PWM()
{
 /*Configura Timer2 para o periodo do pwm
   periodo = (PR2 + 1) * 500ns * 4 * 4 = 2ms ou 488MHz
 */
 T2CON = 0b00011101;
 PR2 =   0xFF;
 CCP1CON = 0x0C;
 CCPR1L  = 0x00;
}
void Configuracao_portas()
{
 /*Configuracao de direcao dos pinos*/
 TRISA.RA0 =    0x01; //Configura pino RA0 como input
 TRISB     =    0x00; //Configura portB como output
 TRISC     =    0x00; //Configura portc como output
 /*Configuracao analogica/digital dos pinos*/
 ANSELA.RA0     = 0x01; //Configura pino RA0 como analogico
 ANSELB         = 0x00; //Configura portB como digital
 ANSELC         = 0x00; //Configura portC como digital
 /*Configura estado inicial dos pinos*/
 PORTA.RA0 = 0x01;  //High
 PORTB     = 0x00; //Low
 PORTC     =0x00;  //Low
}

void main()
{
 GIE_bit    = 0x01; //Habilita interrupcao global
 PEIE_bit   = 0x01; //Habilita interrupcao periferica

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