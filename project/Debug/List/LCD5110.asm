
;CodeVisionAVR C Compiler V3.51 
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
	.DEF _count=R3
	.DEF _count_msb=R4
	.DEF _count2=R5
	.DEF _count2_msb=R6
	.DEF _hour=R7
	.DEF _hour_msb=R8
	.DEF _min=R9
	.DEF _min_msb=R10
	.DEF _sec=R11
	.DEF _sec_msb=R12
	.DEF _weekday=R13
	.DEF _weekday_msb=R14

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _external_interrupt_isr
	JMP  _external_interrupt1_isr
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x53,0x65,0x74,0x20,0x68,0x6F,0x75,0x72
	.DB  0x0,0x25,0x75,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x53
	.DB  0x65,0x74,0x20,0x6D,0x69,0x6E,0x75,0x74
	.DB  0x65,0x0,0x53,0x65,0x74,0x20,0x64,0x61
	.DB  0x74,0x65,0x0,0x53,0x65,0x74,0x20,0x6D
	.DB  0x6F,0x6E,0x74,0x68,0x0,0x41,0x6C,0x61
	.DB  0x72,0x6D,0x20,0x68,0x6F,0x75,0x72,0x0
	.DB  0x41,0x6C,0x61,0x72,0x6D,0x20,0x6D,0x69
	.DB  0x6E,0x75,0x74,0x65,0x0,0x57,0x61,0x6E
	.DB  0x74,0x20,0x61,0x6E,0x20,0x61,0x6C,0x61
	.DB  0x72,0x6D,0x20,0x3F,0x0,0x4F,0x46,0x46
	.DB  0x0,0x4F,0x4E,0x0,0x25,0x75,0x3A,0x25
	.DB  0x75,0x3A,0x25,0x75,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x25
	.DB  0x75,0x2F,0x25,0x75,0x2F,0x25,0x75,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;void i2c_Begin()
; 0000 001C {

	.CSEG
_i2c_Begin:
; .FSTART _i2c_Begin
; 0000 001D PORTB  |= (1 << SCL_PIN) | (1 << SDA_PIN);
	IN   R30,0x5
	ORI  R30,LOW(0x6)
	OUT  0x5,R30
; 0000 001E DDRB |= (1 << SCL_PIN) | (1 << SDA_PIN);
	IN   R30,0x4
	ORI  R30,LOW(0x6)
	OUT  0x4,R30
; 0000 001F }
	RET
; .FEND
;void setMode(unsigned char mode)
; 0000 0024 {
_setMode:
; .FSTART _setMode
; 0000 0025 if (mode)
	ST   -Y,R17
	MOV  R17,R26
;	mode -> R17
	CPI  R17,0
	BREQ _0x3
; 0000 0026 DDRB |= (1 << SDA_PIN);
	SBI  0x4,2
; 0000 0027 else
	RJMP _0x4
_0x3:
; 0000 0028 DDRB &= ~(1 << SDA_PIN);
	CBI  0x4,2
; 0000 0029 }
_0x4:
	JMP  _0x20A0002
; .FEND
;static void i2c_Clock(void)
; 0000 002E {
_i2c_Clock_G000:
; .FSTART _i2c_Clock_G000
; 0000 002F PORTB  |= (1 << SCL_PIN);
	RCALL SUBOPT_0x0
; 0000 0030 delay_us(4);
; 0000 0031 PORTB  &= ~(1 << SCL_PIN);
	CBI  0x5,1
; 0000 0032 delay_us(5);
	RJMP _0x20A0005
; 0000 0033 }
; .FEND
;void i2cStart(void)
; 0000 0037 {
_i2cStart:
; .FSTART _i2cStart
; 0000 0038 PORTB  |= (1 << SDA_PIN);
	SBI  0x5,2
; 0000 0039 delay_us(4);
	__DELAY_USB 11
; 0000 003A PORTB  |= (1 << SCL_PIN);
	RCALL SUBOPT_0x0
; 0000 003B delay_us(4);
; 0000 003C 
; 0000 003D PORTB  &= ~(1 << SDA_PIN);
	RCALL SUBOPT_0x1
; 0000 003E delay_us(4);
; 0000 003F PORTB  &= ~(1 << SCL_PIN);
	RCALL SUBOPT_0x2
; 0000 0040 delay_us(4);
; 0000 0041 }
	RET
; .FEND
;void i2cStop(void)
; 0000 0045 {
_i2cStop:
; .FSTART _i2cStop
; 0000 0046 PORTB  &= ~(1 << SDA_PIN);
	RCALL SUBOPT_0x1
; 0000 0047 delay_us(4);
; 0000 0048 PORTB  |= (1 << SCL_PIN);
	SBI  0x5,1
; 0000 0049 delay_us(5);
	__DELAY_USB 13
; 0000 004A PORTB  |= (1 << SDA_PIN);
	SBI  0x5,2
; 0000 004B delay_us(5);
_0x20A0005:
	__DELAY_USB 13
; 0000 004C }
	RET
