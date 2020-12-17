
_interrupt:

;controle_analogico_pwm.c,24 :: 		void interrupt()
;controle_analogico_pwm.c,26 :: 		if (TMR4IF_bit) //Atualiza leitura analogica, 2.048ms
	BTFSS      TMR4IF_bit+0, BitPos(TMR4IF_bit+0)
	GOTO       L_interrupt0
;controle_analogico_pwm.c,28 :: 		PORTB.RB4 = ~PORTB.RB4;
	MOVLW      16
	XORWF      PORTB+0, 1
;controle_analogico_pwm.c,29 :: 		flag_analogica = true;
	MOVLW      1
	MOVWF      _flag_analogica+0
;controle_analogico_pwm.c,30 :: 		TMR4IF_bit = 0x00;
	BCF        TMR4IF_bit+0, BitPos(TMR4IF_bit+0)
;controle_analogico_pwm.c,31 :: 		}
L_interrupt0:
;controle_analogico_pwm.c,33 :: 		if (TMR6IF_bit) //Atualiza saida do pwm, 512us
	BTFSS      TMR6IF_bit+0, BitPos(TMR6IF_bit+0)
	GOTO       L_interrupt1
;controle_analogico_pwm.c,35 :: 		PORTC.RA0 = ~PORTC.RA0;
	MOVLW      1
	XORWF      PORTC+0, 1
;controle_analogico_pwm.c,36 :: 		flag_pwm = true;
	MOVLW      1
	MOVWF      _flag_pwm+0
;controle_analogico_pwm.c,37 :: 		TMR6IF_bit = 0x00;
	BCF        TMR6IF_bit+0, BitPos(TMR6IF_bit+0)
;controle_analogico_pwm.c,38 :: 		}
L_interrupt1:
;controle_analogico_pwm.c,39 :: 		}
L_end_interrupt:
L__interrupt10:
	RETFIE     %s
; end of _interrupt

_Refresh_pwm:

;controle_analogico_pwm.c,43 :: 		void Refresh_pwm()
;controle_analogico_pwm.c,45 :: 		Atualiza_PWM();
	CALL       _Atualiza_PWM+0
;controle_analogico_pwm.c,46 :: 		flag_pwm = false;
	CLRF       _flag_pwm+0
;controle_analogico_pwm.c,47 :: 		}
L_end_Refresh_pwm:
	RETURN
; end of _Refresh_pwm

_Refresh_analogica:

;controle_analogico_pwm.c,50 :: 		void Refresh_analogica()
;controle_analogico_pwm.c,52 :: 		Read_analogica();
	CALL       _Read_analogica+0
;controle_analogico_pwm.c,53 :: 		flag_analogica = false;
	CLRF       _flag_analogica+0
;controle_analogico_pwm.c,54 :: 		}
L_end_Refresh_analogica:
	RETURN
; end of _Refresh_analogica

_Read_analogica:

;controle_analogico_pwm.c,56 :: 		void Read_analogica()
;controle_analogico_pwm.c,58 :: 		ADCON0 = 0x01; //Habilita o modulo ADC e seleciona canal AN0, pin RA0
	MOVLW      1
	MOVWF      ADCON0+0
;controle_analogico_pwm.c,59 :: 		ADCON1 = 0b10100000; //Utiliza Fosc/32, referencia VDD e VSS justifica a direita
	MOVLW      160
	MOVWF      ADCON1+0
;controle_analogico_pwm.c,60 :: 		ADCON0.GO = 0x01; //Inicia conversao
	BSF        ADCON0+0, 1
;controle_analogico_pwm.c,61 :: 		while (ADCON0.GO_NOT_DONE); //Aguarda o termino da conversao
L_Read_analogica2:
	BTFSS      ADCON0+0, 1
	GOTO       L_Read_analogica3
	GOTO       L_Read_analogica2
L_Read_analogica3:
;controle_analogico_pwm.c,62 :: 		leitura_ADC = ((ADRESH << 8) | (int)ADRESL); //Concatena o resultado em 16bits
	MOVF       ADRESH+0, 0
	MOVWF      _leitura_ADC+1
	CLRF       _leitura_ADC+0
	MOVF       ADRESL+0, 0
	MOVWF      R0
	CLRF       R1
	MOVF       R0, 0
	IORWF       _leitura_ADC+0, 1
	MOVF       R1, 0
	IORWF       _leitura_ADC+1, 1
;controle_analogico_pwm.c,63 :: 		delay_ms(20);
	MOVLW      52
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_Read_analogica4:
	DECFSZ     R13, 1
	GOTO       L_Read_analogica4
	DECFSZ     R12, 1
	GOTO       L_Read_analogica4
	NOP
	NOP
;controle_analogico_pwm.c,64 :: 		}
L_end_Read_analogica:
	RETURN
; end of _Read_analogica

_Atualiza_PWM:

;controle_analogico_pwm.c,67 :: 		void Atualiza_PWM()
;controle_analogico_pwm.c,69 :: 		float adc_porc = (float)leitura_ADC * 100 / 1024;
	MOVF       _leitura_ADC+0, 0
	MOVWF      R0
	MOVF       _leitura_ADC+1, 0
	MOVWF      R1
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      72
	MOVWF      R6
	MOVLW      133
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      0
	MOVWF      R6
	MOVLW      137
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;controle_analogico_pwm.c,70 :: 		unsigned int value = adc_porc * 255 / 100;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      127
	MOVWF      R6
	MOVLW      134
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      72
	MOVWF      R6
	MOVLW      133
	MOVWF      R7
	CALL       _Div_32x32_FP+0
	CALL       _double2word+0
