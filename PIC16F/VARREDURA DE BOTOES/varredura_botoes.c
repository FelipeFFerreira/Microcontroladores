
  // -- Hardware --
  #define S0 RA0_bit
  #define S1 RA1_bit
  #define led1 RA2_bit
  #define led2 RB4_bit

void interrupt()
{
     if (T0IF_bit)
     {
        T0IF_bit = 0x00;
        TMR0     = 0x6C;

        if (!S0)
        {
           led1 = 0x01;
        }
        else if (!S1)
        {
             led1 = 0x00;
        }

     }
}
void main()
{
     //CM1CON0 = 0x07;
     TRISA.RA0    = 0x01;       //input
     TRISA.RA1    = 0x01;       //input
     TRISA.RA2    = 0x00;       //output
     TRISB.RB4    = 0x00;       //output
     PORTA = 0x03;
     ANSELA = 0x00;
     APFCON0.S

     OPTION_REG   = 0x86; //Timer0 incrementa com ciclo de instrucao, prescaler 1:128
     GIE_bit      = 0x01; //Habilita interrupacao glonal
     PEIE_bit     = 0x01; //Habilita interrupcao por perifericos
     T0IE_bit     = 0x01; //Habilita interrupcao do Timer0
     TMR0         = 0x6C; //Inicia Timer0 com o valor 0x6C

     while(1)
     {
        led2 = 0x01;
        delay_ms(500);
        led2 = 0x00;
        delay_ms(500);

     }
}