; .FEND
;unsigned int bcd2dec(unsigned int num)
; 0000 004F {
_bcd2dec:
; .FSTART _bcd2dec
; 0000 0050 return ((num / 16 * 10) + (num % 16));
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	num -> R16,R17
	MOVW R30,R16
	RCALL __LSRW4
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	MOVW R26,R30
	MOVW R30,R16
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x20A0004
; 0000 0051 }
; .FEND
;unsigned int dec2bcd(unsigned int num)
; 0000 0054 {
_dec2bcd:
; .FSTART _dec2bcd
; 0000 0055 return ((num / 10 * 16) + (num % 10));
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	num -> R16,R17
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	RCALL __LSLW4
	MOVW R22,R30
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	ADD  R30,R22
	ADC  R31,R23
_0x20A0004:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0056 }
; .FEND
;unsigned int i2cWrite(unsigned int Data)
; 0000 005A {
_i2cWrite:
; .FSTART _i2cWrite
; 0000 005B unsigned int i, x = 0, ack;
; 0000 005C 
; 0000 005D for (i = 0; i < 8; i++)
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR6
;	Data -> Y+6
;	i -> R16,R17
;	x -> R18,R19
;	ack -> R20,R21
	__GETWRN 18,19,0
	__GETWRN 16,17,0
_0x6:
	__CPWRN 16,17,8
	BRSH _0x7
; 0000 005E {
; 0000 005F x = Data & 0x80;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	MOVW R18,R30
; 0000 0060 PORTB  &= ~(1 << SDA_PIN);
	CBI  0x5,2
; 0000 0061 if (x)
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x8
; 0000 0062 PORTB  |= (1 << SDA_PIN);
	SBI  0x5,2
; 0000 0063 i2c_Clock();
_0x8:
	RCALL _i2c_Clock_G000
; 0000 0064 Data = Data << 1;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0065 }
	__ADDWRN 16,17,1
	RJMP _0x6
_0x7:
; 0000 0066 
; 0000 0067 setMode(0);
	LDI  R26,LOW(0)
	RCALL _setMode
; 0000 0068 PORTB  |= (1 << SCL_PIN);
	SBI  0x5,1
; 0000 0069 delay_us(2);
	__DELAY_USB 5
; 0000 006A ack = PINB & (1 << SDA_PIN);
	IN   R30,0x3
	ANDI R30,LOW(0x4)
	MOV  R20,R30
	CLR  R21
; 0000 006B PORTB  &= ~(1 << SCL_PIN);
	RCALL SUBOPT_0x3
; 0000 006C delay_us(5);
; 0000 006D setMode(1);
	LDI  R26,LOW(1)
	RCALL _setMode
; 0000 006E 
; 0000 006F return ack;
	MOVW R30,R20
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 0070 }
; .FEND
;void ds1307_Init(void)
; 0000 0073 {
_ds1307_Init:
; .FSTART _ds1307_Init
; 0000 0074 i2c_Begin();
	RCALL _i2c_Begin
; 0000 0075 i2cStart();
	RCALL SUBOPT_0x4
; 0000 0076 i2cWrite(0xD0);
; 0000 0077 i2cWrite(0x07);
	LDI  R26,LOW(7)
	LDI  R27,0
	RCALL _i2cWrite
; 0000 0078 i2cWrite(0x00);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _i2cWrite
; 0000 0079 i2cStop();
	RJMP _0x20A0003
; 0000 007A }
; .FEND
;unsigned int I2CRead(unsigned int ACK)
; 0000 007E {
_I2CRead:
; .FSTART _I2CRead
; 0000 007F unsigned int i, Data = 0;
; 0000 0080 
; 0000 0081 setMode(0);
	RCALL __SAVELOCR6
	MOVW R20,R26
;	ACK -> R20,R21
;	i -> R16,R17
;	Data -> R18,R19
	__GETWRN 18,19,0
	LDI  R26,LOW(0)
	RCALL _setMode
; 0000 0082 PORTB  &= ~(1 << SCL_PIN);
	RCALL SUBOPT_0x2
; 0000 0083 delay_us(4);
; 0000 0084 for (i = 0; i < 8; i++)
	__GETWRN 16,17,0
_0xA:
	__CPWRN 16,17,8
	BRSH _0xB
; 0000 0085 {
; 0000 0086 PORTB  |= (1 << SCL_PIN);
	SBI  0x5,1
; 0000 0087 Data <<= 1;
	LSL  R18
	ROL  R19
; 0000 0088 if (PINB & (1 << SDA_PIN))
	SBIC 0x3,2
; 0000 0089 Data |= 0x01;
	ORI  R18,LOW(1)
; 0000 008A PORTB  &= ~(1 << SCL_PIN);
	RCALL SUBOPT_0x3
; 0000 008B delay_us(5);
; 0000 008C }
	__ADDWRN 16,17,1
	RJMP _0xA
_0xB:
; 0000 008D 
; 0000 008E setMode(1);
	LDI  R26,LOW(1)
	RCALL _setMode
; 0000 008F if (ACK)
	MOV  R0,R20
	OR   R0,R21
	BREQ _0xD
; 0000 0090 PORTB  &= ~(1 << SDA_PIN);
	CBI  0x5,2
; 0000 0091 else
	RJMP _0xE
_0xD:
; 0000 0092 PORTB  |= (1 << SDA_PIN);
	SBI  0x5,2
; 0000 0093 
; 0000 0094 PORTB  |= (1 << SCL_PIN);
_0xE:
	RCALL SUBOPT_0x0
; 0000 0095 delay_us(4);
; 0000 0096 PORTB  &= ~(1 << SCL_PIN);
	RCALL SUBOPT_0x2
; 0000 0097 delay_us(4);
; 0000 0098 
; 0000 0099 return Data;
	MOVW R30,R18
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; 0000 009A }
; .FEND
;void ds1307_Read()
; 0000 00A0 {
_ds1307_Read:
; .FSTART _ds1307_Read
; 0000 00A1 i2cStart();
	RCALL SUBOPT_0x4
; 0000 00A2 i2cWrite(0xD0);
; 0000 00A3 i2cWrite(0x00);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _i2cWrite
; 0000 00A4 i2cStart();
	RCALL _i2cStart
; 0000 00A5 i2cWrite(0xD1);
	LDI  R26,LOW(209)
	LDI  R27,0
	RCALL _i2cWrite
; 0000 00A6 sec = bcd2dec(I2CRead(1));
	RCALL SUBOPT_0x5
	__PUTW1R 11,12
; 0000 00A7 min = bcd2dec(I2CRead(1));
	RCALL SUBOPT_0x5
	__PUTW1R 9,10
; 0000 00A8 hour = bcd2dec(I2CRead(1));
	RCALL SUBOPT_0x5
	__PUTW1R 7,8
; 0000 00A9 weekday = bcd2dec(I2CRead(1));
	RCALL SUBOPT_0x5
	__PUTW1R 13,14
; 0000 00AA date = bcd2dec(I2CRead(1));
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 00AB month = bcd2dec(I2CRead(1));
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x7
; 0000 00AC year = bcd2dec(I2CRead(0));
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _I2CRead
	MOVW R26,R30
	RCALL _bcd2dec
	RCALL SUBOPT_0x8
; 0000 00AD year += 2000;
	RCALL SUBOPT_0x9
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	RCALL SUBOPT_0x8
; 0000 00AE i2cStop();
_0x20A0003:
	RCALL _i2cStop
; 0000 00AF }
	RET
; .FEND
;void ds1307_SetTime(unsigned int sec, unsigned int min, unsigned int hour)
; 0000 00B2 {
_ds1307_SetTime:
; .FSTART _ds1307_SetTime
; 0000 00B3 i2cStart();
	RCALL SUBOPT_0xA
;	sec -> R20,R21
;	min -> R18,R19
;	hour -> R16,R17
; 0000 00B4 i2cWrite(0xD0);
; 0000 00B5 i2cWrite(0x00);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0xB
; 0000 00B6 i2cWrite(dec2bcd(sec));
; 0000 00B7 i2cStop();
; 0000 00B8 
; 0000 00B9 i2cStart();
; 0000 00BA i2cWrite(0xD0);
; 0000 00BB i2cWrite(0x01);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0xC
; 0000 00BC i2cWrite(dec2bcd(min));
; 0000 00BD i2cStop();
; 0000 00BE 
; 0000 00BF i2cStart();
; 0000 00C0 i2cWrite(0xD0);
; 0000 00C1 i2cWrite(0x02);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0xD
; 0000 00C2 i2cWrite(dec2bcd(hour));
; 0000 00C3 i2cStop();
; 0000 00C4 }
	ADIW R28,10
	RET
