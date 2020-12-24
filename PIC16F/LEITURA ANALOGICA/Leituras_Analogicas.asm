
_main:

;Leituras_Analogicas.c,4 :: 		void main()
;Leituras_Analogicas.c,9 :: 		ANSELA.ANSA0 = 0x01;
	BSF        ANSELA+0, 0
;Leituras_Analogicas.c,10 :: 		TRISA.RA0 = 0x01;
	BSF        TRISA+0, 0
;Leituras_Analogicas.c,11 :: 		PORTA = 0x01;
	MOVLW      1
	MOVWF      PORTA+0
;Leituras_Analogicas.c,13 :: 		ANSELC = 0x0;
	CLRF       ANSELC+0
;Leituras_Analogicas.c,14 :: 		TRISC = 0x0;
	CLRF       TRISC+0
;Leituras_Analogicas.c,15 :: 		PORTC = 0x0;
	CLRF       PORTC+0
;Leituras_Analogicas.c,16 :: 		LATC = 0x0;
	CLRF       LATC+0
;Leituras_Analogicas.c,18 :: 		ADCON0 = 0x01;
	MOVLW      1
	MOVWF      ADCON0+0
;Leituras_Analogicas.c,19 :: 		ADCON1 = 0b10100000;
	MOVLW      160
	MOVWF      ADCON1+0
;Leituras_Analogicas.c,21 :: 		while(1)
L_main0:
;Leituras_Analogicas.c,23 :: 		ADCON0.GO = 1;
	BSF        ADCON0+0, 1
;Leituras_Analogicas.c,24 :: 		while(ADCON0.GO_NOT_DONE);
L_main2:
	BTFSS      ADCON0+0, 1
	GOTO       L_main3
	GOTO       L_main2
L_main3:
;Leituras_Analogicas.c,25 :: 		LATC = ((ADRESH << 8) | ADRESL);
	MOVF       ADRESL+0, 0
	MOVWF      LATC+0
;Leituras_Analogicas.c,27 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_main4:
	DECFSZ     R13, 1
	GOTO       L_main4
	DECFSZ     R12, 1
	GOTO       L_main4
	NOP
	NOP
;Leituras_Analogicas.c,28 :: 		}
	GOTO       L_main0
;Leituras_Analogicas.c,29 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
