
_interrupt:

;varredura_botoes.c,8 :: 		void interrupt()
;varredura_botoes.c,10 :: 		if (T0IF_bit)
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L_interrupt0
;varredura_botoes.c,12 :: 		T0IF_bit = 0x00;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;varredura_botoes.c,13 :: 		TMR0     = 0x6C;
	MOVLW      108
	MOVWF      TMR0+0
;varredura_botoes.c,15 :: 		if (!S0)
	BTFSC      RA0_bit+0, BitPos(RA0_bit+0)
	GOTO       L_interrupt1
;varredura_botoes.c,17 :: 		led1 = 0x01;
	BSF        RA2_bit+0, BitPos(RA2_bit+0)
;varredura_botoes.c,18 :: 		}
	GOTO       L_interrupt2
L_interrupt1:
;varredura_botoes.c,19 :: 		else if (!S1)
	BTFSC      RA1_bit+0, BitPos(RA1_bit+0)
	GOTO       L_interrupt3
;varredura_botoes.c,21 :: 		led1 = 0x00;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;varredura_botoes.c,22 :: 		}
L_interrupt3:
L_interrupt2:
;varredura_botoes.c,24 :: 		}
L_interrupt0:
;varredura_botoes.c,25 :: 		}
L_end_interrupt:
L__interrupt9:
	RETFIE     %s
; end of _interrupt

_main:

;varredura_botoes.c,26 :: 		void main()
;varredura_botoes.c,29 :: 		TRISA.RA0    = 0x01;       //input
	BSF        TRISA+0, 0
;varredura_botoes.c,30 :: 		TRISA.RA1    = 0x01;       //input
	BSF        TRISA+0, 1
;varredura_botoes.c,31 :: 		TRISA.RA2    = 0x00;       //output
	BCF        TRISA+0, 2
;varredura_botoes.c,32 :: 		TRISB.RB4    = 0x00;       //output
	BCF        TRISB+0, 4
;varredura_botoes.c,33 :: 		PORTA = 0x03;
	MOVLW      3
	MOVWF      PORTA+0
;varredura_botoes.c,34 :: 		ANSELA = 0x00;
	CLRF       ANSELA+0
;varredura_botoes.c,36 :: 		OPTION_REG   = 0x86; //Timer0 incrementa com ciclo de instrucao, prescaler 1:128
	MOVLW      134
	MOVWF      OPTION_REG+0
;varredura_botoes.c,37 :: 		GIE_bit      = 0x01; //Habilita interrupacao glonal
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;varredura_botoes.c,38 :: 		PEIE_bit     = 0x01; //Habilita interrupcao por perifericos
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;varredura_botoes.c,39 :: 		T0IE_bit     = 0x01; //Habilita interrupcao do Timer0
	BSF        T0IE_bit+0, BitPos(T0IE_bit+0)
;varredura_botoes.c,40 :: 		TMR0         = 0x6C; //Inicia Timer0 com o valor 0x6C
	MOVLW      108
	MOVWF      TMR0+0
;varredura_botoes.c,42 :: 		while(1)
L_main4:
;varredura_botoes.c,44 :: 		led2 = 0x01;
	BSF        RB4_bit+0, BitPos(RB4_bit+0)
;varredura_botoes.c,45 :: 		delay_ms(500);
	MOVLW      3
	MOVWF      R11
	MOVLW      138
	MOVWF      R12
	MOVLW      85
	MOVWF      R13
L_main6:
	DECFSZ     R13, 1
	GOTO       L_main6
	DECFSZ     R12, 1
	GOTO       L_main6
	DECFSZ     R11, 1
	GOTO       L_main6
	NOP
	NOP
;varredura_botoes.c,46 :: 		led2 = 0x00;
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
;varredura_botoes.c,47 :: 		delay_ms(500);
	MOVLW      3
	MOVWF      R11
	MOVLW      138
	MOVWF      R12
	MOVLW      85
	MOVWF      R13
L_main7:
	DECFSZ     R13, 1
	GOTO       L_main7
	DECFSZ     R12, 1
	GOTO       L_main7
	DECFSZ     R11, 1
	GOTO       L_main7
	NOP
	NOP
;varredura_botoes.c,49 :: 		}
	GOTO       L_main4
;varredura_botoes.c,50 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