; .FEND
;void ds1307_SetDate(unsigned int weekday, unsigned int date, unsigned int month, unsigned int year)
; 0000 00C7 {
_ds1307_SetDate:
; .FSTART _ds1307_SetDate
; 0000 00C8 i2cStart();
	RCALL SUBOPT_0xA
;	weekday -> Y+10
;	date -> R20,R21
;	month -> R18,R19
;	year -> R16,R17
; 0000 00C9 i2cWrite(0xD0);
; 0000 00CA i2cWrite(0x03);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _i2cWrite
; 0000 00CB i2cWrite(dec2bcd(weekday));
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL _dec2bcd
	MOVW R26,R30
	RCALL _i2cWrite
; 0000 00CC i2cStop();
	RCALL _i2cStop
; 0000 00CD 
; 0000 00CE i2cStart();
	RCALL SUBOPT_0x4
; 0000 00CF i2cWrite(0xD0);
; 0000 00D0 i2cWrite(0x04);
	LDI  R26,LOW(4)
	RCALL SUBOPT_0xB
; 0000 00D1 i2cWrite(dec2bcd(date));
; 0000 00D2 i2cStop();
; 0000 00D3 
; 0000 00D4 i2cStart();
; 0000 00D5 i2cWrite(0xD0);
; 0000 00D6 i2cWrite(0x05);
	LDI  R26,LOW(5)
	RCALL SUBOPT_0xC
; 0000 00D7 i2cWrite(dec2bcd(month));
; 0000 00D8 i2cStop();
; 0000 00D9 
; 0000 00DA i2cStart();
; 0000 00DB i2cWrite(0xD0);
; 0000 00DC i2cWrite(0x06);
	LDI  R26,LOW(6)
	RCALL SUBOPT_0xD
; 0000 00DD i2cWrite(dec2bcd(year));
; 0000 00DE i2cStop();
; 0000 00DF }
	ADIW R28,12
	RET
; .FEND
;void mode()
; 0000 00E7 {
_mode:
; .FSTART _mode
; 0000 00E8 PORTB.5 = !PORTB.5;
	SBIS 0x5,5
	RJMP _0xF
	CBI  0x5,5
	RJMP _0x10
_0xF:
	SBI  0x5,5
_0x10:
; 0000 00E9 count = count + 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
; 0000 00EA if(count > 15 )
	RCALL SUBOPT_0xE
	BRGE _0x11
; 0000 00EB count = 0;
	CLR  R3
	CLR  R4
; 0000 00EC delay_ms(500);
_0x11:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL SUBOPT_0xF
; 0000 00ED backlightTimer = 10;
; 0000 00EE }
	RET
; .FEND
;void mode2()
; 0000 00F2 {
_mode2:
; .FSTART _mode2
; 0000 00F3 PORTB.5 = !PORTB.5;
	SBIS 0x5,5
	RJMP _0x12
	CBI  0x5,5
	RJMP _0x13
_0x12:
	SBI  0x5,5
_0x13:
; 0000 00F4 count2 = count2 + 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
; 0000 00F5 if(count2 > 2 )
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R5
	CPC  R31,R6
	BRGE _0x14
; 0000 00F6 count2 = 0;
	CLR  R5
	CLR  R6
; 0000 00F7 delay_ms(150);
_0x14:
	LDI  R26,LOW(150)
	LDI  R27,0
	RCALL SUBOPT_0xF
; 0000 00F8 backlightTimer = 10;
; 0000 00F9 if ((count == 2 || count == 3) && count2 == 1)
	RCALL SUBOPT_0x10
	BREQ _0x16
	RCALL SUBOPT_0x11
	BRNE _0x18
_0x16:
	RCALL SUBOPT_0x12
	BREQ _0x19
_0x18:
	RJMP _0x15
_0x19:
; 0000 00FA {
; 0000 00FB hour += 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 7,8,30,31
; 0000 00FC if (hour > 23)
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	CP   R30,R7
	CPC  R31,R8
	BRGE _0x1A
; 0000 00FD hour = 0;
	CLR  R7
	CLR  R8
; 0000 00FE ds1307_SetTime(sec, min, hour);
_0x1A:
	RCALL SUBOPT_0x13
; 0000 00FF }
; 0000 0100 if ((count == 4 || count == 5) && count2 == 1)
_0x15:
	RCALL SUBOPT_0x14
	BREQ _0x1C
	RCALL SUBOPT_0x15
	BRNE _0x1E
_0x1C:
	RCALL SUBOPT_0x12
	BREQ _0x1F
_0x1E:
	RJMP _0x1B
_0x1F:
; 0000 0101 {
; 0000 0102 min += 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 0103 if (min > 59)
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CP   R30,R9
	CPC  R31,R10
	BRGE _0x20
; 0000 0104 min = 0;
	CLR  R9
	CLR  R10
; 0000 0105 ds1307_SetTime(sec, min, hour);
_0x20:
	RCALL SUBOPT_0x13
; 0000 0106 }
; 0000 0107 if ((count == 6 || count == 7) && count2 == 1)
_0x1B:
	RCALL SUBOPT_0x16
	BREQ _0x22
	RCALL SUBOPT_0x17
	BRNE _0x24
_0x22:
	RCALL SUBOPT_0x12
	BREQ _0x25
_0x24:
	RJMP _0x21
_0x25:
; 0000 0108 {
; 0000 0109 date += 1;
	RCALL SUBOPT_0x18
	ADIW R30,1
	RCALL SUBOPT_0x6
; 0000 010A if (month == 2 && year % 4 ==0){
	RCALL SUBOPT_0x19
	BRNE _0x27
	RCALL SUBOPT_0x1A
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
; 0000 010B if (date > 29){
	RCALL SUBOPT_0x1B
	SBIW R26,30
	BRLT _0x29
; 0000 010C date = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x6
; 0000 010D }
; 0000 010E }
_0x29:
; 0000 010F else if (month == 2 && year % 4 !=0){
	RJMP _0x2A
_0x26:
	RCALL SUBOPT_0x19
	BRNE _0x2C
	RCALL SUBOPT_0x1A
	BRNE _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
; 0000 0110 if (date > 28){
	RCALL SUBOPT_0x1B
	SBIW R26,29
	BRLT _0x2E
; 0000 0111 date = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x6
; 0000 0112 }
; 0000 0113 }
_0x2E:
; 0000 0114 ds1307_SetDate(weekday, date, month, year);
_0x2B:
_0x2A:
	RCALL SUBOPT_0x1C
; 0000 0115 }
; 0000 0116 if ((count == 8 || count == 9) && count2 == 1)
_0x21:
	RCALL SUBOPT_0x1D
	BREQ _0x30
	RCALL SUBOPT_0x1E
	BRNE _0x32
_0x30:
	RCALL SUBOPT_0x12
	BREQ _0x33
_0x32:
	RJMP _0x2F
_0x33:
; 0000 0117 {
; 0000 0118 month += 1;
	RCALL SUBOPT_0x1F
	ADIW R30,1
	RCALL SUBOPT_0x7
; 0000 0119 if (month > 12) {
	LDS  R26,_month
	LDS  R27,_month+1
	SBIW R26,13
	BRLT _0x34
; 0000 011A month = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x7
; 0000 011B }
; 0000 011C ds1307_SetDate(weekday, date, month, year);
_0x34:
	RCALL SUBOPT_0x1C
; 0000 011D }
; 0000 011E 
; 0000 011F if ((count == 10 || count == 11) && count2 == 1)
_0x2F:
	RCALL SUBOPT_0x20
	BREQ _0x36
	RCALL SUBOPT_0x21
	BRNE _0x38
_0x36:
	RCALL SUBOPT_0x12
	BREQ _0x39
_0x38:
	RJMP _0x35
_0x39:
; 0000 0120 {
; 0000 0121 alarm_hour += 1;
	RCALL SUBOPT_0x22
	ADIW R30,1
	STS  _alarm_hour,R30
	STS  _alarm_hour+1,R31
; 0000 0122 if (alarm_hour > 23)
	LDS  R26,_alarm_hour
	LDS  R27,_alarm_hour+1
	SBIW R26,24
	BRLT _0x3A
; 0000 0123 alarm_hour = 0;
	RCALL SUBOPT_0x23
; 0000 0124 }
_0x3A:
; 0000 0125 if ((count == 12 || count == 13) && count2 == 1)
_0x35:
	RCALL SUBOPT_0x24
	BREQ _0x3C
	RCALL SUBOPT_0x25
	BRNE _0x3E
_0x3C:
	RCALL SUBOPT_0x12
	BREQ _0x3F
_0x3E:
	RJMP _0x3B
_0x3F:
; 0000 0126 {
; 0000 0127 alarm_min += 1;
	RCALL SUBOPT_0x26
	ADIW R30,1
	STS  _alarm_min,R30
	STS  _alarm_min+1,R31
; 0000 0128 if (alarm_min > 59)
	LDS  R26,_alarm_min
	LDS  R27,_alarm_min+1
	SBIW R26,60
	BRLT _0x40
; 0000 0129 alarm_min = 0;
	RCALL SUBOPT_0x27
; 0000 012A }
_0x40:
; 0000 012B if ((count == 14 || count == 15) && count2 == 1)
_0x3B:
	RCALL SUBOPT_0x28
	BREQ _0x42
	RCALL SUBOPT_0xE
	BRNE _0x44
_0x42:
	RCALL SUBOPT_0x12
	BREQ _0x45
_0x44:
	RJMP _0x41
_0x45:
; 0000 012C {
; 0000 012D isAlarm += 1;
	RCALL SUBOPT_0x29
	ADIW R30,1
	STS  _isAlarm,R30
	STS  _isAlarm+1,R31
; 0000 012E if (isAlarm > 1)
	RCALL SUBOPT_0x2A
	SBIW R26,2
	BRLT _0x46
; 0000 012F isAlarm = 0;
	LDI  R30,LOW(0)
	STS  _isAlarm,R30
	STS  _isAlarm+1,R30
; 0000 0130 }
_0x46:
; 0000 0131 
; 0000 0132 }
_0x41:
	RET
