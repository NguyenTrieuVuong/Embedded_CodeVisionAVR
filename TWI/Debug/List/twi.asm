
;CodeVisionAVR C Compiler V3.51 Evaluation
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R3
	.DEF _i_msb=R4
	.DEF _UART_Rx_Index=R5
	.DEF _UART_Rx_Index_msb=R6
	.DEF _UART_Data_In=R7
	.DEF _UART_Data_In_msb=R8
	.DEF _TWI_Rx_Index=R9
	.DEF _TWI_Rx_Index_msb=R10
	.DEF _TWI_Tx_Index=R11
	.DEF _TWI_Tx_Index_msb=R12
	.DEF _TWI_Data_In=R13
	.DEF _TWI_Data_In_msb=R14

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _TWI_isr
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x30:
	.DB  0x1,0x2,0x3,0x4
_0x0:
	.DB  0x53,0x74,0x61,0x72,0x74,0x20,0x73,0x65
	.DB  0x6E,0x74,0x2E,0x2E,0x2E,0xA,0x0,0x53
	.DB  0x74,0x61,0x74,0x75,0x73,0x20,0x43,0x6F
	.DB  0x64,0x65,0x3A,0x20,0x0,0x53,0x4C,0x41
	.DB  0x20,0x2B,0x20,0x72,0x77,0x20,0x73,0x65
	.DB  0x6E,0x74,0x20,0x2E,0x2E,0x2E,0xA,0x0
	.DB  0x42,0x79,0x74,0x65,0x20,0x73,0x65,0x6E
	.DB  0x74,0x2E,0x2E,0x2E,0xA,0x0,0x4F,0x77
	.DB  0x6E,0x20,0x61,0x64,0x64,0x72,0x65,0x73
	.DB  0x73,0x20,0x6D,0x61,0x74,0x63,0x68,0x20
	.DB  0x2B,0x20,0x57,0x20,0xA,0x0,0x52,0x65
	.DB  0x63,0x65,0x69,0x76,0x65,0x20,0x61,0x20
	.DB  0x62,0x79,0x74,0x65,0x2C,0x20,0x73,0x65
	.DB  0x6E,0x74,0x20,0x41,0x43,0x4B,0x20,0xA
	.DB  0x0,0x52,0x65,0x63,0x65,0x69,0x76,0x65
	.DB  0x20,0x61,0x20,0x62,0x79,0x74,0x65,0x2C
	.DB  0x20,0x73,0x65,0x6E,0x74,0x20,0x4E,0x41
	.DB  0x43,0x4B,0x20,0xA,0x0,0x52,0x65,0x63
	.DB  0x65,0x69,0x76,0x65,0x20,0x53,0x74,0x6F
	.DB  0x70,0x20,0x63,0x6F,0x6E,0x64,0x69,0x74
	.DB  0x69,0x6F,0x6E,0x20,0xA,0x0,0x44,0x61
	.DB  0x74,0x61,0x20,0x72,0x65,0x63,0x65,0x69
	.DB  0x76,0x65,0x64,0x20,0x66,0x72,0x6F,0x6D
	.DB  0x20,0x55,0x41,0x52,0x54,0x20,0x3A,0x20
	.DB  0x0,0x44,0x61,0x74,0x61,0x20,0x72,0x65
	.DB  0x63,0x65,0x69,0x76,0x65,0x64,0x20,0x66
	.DB  0x72,0x6F,0x6D,0x20,0x54,0x57,0x49,0x3A
	.DB  0x20,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x05
	.DW  __REG_VARS*2

	.DW  0x0F
	.DW  _0x13
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x13+15
	.DW  _0x0*2+15

	.DW  0x02
	.DW  _0x13+29
	.DW  _0x0*2+13

	.DW  0x13
	.DW  _0x17
	.DW  _0x0*2+29

	.DW  0x0E
	.DW  _0x17+19
	.DW  _0x0*2+15

	.DW  0x02
	.DW  _0x17+33
	.DW  _0x0*2+13

	.DW  0x0E
	.DW  _0x1B
	.DW  _0x0*2+48

	.DW  0x0E
	.DW  _0x1B+14
	.DW  _0x0*2+15

	.DW  0x02
	.DW  _0x1B+28
	.DW  _0x0*2+13

	.DW  0x18
	.DW  _0x36
	.DW  _0x0*2+62

	.DW  0x1B
	.DW  _0x36+24
	.DW  _0x0*2+86

	.DW  0x1C
	.DW  _0x36+51
	.DW  _0x0*2+113

	.DW  0x19
	.DW  _0x36+79
	.DW  _0x0*2+141

	.DW  0x1B
	.DW  _0x4F
	.DW  _0x0*2+166

	.DW  0x02
	.DW  _0x4F+27
	.DW  _0x0*2+13

	.DW  0x19
	.DW  _0x4F+29
	.DW  _0x0*2+193

	.DW  0x02
	.DW  _0x4F+54
	.DW  _0x0*2+13

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_uart_init:
; .FSTART _uart_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	BAUDRATE -> Y+2
;	n -> R16,R17
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x0
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x10
	RCALL __DIVD21
	SBIW R30,1
	MOVW R16,R30
	STS  197,R17
	STS  196,R16
	LDI  R30,LOW(6)
	STS  194,R30
	LDI  R30,LOW(152)
	STS  193,R30
	SEI
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
_uart_putchar:
; .FSTART _uart_putchar
	ST   -Y,R17
	MOV  R17,R26