;controle_analogico_pwm.c,71 :: 		CCPR1L = value;;
	MOVF       R0, 0
	MOVWF      CCPR1L+0
;controle_analogico_pwm.c,72 :: 		}
L_end_Atualiza_PWM:
	RETURN
; end of _Atualiza_PWM

_Configuracao_timer4:

;controle_analogico_pwm.c,75 :: 		void Configuracao_timer4()
;controle_analogico_pwm.c,82 :: 		T4CON = 0b00011101; //Habilita o timer 4 com prescaler 1:4 e postscaler 1:4
	MOVLW      29
	MOVWF      T4CON+0
;controle_analogico_pwm.c,83 :: 		PR4   = 0xFF; //Compara com 255
	MOVLW      255
	MOVWF      PR4+0
;controle_analogico_pwm.c,84 :: 		TMR4IE_bit = 0x01; //Habilita interrupcao do timer4
	BSF        TMR4IE_bit+0, BitPos(TMR4IE_bit+0)
;controle_analogico_pwm.c,85 :: 		}
L_end_Configuracao_timer4:
	RETURN
; end of _Configuracao_timer4

_Configuracao_timer6:

;controle_analogico_pwm.c,86 :: 		void Configuracao_timer6()
;controle_analogico_pwm.c,93 :: 		T6CON = 0b00000101; //Habilita timer6 prescaler 1:4 postscaler 1: 1
	MOVLW      5
	MOVWF      T6CON+0
;controle_analogico_pwm.c,94 :: 		PR6   = 0xFF;
	MOVLW      255
	MOVWF      PR6+0
;controle_analogico_pwm.c,95 :: 		TMR6IE_bit   = 0x01; //Habilita interrupcao do timer6
	BSF        TMR6IE_bit+0, BitPos(TMR6IE_bit+0)
;controle_analogico_pwm.c,96 :: 		}
L_end_Configuracao_timer6:
	RETURN
; end of _Configuracao_timer6

_Configuracao_PWM:

;controle_analogico_pwm.c,99 :: 		void Configuracao_PWM()
;controle_analogico_pwm.c,104 :: 		T2CON = 0b00011101;
	MOVLW      29
	MOVWF      T2CON+0
;controle_analogico_pwm.c,105 :: 		PR2 =   0xFF;
	MOVLW      255
	MOVWF      PR2+0
;controle_analogico_pwm.c,106 :: 		CCP1CON = 0x0C;
	MOVLW      12
	MOVWF      CCP1CON+0
;controle_analogico_pwm.c,107 :: 		CCPR1L  = 0x00;
	CLRF       CCPR1L+0
;controle_analogico_pwm.c,108 :: 		}
L_end_Configuracao_PWM:
	RETURN
; end of _Configuracao_PWM

_Configuracao_portas:

;controle_analogico_pwm.c,109 :: 		void Configuracao_portas()
;controle_analogico_pwm.c,112 :: 		TRISA.RA0 =    0x01; //Configura pino RA0 como input
	BSF        TRISA+0, 0
;controle_analogico_pwm.c,113 :: 		TRISB     =    0x00; //Configura portB como output
	CLRF       TRISB+0
;controle_analogico_pwm.c,114 :: 		TRISC     =    0x00; //Configura portc como output
	CLRF       TRISC+0
;controle_analogico_pwm.c,116 :: 		ANSELA.RA0     = 0x01; //Configura pino RA0 como analogico
	BSF        ANSELA+0, 0
;controle_analogico_pwm.c,117 :: 		ANSELB         = 0x00; //Configura portB como digital
	CLRF       ANSELB+0
;controle_analogico_pwm.c,118 :: 		ANSELC         = 0x00; //Configura portC como digital
	CLRF       ANSELC+0
;controle_analogico_pwm.c,120 :: 		PORTA.RA0 = 0x01;  //High
	BSF        PORTA+0, 0
;controle_analogico_pwm.c,121 :: 		PORTB     = 0x00; //Low
	CLRF       PORTB+0
;controle_analogico_pwm.c,122 :: 		PORTC     =0x00;  //Low
	CLRF       PORTC+0
;controle_analogico_pwm.c,123 :: 		}
L_end_Configuracao_portas:
	RETURN
; end of _Configuracao_portas

_main:

;controle_analogico_pwm.c,125 :: 		void main()
;controle_analogico_pwm.c,127 :: 		GIE_bit    = 0x01; //Habilita interrupcao global
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;controle_analogico_pwm.c,128 :: 		PEIE_bit   = 0x01; //Habilita interrupcao periferica
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;controle_analogico_pwm.c,130 :: 		Configuracao_portas();
	CALL       _Configuracao_portas+0
;controle_analogico_pwm.c,131 :: 		Configuracao_timer4();
	CALL       _Configuracao_timer4+0
;controle_analogico_pwm.c,132 :: 		Configuracao_timer6();
	CALL       _Configuracao_timer6+0
;controle_analogico_pwm.c,133 :: 		Configuracao_PWM();
	CALL       _Configuracao_PWM+0
;controle_analogico_pwm.c,135 :: 		while (1)
L_main5:
;controle_analogico_pwm.c,137 :: 		if (flag_pwm) Refresh_pwm();
	MOVF       _flag_pwm+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main7
	CALL       _Refresh_pwm+0
L_main7:
;controle_analogico_pwm.c,138 :: 		if(flag_analogica) Refresh_analogica();
	MOVF       _flag_analogica+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main8
	CALL       _Refresh_analogica+0
L_main8:
;controle_analogico_pwm.c,139 :: 		}
	GOTO       L_main5
;controle_analogico_pwm.c,141 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