; .FEND
;interrupt [2] void external_interrupt_isr(void)
; 0000 0135 {
_external_interrupt_isr:
; .FSTART _external_interrupt_isr
	RCALL SUBOPT_0x2B
; 0000 0136 mode();
	RCALL _mode
; 0000 0137 }
	RJMP _0x79
; .FEND
;interrupt [3] void external_interrupt1_isr(void)
; 0000 013A {
_external_interrupt1_isr:
; .FSTART _external_interrupt1_isr
	RCALL SUBOPT_0x2B
; 0000 013B mode2();
	RCALL _mode2
; 0000 013C }
_0x79:
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
;void main(void)
; 0000 013F {
_main:
; .FSTART _main
; 0000 0140 DDRD.4 = 1;
	SBI  0xA,4
; 0000 0141 DDRB = DDRB | 0x20;
	SBI  0x4,5
; 0000 0142 PORTB = PORTB & 0x00;
	IN   R30,0x5
	ANDI R30,LOW(0x0)
	OUT  0x5,R30
; 0000 0143 DDRD &= 0b11110011;   //  D2, D3 is input
	IN   R30,0xA
	ANDI R30,LOW(0xF3)
	OUT  0xA,R30
; 0000 0144 PORTD |= 0b00001100;
	IN   R30,0xB
	ORI  R30,LOW(0xC)
	OUT  0xB,R30
; 0000 0145 
; 0000 0146 EICRA |= 0b00000010;  // falling edge
	LDS  R30,105
	ORI  R30,2
	STS  105,R30
; 0000 0147 EICRA &= 0b11111110;
	LDS  R30,105
	ANDI R30,0xFE
	STS  105,R30
; 0000 0148 
; 0000 0149 EIMSK |= (1 << INT0) | (1 << INT1);  // ngat  ngo�i 0
	IN   R30,0x1D
	ORI  R30,LOW(0x3)
	OUT  0x1D,R30
; 0000 014A 
; 0000 014B #asm("sei")
	SEI
; 0000 014C alarm_hour = 0;
	RCALL SUBOPT_0x23
; 0000 014D alarm_min = 0;
	RCALL SUBOPT_0x27
; 0000 014E hour = 23;
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	__PUTW1R 7,8
; 0000 014F min = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	__PUTW1R 9,10
; 0000 0150 sec = 45;
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	__PUTW1R 11,12
; 0000 0151 weekday = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	__PUTW1R 13,14
; 0000 0152 date = 28;
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	RCALL SUBOPT_0x6
; 0000 0153 month = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x7
; 0000 0154 year = 23;
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	RCALL SUBOPT_0x8
; 0000 0155 ds1307_Init();
	RCALL _ds1307_Init
; 0000 0156 
; 0000 0157 
; 0000 0158 ds1307_SetTime(sec, min, hour);
	RCALL SUBOPT_0x13
; 0000 0159 ds1307_SetDate(weekday, date, month, year);
	RCALL SUBOPT_0x1C
; 0000 015A 
; 0000 015B /* initialize the LCD for 2 lines & 16 columns */
; 0000 015C lcd_i2c_init(PCF8574_I2C_ADDRESS, 16);
	LDI  R30,LOW(39)
	ST   -Y,R30
	LDI  R26,LOW(16)
	RCALL _lcd_i2c_init
; 0000 015D //lcd_backlight(false); // flash the backlight
; 0000 015E 
; 0000 015F while (1)
_0x49:
; 0000 0160 {
; 0000 0161 //PORTD.4 = 1;
; 0000 0162 ds1307_Read();
	RCALL _ds1307_Read
; 0000 0163 
; 0000 0164 if (backlightTimer > 0)
	LDS  R26,_backlightTimer
	LDS  R27,_backlightTimer+1
	__CPW02
	BRSH _0x4C
; 0000 0165 {
; 0000 0166 lcd_backlight(true); // Turn on the backlight
	LDI  R26,LOW(1)
	RCALL _lcd_backlight
; 0000 0167 backlightTimer--; // Decrese remaining backlight timer
	LDI  R26,LOW(_backlightTimer)
	LDI  R27,HIGH(_backlightTimer)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0168 }
; 0000 0169 else
	RJMP _0x4D
_0x4C:
; 0000 016A {
; 0000 016B lcd_backlight(false); // Turn off the backlight
	LDI  R26,LOW(0)
	RCALL _lcd_backlight
; 0000 016C }
_0x4D:
; 0000 016D 
; 0000 016E if (count == 2 || count == 3)
	RCALL SUBOPT_0x10
	BREQ _0x4F
	RCALL SUBOPT_0x11
	BRNE _0x4E
_0x4F:
; 0000 016F {
; 0000 0170 lcd_clear();
	RCALL _lcd_clear
; 0000 0171 lcd_backlight(true);
	LDI  R26,LOW(1)
	RCALL _lcd_backlight
; 0000 0172 lcd_printfxy(0, 0, "Set hour");
	RCALL SUBOPT_0x2C
; 0000 0173 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0174 lcd_printfxy(0, 0, "Set hour");
	RCALL SUBOPT_0x2C
; 0000 0175 lcd_printfxy(0, 1, "%u", hour);
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2E
; 0000 0176 delay_ms(300);
	RCALL SUBOPT_0x2F
; 0000 0177 lcd_printfxy(0, 1, "          ");
	RCALL SUBOPT_0x30
; 0000 0178 delay_ms(300);
; 0000 0179 lcd_printfxy(0, 1, "%u", hour);
	RCALL SUBOPT_0x2E
; 0000 017A }
; 0000 017B 
; 0000 017C else if (count == 4 || count == 5)
	RJMP _0x51
_0x4E:
	RCALL SUBOPT_0x14
	BREQ _0x53
	RCALL SUBOPT_0x15
	BRNE _0x52
_0x53:
; 0000 017D {
; 0000 017E lcd_clear();
	RCALL SUBOPT_0x31
; 0000 017F lcd_printfxy(0, 0, "Set minute");
	RCALL SUBOPT_0x32
; 0000 0180 delay_ms(100);
	RCALL SUBOPT_0x33
; 0000 0181 lcd_printfxy(0, 0, "Set minute");
	RCALL SUBOPT_0x32
; 0000 0182 lcd_printfxy(0, 1, "%u", min);
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x34
; 0000 0183 delay_ms(300);
	RCALL SUBOPT_0x2F
; 0000 0184 lcd_printfxy(0, 1, "          ");
	RCALL SUBOPT_0x30
; 0000 0185 delay_ms(300);
; 0000 0186 lcd_printfxy(0, 1, "%u", min);
	RCALL SUBOPT_0x34
; 0000 0187 }
; 0000 0188 else if (count == 6 || count == 7)
	RJMP _0x55
_0x52:
	RCALL SUBOPT_0x16
	BREQ _0x57
	RCALL SUBOPT_0x17
	BRNE _0x56
_0x57:
; 0000 0189 {
; 0000 018A lcd_clear();
	RCALL SUBOPT_0x31
; 0000 018B lcd_printfxy(0, 0, "Set date");
	RCALL SUBOPT_0x35
; 0000 018C delay_ms(100);
	RCALL SUBOPT_0x33
; 0000 018D lcd_printfxy(0, 0, "Set date");
	RCALL SUBOPT_0x35
; 0000 018E lcd_printfxy(0, 1, "%u", date);
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x36
; 0000 018F delay_ms(300);
	RCALL SUBOPT_0x2F
; 0000 0190 lcd_printfxy(0, 1, "          ");
	RCALL SUBOPT_0x30
; 0000 0191 delay_ms(300);
; 0000 0192 lcd_printfxy(0, 1, "%u", date);
	RCALL SUBOPT_0x36
; 0000 0193 }
; 0000 0194 else if (count == 8 || count == 9)
	RJMP _0x59
_0x56:
	RCALL SUBOPT_0x1D
	BREQ _0x5B
	RCALL SUBOPT_0x1E
	BRNE _0x5A
_0x5B:
; 0000 0195 {
; 0000 0196 lcd_clear();
	RCALL SUBOPT_0x31
; 0000 0197 lcd_printfxy(0, 0, "Set month");
	RCALL SUBOPT_0x37
; 0000 0198 delay_ms(100);
	RCALL SUBOPT_0x33
; 0000 0199 lcd_printfxy(0, 0, "Set month");
	RCALL SUBOPT_0x37
; 0000 019A lcd_printfxy(0, 1, "%u", month);
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x38
; 0000 019B delay_ms(300);
	RCALL SUBOPT_0x2F
; 0000 019C lcd_printfxy(0, 1, "          ");
	RCALL SUBOPT_0x30
; 0000 019D delay_ms(300);
; 0000 019E lcd_printfxy(0, 1, "%u", month);
	RCALL SUBOPT_0x38
; 0000 019F }
; 0000 01A0 else if (count == 10 || count == 11)
	RJMP _0x5D
_0x5A:
	RCALL SUBOPT_0x20
	BREQ _0x5F
	RCALL SUBOPT_0x21
	BRNE _0x5E
_0x5F:
; 0000 01A1 {
; 0000 01A2 lcd_clear();
	RCALL SUBOPT_0x31
; 0000 01A3 lcd_printfxy(0, 0, "Alarm hour");
	RCALL SUBOPT_0x39
; 0000 01A4 delay_ms(100);
	RCALL SUBOPT_0x33
; 0000 01A5 lcd_printfxy(0, 0, "Alarm hour");
	RCALL SUBOPT_0x39
; 0000 01A6 lcd_printfxy(0, 1, "%u", alarm_hour);
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x3A
; 0000 01A7 delay_ms(300);
	RCALL SUBOPT_0x2F
; 0000 01A8 lcd_printfxy(0, 1, "          ");
	RCALL SUBOPT_0x30
; 0000 01A9 delay_ms(300);
; 0000 01AA lcd_printfxy(0, 1, "%u", alarm_hour);
	RCALL SUBOPT_0x3A
; 0000 01AB }
; 0000 01AC else if (count == 12 || count == 13)
	RJMP _0x61
_0x5E:
	RCALL SUBOPT_0x24
	BREQ _0x63
	RCALL SUBOPT_0x25
	BRNE _0x62
_0x63:
; 0000 01AD {
; 0000 01AE lcd_clear();
	RCALL SUBOPT_0x31
; 0000 01AF lcd_printfxy(0, 0, "Alarm minute");
	RCALL SUBOPT_0x3B
; 0000 01B0 delay_ms(100);
	RCALL SUBOPT_0x33
; 0000 01B1 lcd_printfxy(0, 0, "Alarm minute");
	RCALL SUBOPT_0x3B
; 0000 01B2 lcd_printfxy(0, 1, "%u", alarm_min);
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x3C
; 0000 01B3 delay_ms(300);
	RCALL SUBOPT_0x2F
; 0000 01B4 lcd_printfxy(0, 1, "          ");
	RCALL SUBOPT_0x30
; 0000 01B5 delay_ms(300);
; 0000 01B6 lcd_printfxy(0, 1, "%u", alarm_min);
	RCALL SUBOPT_0x3C
; 0000 01B7 }
; 0000 01B8 else if (count == 14 || count == 15)
	RJMP _0x65
_0x62:
	RCALL SUBOPT_0x28
	BREQ _0x67
	RCALL SUBOPT_0xE
	BRNE _0x66
_0x67:
; 0000 01B9 {
; 0000 01BA lcd_clear();
	RCALL SUBOPT_0x31
; 0000 01BB lcd_printfxy(0, 0, "Want an alarm ?");
	RCALL SUBOPT_0x3D
; 0000 01BC delay_ms(100);
	RCALL SUBOPT_0x33
; 0000 01BD lcd_printfxy(0, 0, "Want an alarm ?");
	RCALL SUBOPT_0x3D
; 0000 01BE if (isAlarm == 0)
	RCALL SUBOPT_0x29
	SBIW R30,0
	BRNE _0x69
; 0000 01BF {
; 0000 01C0 lcd_printfxy(0, 1, "OFF");
	RCALL SUBOPT_0x2D
	__POINTW1FN _0x0,93
	RCALL SUBOPT_0x3E
; 0000 01C1 delay_ms(300);
; 0000 01C2 lcd_printfxy(0, 1, "          ");
	RCALL SUBOPT_0x30
; 0000 01C3 delay_ms(300);
; 0000 01C4 lcd_printfxy(0, 1, "OFF");
	__POINTW1FN _0x0,93
	RJMP _0x78
; 0000 01C5 }
; 0000 01C6 else if(isAlarm == 1)
_0x69:
	RCALL SUBOPT_0x2A
	SBIW R26,1
	BRNE _0x6B
; 0000 01C7 {
; 0000 01C8 lcd_printfxy(0, 1, "ON");
	RCALL SUBOPT_0x2D
	__POINTW1FN _0x0,97
	RCALL SUBOPT_0x3E
; 0000 01C9 delay_ms(300);
; 0000 01CA lcd_printfxy(0, 1, "          ");
	RCALL SUBOPT_0x30
; 0000 01CB delay_ms(300);
; 0000 01CC lcd_printfxy(0, 1, "ON");
	__POINTW1FN _0x0,97
_0x78:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
; 0000 01CD }
; 0000 01CE }
_0x6B:
; 0000 01CF else
	RJMP _0x6C
_0x66:
; 0000 01D0 {
; 0000 01D1 // Display time
; 0000 01D2 if (count == 0 || count == 1)
	CLR  R0
	CP   R0,R3
	CPC  R0,R4
	BREQ _0x6E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R3
	CPC  R31,R4
	BRNE _0x6D
_0x6E:
; 0000 01D3 {
; 0000 01D4 ds1307_Read();
	RCALL _ds1307_Read
; 0000 01D5 lcd_printfxy(0, 0, "%u:%u:%u          ", hour, min, sec);  //print the counter variable
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW1FN _0x0,100
	ST   -Y,R31
	ST   -Y,R30
	__GETW1R 7,8
	RCALL SUBOPT_0x3F
	__GETW1R 9,10
	RCALL SUBOPT_0x3F
	__GETW1R 11,12
	RCALL SUBOPT_0x3F
	LDI  R24,12
	RCALL _lcd_printfxy
	ADIW R28,16
; 0000 01D6 lcd_printfxy(0, 1, "%u/%u/%u          ", date, month, year);
	RCALL SUBOPT_0x2D
	__POINTW1FN _0x0,119
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x3F
	LDI  R24,12
	RCALL _lcd_printfxy
	ADIW R28,16
; 0000 01D7 //lcd_backlight(true);
; 0000 01D8 }
; 0000 01D9 }
_0x6D:
_0x6C:
_0x65:
_0x61:
_0x5D:
_0x59:
_0x55:
_0x51:
; 0000 01DA 
; 0000 01DB // Alarm is on
; 0000 01DC if (hour == alarm_hour && min == alarm_min && isAlarm == 1)
	RCALL SUBOPT_0x22
	CP   R30,R7
	CPC  R31,R8
	BRNE _0x71
	RCALL SUBOPT_0x26
	CP   R30,R9
	CPC  R31,R10
	BRNE _0x71
	RCALL SUBOPT_0x2A
	SBIW R26,1
	BREQ _0x72
_0x71:
	RJMP _0x70
_0x72:
; 0000 01DD {
; 0000 01DE PORTD.4 = 1;
	SBI  0xB,4
; 0000 01DF delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 01E0 PORTD.4 = 0;
	CBI  0xB,4
; 0000 01E1 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 01E2 }
; 0000 01E3 }
_0x70:
	RJMP _0x49
; 0000 01E4 }
_0x77:
	RJMP _0x77