;	data -> R17
_0x3:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x3
	STS  198,R17
	RJMP _0x2000004
; .FEND
_uart_putstring:
; .FSTART _uart_putstring
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x6:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x8
	LD   R26,X
	RCALL _uart_putchar
	MOVW R26,R16
	LD   R26,X
	CPI  R26,LOW(0xA)
	BRNE _0x9
	LDI  R26,LOW(13)
	RCALL _uart_putchar
_0x9:
	__ADDWRN 16,17,1
	RJMP _0x6
_0x8:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
_uart_put_int:
; .FSTART _uart_put_int
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,8
	RCALL __SAVELOCR6
;	value -> Y+14
;	buf -> Y+6
;	index -> R16,R17
;	i -> R18,R19
;	j -> R20,R21
	__GETWRN 16,17,0
	__GETWRS 20,21,14
_0xB:
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R26,R20
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	MOVW R26,R20
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOVW R20,R30
	__ADDWRN 16,17,1
	MOV  R0,R20
	OR   R0,R21
	BRNE _0xB
	MOVW R18,R16
_0xE:
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRGE _0xF
	MOVW R30,R18
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _uart_putchar
	__SUBWRN 18,19,1
	RJMP _0xE
_0xF:
	RCALL __LOADLOCR6
	ADIW R28,16
	RET
; .FEND
_TWI_Init:
; .FSTART _TWI_Init
	RCALL __SAVELOCR4
	MOV  R17,R26
	LDD  R16,Y+4
	LDD  R19,Y+5
;	sla -> R19
;	gcall -> R16
;	sclock -> R17
	MOV  R30,R19
	LSL  R30
	ADD  R30,R16
	STS  186,R30
	LDS  R30,185
	ANDI R30,LOW(0xFC)
	STS  185,R30
	MOV  R30,R17
	LDI  R31,0
	__CWD1
	RCALL SUBOPT_0x0
	__SUBD1N 16
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x2
	RCALL __DIVD21
	STS  184,R30
	LDI  R30,LOW(69)
	STS  188,R30
	RJMP _0x2000003
; .FEND
_TWI_Interupt_Enable:
; .FSTART _TWI_Interupt_Enable
	LDS  R30,188
	ORI  R30,1
	RJMP _0x2000005
; .FEND
_TWI_Interupt_Disable:
; .FSTART _TWI_Interupt_Disable
	LDS  R30,188
	ANDI R30,0xFE
	RJMP _0x2000005
; .FEND
_TWI_Start:
; .FSTART _TWI_Start
	LDI  R30,LOW(164)
	STS  188,R30
_0x10:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x10
	__POINTW2MN _0x13,0
	RCALL _uart_putstring
	__POINTW2MN _0x13,15
	RCALL SUBOPT_0x1
	__POINTW2MN _0x13,29
	RCALL SUBOPT_0x2
	RET
; .FEND

	.DSEG
_0x13:
	.BYTE 0x1F

	.CSEG
_TWI_Stop:
; .FSTART _TWI_Stop
	LDI  R30,LOW(148)
_0x2000005:
	STS  188,R30
	RET