; .FEND
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

	.DSEG

	.CSEG
__lcd_setbit_G100:
; .FSTART __lcd_setbit_G100
	RCALL SUBOPT_0x40
	LDS  R26,_bus_data_G100
	RCALL SUBOPT_0x41
	RJMP _0x20A0002
; .FEND
__lcd_clrbit_G100:
; .FSTART __lcd_clrbit_G100
	RCALL SUBOPT_0x40
	COM  R30
	LDS  R26,_bus_data_G100
	AND  R30,R26
	RCALL SUBOPT_0x42
	RJMP _0x20A0002
; .FEND
__lcd_write_nibble_hi_G100:
; .FSTART __lcd_write_nibble_hi_G100
	ST   -Y,R17
	MOV  R17,R26
	LDS  R30,__pcf8574_addr_G100
	ST   -Y,R30
	LDS  R30,_bus_data_G100
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	RCALL SUBOPT_0x41
	LDI  R26,LOW(4)
	RCALL __lcd_setbit_G100
	LDI  R26,LOW(4)
	RCALL __lcd_clrbit_G100
	RJMP _0x20A0002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_hi_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_hi_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	RCALL SUBOPT_0x43
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	STS  __lcd_x,R16
	STS  __lcd_y,R17
	RJMP _0x20A0001
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x44
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x44
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x20A0002
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDI  R26,LOW(1)
	RCALL __lcd_setbit_G100
	MOV  R26,R17
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_clrbit_G100
	RJMP _0x20A0002
; .FEND
_lcd_backlight:
; .FSTART _lcd_backlight
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,0
	BREQ _0x2000011
	LDI  R26,LOW(8)
	RCALL __lcd_setbit_G100
	RJMP _0x2000012
_0x2000011:
	LDI  R26,LOW(8)
	RCALL __lcd_clrbit_G100
_0x2000012:
_0x20A0002:
	LD   R17,Y+
	RET
; .FEND
_lcd_i2c_init:
; .FSTART _lcd_i2c_init
	RCALL SUBOPT_0x43
	STS  __pcf8574_addr_G100,R16
	RCALL _i2c_init
	LDS  R30,__pcf8574_addr_G100
	ST   -Y,R30
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x42
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x45
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_hi_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	RJMP _0x20A0001
; .FEND

	.CSEG
_pcf8574_write:
; .FSTART _pcf8574_write
	RCALL SUBOPT_0x43
	RCALL _i2c_start
	MOV  R30,R16
	LSL  R30
	MOV  R26,R30
	RCALL _i2c_write
	MOV  R26,R17
	RCALL _i2c_write
	RCALL _i2c_stop
_0x20A0001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
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
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x204001C:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x204001E
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040022
	CPI  R18,37
	BRNE _0x2040023
	LDI  R17,LOW(1)
	RJMP _0x2040024