; .FEND
_TWI_SLA_RW:
; .FSTART _TWI_SLA_RW
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
;	add -> R16
;	rw -> R17
	MOV  R30,R17
	SUBI R30,-LOW(1)
	MOV  R26,R16
	RCALL __LSLB12
	STS  187,R30
	LDI  R30,LOW(132)
	STS  188,R30
_0x14:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x14
	__POINTW2MN _0x17,0
	RCALL _uart_putstring
	__POINTW2MN _0x17,19
	RCALL SUBOPT_0x1
	__POINTW2MN _0x17,33
	RCALL SUBOPT_0x2
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND

	.DSEG
_0x17:
	.BYTE 0x23

	.CSEG
_TWI_Send_Byte:
; .FSTART _TWI_Send_Byte
	ST   -Y,R17
	MOV  R17,R26
;	b -> R17
	STS  187,R17
	LDI  R30,LOW(132)
	STS  188,R30
_0x18:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0x18
	__POINTW2MN _0x1B,0
	RCALL _uart_putstring
	__POINTW2MN _0x1B,14
	RCALL SUBOPT_0x1
	__POINTW2MN _0x1B,28
	RCALL SUBOPT_0x2
_0x2000004:
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x1B:
	.BYTE 0x1E

	.CSEG
_TWI_Send_Array:
; .FSTART _TWI_Send_Array
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
;	*arr -> R18,R19
;	length -> R16,R17
	CLR  R3
	CLR  R4
_0x1D:
	__CPWRR 3,4,16,17
	BRGE _0x1E
	__GETW1R 3,4
	ADD  R30,R18
	ADC  R31,R19
	LD   R26,Z
	RCALL _TWI_Send_Byte
	CPI  R30,LOW(0x28)
	BRNE _0x2000002
	RCALL SUBOPT_0x3
	RJMP _0x1D
_0x1E:
_0x2000002:
	LDS  R30,185
	ANDI R30,LOW(0xF8)
_0x2000003:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
_TWI_Error:
; .FSTART _TWI_Error
	RCALL _TWI_Stop
	RCALL _TWI_Interupt_Enable
	RET
; .FEND
_TWI_Master_Send:
; .FSTART _TWI_Master_Send
	RCALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	LDD  R21,Y+8
;	sla -> R21
;	*arr -> R18,R19
;	length -> R16,R17
	RCALL _TWI_Interupt_Disable
	RCALL _TWI_Start
	CPI  R30,LOW(0x8)
	BREQ _0x20
	LDI  R30,LOW(1)
	RJMP _0x2000001
_0x20:
	ST   -Y,R21
	LDI  R26,LOW(0)
	RCALL _TWI_SLA_RW
	CPI  R30,LOW(0x18)
	BREQ _0x21
	LDI  R30,LOW(1)
	RJMP _0x2000001
_0x21:
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R16
	RCALL _TWI_Send_Array
	CPI  R30,LOW(0x28)
	BREQ _0x22
	LDI  R30,LOW(1)
	RJMP _0x2000001
_0x22:
	RCALL _TWI_Stop
	RCALL _TWI_Interupt_Enable
	LDI  R30,LOW(0)
_0x2000001:
	RCALL __LOADLOCR6
	ADIW R28,9
	RET
; .FEND
;	sla -> R21
;	*arr -> R18,R19
;	length -> R16,R17

	.DSEG