_0x2040023:
	RCALL SUBOPT_0x46
_0x2040024:
	RJMP _0x2040021
_0x2040022:
	CPI  R30,LOW(0x1)
	BRNE _0x2040025
	CPI  R18,37
	BRNE _0x2040026
	RCALL SUBOPT_0x46
	RJMP _0x20400D2
_0x2040026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040027
	LDI  R16,LOW(1)
	RJMP _0x2040021
_0x2040027:
	CPI  R18,43
	BRNE _0x2040028
	LDI  R20,LOW(43)
	RJMP _0x2040021
_0x2040028:
	CPI  R18,32
	BRNE _0x2040029
	LDI  R20,LOW(32)
	RJMP _0x2040021
_0x2040029:
	RJMP _0x204002A
_0x2040025:
	CPI  R30,LOW(0x2)
	BRNE _0x204002B
_0x204002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x204002C
	ORI  R16,LOW(128)
	RJMP _0x2040021
_0x204002C:
	RJMP _0x204002D
_0x204002B:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x2040021
_0x204002D:
	CPI  R18,48
	BRLO _0x2040030
	CPI  R18,58
	BRLO _0x2040031
_0x2040030:
	RJMP _0x204002F
_0x2040031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040021
_0x204002F:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040035
	RCALL SUBOPT_0x47
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x48
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x73)
	BRNE _0x2040038
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x49
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040039
_0x2040038:
	CPI  R30,LOW(0x70)
	BRNE _0x204003B
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x49
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040039:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x204003C
_0x204003B:
	CPI  R30,LOW(0x64)
	BREQ _0x204003F
	CPI  R30,LOW(0x69)
	BRNE _0x2040040
_0x204003F:
	ORI  R16,LOW(4)
	RJMP _0x2040041
_0x2040040:
	CPI  R30,LOW(0x75)
	BRNE _0x2040042
_0x2040041:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x2040043
_0x2040042:
	CPI  R30,LOW(0x58)
	BRNE _0x2040045
	ORI  R16,LOW(8)
	RJMP _0x2040046
_0x2040045:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040077
_0x2040046:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x2040043:
	SBRS R16,2
	RJMP _0x2040048
	RCALL SUBOPT_0x47
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040049
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040049:
	CPI  R20,0
	BREQ _0x204004A
	SUBI R17,-LOW(1)
	RJMP _0x204004B
_0x204004A:
	ANDI R16,LOW(251)
_0x204004B:
	RJMP _0x204004C
_0x2040048:
	RCALL SUBOPT_0x47
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	__GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x204004C:
_0x204003C:
	SBRC R16,0
	RJMP _0x204004D
_0x204004E:
	CP   R17,R21
	BRSH _0x2040050
	SBRS R16,7
	RJMP _0x2040051
	SBRS R16,2
	RJMP _0x2040052
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2040053
_0x2040052:
	LDI  R18,LOW(48)
_0x2040053:
	RJMP _0x2040054
_0x2040051:
	LDI  R18,LOW(32)
_0x2040054:
	RCALL SUBOPT_0x46
	SUBI R21,LOW(1)
	RJMP _0x204004E
_0x2040050:
_0x204004D:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x2040055
_0x2040056:
	CPI  R19,0
	BREQ _0x2040058
	SBRS R16,3
	RJMP _0x2040059
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x204005A
_0x2040059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x204005A:
	RCALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x204005B
	SUBI R21,LOW(1)
_0x204005B:
	SUBI R19,LOW(1)
	RJMP _0x2040056
_0x2040058:
	RJMP _0x204005C
_0x2040055:
_0x204005E:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040060:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2040062
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2040060
_0x2040062:
	CPI  R18,58
	BRLO _0x2040063
	SBRS R16,3
	RJMP _0x2040064
	SUBI R18,-LOW(7)
	RJMP _0x2040065
_0x2040064:
	SUBI R18,-LOW(39)
_0x2040065:
_0x2040063:
	SBRC R16,4
	RJMP _0x2040067
	CPI  R18,49
	BRSH _0x2040069
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040068
_0x2040069:
	RJMP _0x20400D3
_0x2040068:
	CP   R21,R19
	BRLO _0x204006D
	SBRS R16,0
	RJMP _0x204006E
_0x204006D:
	RJMP _0x204006C
_0x204006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x204006F
	LDI  R18,LOW(48)
_0x20400D3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040070
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x48
	CPI  R21,0
	BREQ _0x2040071
	SUBI R21,LOW(1)
_0x2040071:
_0x2040070:
_0x204006F:
_0x2040067:
	RCALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x2040072
	SUBI R21,LOW(1)
_0x2040072:
_0x204006C:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x204005F
	RJMP _0x204005E
_0x204005F:
_0x204005C:
	SBRS R16,0
	RJMP _0x2040073
_0x2040074:
	CPI  R21,0
	BREQ _0x2040076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x48
	RJMP _0x2040074
_0x2040076:
_0x2040073:
_0x2040077:
_0x2040036:
_0x20400D2:
	LDI  R17,LOW(0)