;interrupt [19] void usart_rx_isr(void) {
; 0000 001C interrupt [19] void usart_rx_isr(void) {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 001D UART_Data_In = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 7,8
; 0000 001E if (UART_Rx_Index <50){
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R5,R30
	CPC  R6,R31
	BRGE _0x31
; 0000 001F UART_Rx_Buf[UART_Rx_Index++] = UDR0;
	__GETW1R 5,6
	ADIW R30,1
	__PUTW1R 5,6
	SBIW R30,1
	SUBI R30,LOW(-_UART_Rx_Buf)
	SBCI R31,HIGH(-_UART_Rx_Buf)
	MOVW R26,R30
	LDS  R30,198
	ST   X,R30
; 0000 0020 }
; 0000 0021 }
_0x31:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;interrupt [25] void TWI_isr(void){
; 0000 0025 interrupt [25] void TWI_isr(void){
_TWI_isr:
; .FSTART _TWI_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0026 Status_Code = TWSR;
	LDS  R30,185
	STS  _Status_Code,R30
; 0000 0027 switch (Status_Code){
	LDI  R31,0
; 0000 0028 ////////////////////////////////////////////////////
; 0000 0029 ///////////// Slave Receive Mode ///////////////////
; 0000 002A case 0x60:                   //Own Address match + W, sent ACK
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x35
; 0000 002B uart_putstring("Own address match + W \n");
	__POINTW2MN _0x36,0
	RCALL _uart_putstring
; 0000 002C TWI_Rx_Index = 0;
	CLR  R9
	CLR  R10
; 0000 002D TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 002E break;
; 0000 002F case 0x80:                  //Received a byte, sent ACK
_0x35:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x37
; 0000 0030 
; 0000 0031 uart_putstring("Receive a byte, sent ACK \n");
	__POINTW2MN _0x36,24
	RCALL _uart_putstring
; 0000 0032 if (TWI_Rx_Index<49){
	RCALL SUBOPT_0x4
	BRGE _0x38
; 0000 0033 TWI_Rx_Buf[TWI_Rx_Index++] = TWDR;
	RCALL SUBOPT_0x5
; 0000 0034 TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 0035 break;
; 0000 0036 }
; 0000 0037 else {                  //Receive last byte
_0x38:
; 0000 0038 TWI_Rx_Buf[TWI_Rx_Index] = TWDR;
	RCALL SUBOPT_0x6
; 0000 0039 TWCR = 0b10000101;     //Clear TWINT, clear TWEA, send NACK
	RJMP _0x5A
; 0000 003A break;
; 0000 003B }
; 0000 003C case 0x88:                  //Received a byte, sent NACK
_0x37:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x3B
; 0000 003D TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 003E break;
; 0000 003F // For General Call
; 0000 0040 case 0x70:                  //General Call match + W, send ACK
_0x3B:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x3C
; 0000 0041 TWI_Rx_Index = 0;
	CLR  R9
	CLR  R10
; 0000 0042 TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 0043 break;
; 0000 0044 case 0x90:                  //Received a byte, sent ACK
_0x3C:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0x3D
; 0000 0045 
; 0000 0046 if (TWI_Rx_Index<49){
	RCALL SUBOPT_0x4
	BRGE _0x3E
; 0000 0047 TWI_Rx_Buf[TWI_Rx_Index++] = TWDR;
	RCALL SUBOPT_0x5
; 0000 0048 TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 0049 break;
; 0000 004A }
; 0000 004B else {                  //Receive last byte
_0x3E:
; 0000 004C TWI_Rx_Buf[TWI_Rx_Index] = TWDR;
	RCALL SUBOPT_0x6
; 0000 004D TWCR = 0b10000101;     //Clear TWINT, clear TWEA, send NACK
	RJMP _0x5A
; 0000 004E break;
; 0000 004F }
; 0000 0050 case 0x98:                  //Received a byte, sent NACK
_0x3D:
	CPI  R30,LOW(0x98)
	LDI  R26,HIGH(0x98)
	CPC  R31,R26
	BRNE _0x41
; 0000 0051 uart_putstring("Receive a byte, sent NACK \n");
	__POINTW2MN _0x36,51
	RCALL _uart_putstring
; 0000 0052 TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 0053 break;
; 0000 0054 case 0xA0:                  //Received Stop condition or Restart
_0x41:
	CPI  R30,LOW(0xA0)
	LDI  R26,HIGH(0xA0)
	CPC  R31,R26
	BRNE _0x42
; 0000 0055 uart_putstring("Receive Stop condition \n");
	__POINTW2MN _0x36,79
	RCALL _uart_putstring
; 0000 0056 TWI_Data_In = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 13,14
; 0000 0057 TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 0058 break;
; 0000 0059 //////////////////////////////////////////////////////
; 0000 005A ///////////// Slave Transmit Mode ///////////////////
; 0000 005B case 0xA8:                  //Own Address match + R,  sent ACK
_0x42:
	CPI  R30,LOW(0xA8)
	LDI  R26,HIGH(0xA8)
	CPC  R31,R26
	BRNE _0x43
; 0000 005C TWDR = TWI_Tx_Buf[TWI_Tx_Index++];
	RCALL SUBOPT_0x7
; 0000 005D TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 005E break;
; 0000 005F case 0xB8:                  //Sent data, received ACK
_0x43:
	CPI  R30,LOW(0xB8)
	LDI  R26,HIGH(0xB8)
	CPC  R31,R26
	BRNE _0x44
; 0000 0060 if (TWI_Tx_Index < 49){
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CP   R11,R30
	CPC  R12,R31
	BRGE _0x45
; 0000 0061 TWDR = TWI_Tx_Buf[TWI_Tx_Index++];
	RCALL SUBOPT_0x7
; 0000 0062 TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 0063 break;
; 0000 0064 }
; 0000 0065 else {
_0x45:
; 0000 0066 TWDR = TWI_Tx_Buf[TWI_Tx_Index];    //send last byte
	LDI  R26,LOW(_TWI_Tx_Buf)
	LDI  R27,HIGH(_TWI_Tx_Buf)
	ADD  R26,R11
	ADC  R27,R12
	LD   R30,X
	STS  187,R30
; 0000 0067 TWCR = 0b10000101;                  //Clear TWINT, Clear TWEA
	LDI  R30,LOW(133)
	RJMP _0x5A
; 0000 0068 break;
; 0000 0069 }
; 0000 006A case 0xB0:           //Lost arbitration, own address match+R, sent ACK
_0x44:
	CPI  R30,LOW(0xB0)
	LDI  R26,HIGH(0xB0)
	CPC  R31,R26
	BRNE _0x48
; 0000 006B TWDR = TWI_Tx_Buf[TWI_Tx_Index++];
	RCALL SUBOPT_0x7
; 0000 006C TWCR |= 0b11000000;     //Clear TWINT, set TWEA
	RJMP _0x59
; 0000 006D break;
; 0000 006E case 0xC0:                  //sent data byte, receive NACK
_0x48:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BREQ _0x59
; 0000 006F TWCR |= 0b11000000;     //Clear TWINT, set TWEA
; 0000 0070 break;
; 0000 0071 case 0xC8:                  //sent last data byte, receive ACK
	CPI  R30,LOW(0xC8)
	LDI  R26,HIGH(0xC8)
	CPC  R31,R26
	BRNE _0x34
; 0000 0072 TWCR |= 0b11000000;     //Clear TWINT, set TWEA
_0x59:
	LDS  R30,188
	ORI  R30,LOW(0xC0)
_0x5A:
	STS  188,R30
; 0000 0073 break;
; 0000 0074 }
_0x34:
; 0000 0075 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x36:
	.BYTE 0x68
;void main(void)
; 0000 0078 {

	.CSEG
_main:
; .FSTART _main
; 0000 0079 uart_init(9600);
	LDI  R26,LOW(9600)
	LDI  R27,HIGH(9600)
	RCALL _uart_init
; 0000 007A TWI_Init(own_address, 1, 100000);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(160)
	RCALL _TWI_Init
; 0000 007B while (1)
_0x4B:
; 0000 007C {
; 0000 007D //If receive data from UART, transfer them into TWI (Master transmit mode)
; 0000 007E if (UART_Data_In) {
	MOV  R0,R7
	OR   R0,R8
	BREQ _0x4E
; 0000 007F uart_putstring("Data received from UART : ");
	__POINTW2MN _0x4F,0
	RCALL _uart_putstring
; 0000 0080 uart_putstring(UART_Rx_Buf);
	LDI  R26,LOW(_UART_Rx_Buf)
	LDI  R27,HIGH(_UART_Rx_Buf)
	RCALL _uart_putstring
; 0000 0081 uart_putstring("\n");
	__POINTW2MN _0x4F,27
	RCALL _uart_putstring
; 0000 0082 //Reset Rx_Buf
; 0000 0083 for (i = 0; i<UART_Rx_Index;i++){
	CLR  R3
	CLR  R4
_0x51:
	__CPWRR 3,4,5,6
	BRGE _0x52
; 0000 0084 TWI_Tx_Buf[i] = UART_Rx_Buf[i];
	__GETW1R 3,4
	SUBI R30,LOW(-_TWI_Tx_Buf)
	SBCI R31,HIGH(-_TWI_Tx_Buf)
	MOVW R0,R30
	RCALL SUBOPT_0x8
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0085 UART_Rx_Buf[i] = 0;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0086 }
	RCALL SUBOPT_0x3
	RJMP _0x51
_0x52:
; 0000 0087 if (TWI_Master_Send(slave_address,TWI_Tx_Buf,UART_Rx_Index))
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_TWI_Tx_Buf)
	LDI  R31,HIGH(_TWI_Tx_Buf)
	ST   -Y,R31
	ST   -Y,R30
	__GETW2R 5,6
	RCALL _TWI_Master_Send
	CPI  R30,0
	BREQ _0x53
; 0000 0088 TWI_Error();
	RCALL _TWI_Error
; 0000 0089 UART_Rx_Index = 0;
_0x53:
	CLR  R5
	CLR  R6
; 0000 008A UART_Data_In = 0;
	CLR  R7
	CLR  R8
; 0000 008B }
; 0000 008C delay_ms(1000);
_0x4E:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 008D 
; 0000 008E //If receive data from TWI, transfer them into UART
; 0000 008F if (TWI_Data_In){
	MOV  R0,R13
	OR   R0,R14
	BREQ _0x54
; 0000 0090 uart_putstring("Data received from TWI: ");
	__POINTW2MN _0x4F,29
	RCALL _uart_putstring
; 0000 0091 uart_putstring(TWI_Rx_Buf);
	LDI  R26,LOW(_TWI_Rx_Buf)
	LDI  R27,HIGH(_TWI_Rx_Buf)
	RCALL _uart_putstring
; 0000 0092 uart_putstring("\n");
	__POINTW2MN _0x4F,54
	RCALL _uart_putstring
; 0000 0093 for (i = 0; i<TWI_Rx_Index;i++)
	CLR  R3
	CLR  R4
_0x56:
	__CPWRR 3,4,9,10
	BRGE _0x57
; 0000 0094 TWI_Tx_Buf[i] = 0;
	LDI  R26,LOW(_TWI_Tx_Buf)
	LDI  R27,HIGH(_TWI_Tx_Buf)
	ADD  R26,R3
	ADC  R27,R4
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x3
	RJMP _0x56
_0x57:
; 0000 0095 TWI_Rx_Index = 0;
	CLR  R9
	CLR  R10
; 0000 0096 TWI_Data_In = 0;
	CLR  R13
	CLR  R14
; 0000 0097 }
; 0000 0098 }
_0x54:
	RJMP _0x4B
; 0000 0099 }
_0x58:
	RJMP _0x58
; .FEND

	.DSEG
_0x4F:
	.BYTE 0x38

	.DSEG
_TWI_Rx_Buf:
	.BYTE 0x32
_TWI_Tx_Buf:
	.BYTE 0x32
_UART_Rx_Buf:
	.BYTE 0x32
_Status_Code:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	__GETD2N 0xF42400
	RCALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	RCALL _uart_putstring
	LDS  R30,185
	LDI  R31,0
	ANDI R30,LOW(0xF8)
	ANDI R31,HIGH(0xF8)
	MOVW R26,R30
	RJMP _uart_put_int

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	RCALL _uart_putstring
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CP   R9,R30
	CPC  R10,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	__GETW1R 9,10
	ADIW R30,1
	__PUTW1R 9,10
	SBIW R30,1
	SUBI R30,LOW(-_TWI_Rx_Buf)
	SBCI R31,HIGH(-_TWI_Rx_Buf)
	MOVW R26,R30
	LDS  R30,187
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	__GETW2R 9,10
	SUBI R26,LOW(-_TWI_Rx_Buf)
	SBCI R27,HIGH(-_TWI_Rx_Buf)
	LDS  R30,187
	ST   X,R30
	LDI  R30,LOW(133)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x7:
	__GETW1R 11,12
	ADIW R30,1
	__PUTW1R 11,12
	SBIW R30,1
	SUBI R30,LOW(-_TWI_Tx_Buf)
	SBCI R31,HIGH(-_TWI_Tx_Buf)
	LD   R30,Z
	STS  187,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_UART_Rx_Buf)
	LDI  R27,HIGH(_UART_Rx_Buf)
	ADD  R26,R3
	ADC  R27,R4
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ANEGD2:
	COM  R27
	COM  R24
	COM  R25
	NEG  R26
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	MOVW R20,R0
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	RCALL __ANEGD2
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