_0x2040021:
	RJMP _0x204001C
_0x204001E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_put_lcd_G102:
; .FSTART _put_lcd_G102
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _lcd_putchar
	MOVW R26,R16
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
_lcd_printfxy:
; .FSTART _lcd_printfxy
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	MOVW R30,R28
	__ADDW1R15
	LDD  R19,Z+12
	LDD  R18,Z+13
	MOVW R26,R28
	ADIW R26,6
	__ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	STD  Y+8,R30
	STD  Y+8+1,R30
	ST   -Y,R18
	MOV  R26,R19
	RCALL _lcd_gotoxy
	MOVW R26,R28
	ADIW R26,10
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_lcd_G102)
	LDI  R31,HIGH(_put_lcd_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_date:
	.BYTE 0x2
_month:
	.BYTE 0x2
_year:
	.BYTE 0x2
_alarm_hour:
	.BYTE 0x2
_alarm_min:
	.BYTE 0x2
_backlightTimer:
	.BYTE 0x2
_isAlarm:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__pcf8574_addr_G100:
	.BYTE 0x1
_bus_data_G100:
	.BYTE 0x1
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	SBI  0x5,1
	__DELAY_USB 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CBI  0x5,2
	__DELAY_USB 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	CBI  0x5,1
	__DELAY_USB 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CBI  0x5,1
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	RCALL _i2cStart
	LDI  R26,LOW(208)
	LDI  R27,0
	RJMP _i2cWrite

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _I2CRead
	MOVW R26,R30
	RJMP _bcd2dec

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	STS  _date,R30
	STS  _date+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	STS  _month,R30
	STS  _month+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	STS  _year,R30
	STS  _year+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R30,_year
	LDS  R31,_year+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	RCALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	__GETWRS 20,21,8
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R27,0
	RCALL _i2cWrite
	MOVW R26,R20
	RCALL _dec2bcd
	MOVW R26,R30
	RCALL _i2cWrite
	RCALL _i2cStop
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R27,0
	RCALL _i2cWrite
	MOVW R26,R18
	RCALL _dec2bcd
	MOVW R26,R30
	RCALL _i2cWrite
	RCALL _i2cStop
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R27,0
	RCALL _i2cWrite
	MOVW R26,R16
	RCALL _dec2bcd
	MOVW R26,R30
	RCALL _i2cWrite
	RCALL _i2cStop
	RCALL __LOADLOCR6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	RCALL _delay_ms
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _backlightTimer,R30
	STS  _backlightTimer+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R5
	CPC  R31,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x13:
	ST   -Y,R12
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R9
	__GETW2R 7,8
	RJMP _ds1307_SetTime

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x18:
	LDS  R30,_date
	LDS  R31,_date+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	LDS  R26,_month
	LDS  R27,_month+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDS  R26,_year
	LDS  R27,_year+1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDS  R26,_date
	LDS  R27,_date+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1C:
	ST   -Y,R14
	ST   -Y,R13
	RCALL SUBOPT_0x18
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_month
	LDS  R31,_month+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_year
	LDS  R27,_year+1
	RJMP _ds1307_SetDate

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	LDS  R30,_month
	LDS  R31,_month+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	LDS  R30,_alarm_hour
	LDS  R31,_alarm_hour+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(0)
	STS  _alarm_hour,R30
	STS  _alarm_hour+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x26:
	LDS  R30,_alarm_min
	LDS  R31,_alarm_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	STS  _alarm_min,R30
	STS  _alarm_min+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDS  R30,_isAlarm
	LDS  R31,_isAlarm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	LDS  R26,_isAlarm
	LDS  R27,_isAlarm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2B:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:70 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2E:
	__POINTW1FN _0x0,9
	ST   -Y,R31
	ST   -Y,R30
	__GETW1R 7,8
	__CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printfxy
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x30:
	__POINTW1FN _0x0,12
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x31:
	RCALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x32:
	__POINTW1FN _0x0,23
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x34:
	__POINTW1FN _0x0,9
	ST   -Y,R31
	ST   -Y,R30
	__GETW1R 9,10
	__CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printfxy
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x36:
	__POINTW1FN _0x0,9
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x18
	__CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printfxy
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x37:
	__POINTW1FN _0x0,43
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x38:
	__POINTW1FN _0x0,9
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x1F
	__CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printfxy
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x39:
	__POINTW1FN _0x0,53
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3A:
	__POINTW1FN _0x0,9
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x22
	__CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printfxy
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3B:
	__POINTW1FN _0x0,64
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3C:
	__POINTW1FN _0x0,9
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x26
	__CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printfxy
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3D:
	__POINTW1FN _0x0,77
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printfxy
	ADIW R28,4
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3F:
	__CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	ST   -Y,R17
	MOV  R17,R26
	LDS  R30,__pcf8574_addr_G100
	ST   -Y,R30
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	OR   R30,R26
	STS  _bus_data_G100,R30
	MOV  R26,R30
	RJMP _pcf8574_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	STS  _bus_data_G100,R30
	MOV  R26,R30
	RJMP _pcf8574_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_hi_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x46:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x47:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x48:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x49:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
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

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

	.equ __scl_bit=5
	.equ __sda_bit=4
	.equ __i2c_port_scl=0x08
	.equ __i2c_dir_scl=__i2c_port_scl-1
	.equ __i2c_pin_scl=__i2c_port_scl-2
	.equ __i2c_port_sda=0x08
	.equ __i2c_dir_sda=__i2c_port_sda-1
	.equ __i2c_pin_sda=__i2c_port_sda-2

_i2c_init:
	cbi  __i2c_port_scl,__scl_bit
	cbi  __i2c_port_sda,__sda_bit
	sbi  __i2c_dir_scl,__scl_bit
	cbi  __i2c_dir_sda,__sda_bit
	rjmp __i2c_delay2

_i2c_start:
	cbi  __i2c_dir_sda,__sda_bit
	cbi  __i2c_dir_scl,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin_sda,__sda_bit
	ret
	sbis __i2c_pin_scl,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir_sda,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir_scl,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,5
	rjmp __i2c_delay2l

_i2c_stop:
	sbi  __i2c_dir_sda,__sda_bit
	sbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir_sda,__sda_bit
__i2c_delay2:
	ldi  r22,10
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret

_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin_scl,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin_sda,__sda_bit
	sec
	sbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	tst  r26
	brne __i2c_read1
	cbi  __i2c_dir_sda,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir_sda,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir_sda,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir_sda,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir_sda,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin_scl,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir_scl,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir_sda,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir_scl,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin_sda,__sda_bit
	clr  r30
	sbi  __i2c_dir_scl,__scl_bit
	rjmp __i2c_delay1

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
