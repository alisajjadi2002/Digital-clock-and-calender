
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 16/000000 MHz
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
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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
	JMP  _timer1_compa_isr
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

_sevenSegment:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90

_0x3:
	.DB  0x2
_0x4:
	.DB  0x1
_0x5:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _yearh
	.DW  _0x3*2

	.DW  0x01
	.DW  _mony
	.DW  _0x4*2

	.DW  0x01
	.DW  _dayy
	.DW  _0x5*2

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
	LDI  R26,__SRAM_START
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
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define BUTTON_INC_PIN   0
;#define BUTTON_DEC_PIN   1
;#define BUTTON_BREAK_PIN 2
;
;// Common Anode: active-low segment patterns
;// PORTB: bit0=a, bit1=b, bit2=c, bit3=d,
;//        bit4=e, bit5=f, bit6=g, bit7=dp
;
;const unsigned char sevenSegment[10] = {
;    0xC0,  // 0
;    0xF9,  // 1
;    0xA4,  // 2
;    0xB0,  // 3
;    0x99,  // 4
;    0x92,  // 5
;    0x82,  // 6
;    0xF8,  // 7
;    0x80,  // 8
;    0x90   // 9
;};
;
;// Time digits
;volatile unsigned char secy = 0;
;volatile unsigned char secd = 0;
;
;volatile unsigned char miny = 0;
;volatile unsigned char mind = 0;
;
;volatile unsigned char hry = 0;
;volatile unsigned char hrd = 0;
;
;// Date digits
;// Year: yearh years yeard yeary
;volatile unsigned char yeary = 0;
;volatile unsigned char yeard = 0;
;volatile unsigned char years = 0;
;volatile unsigned char yearh = 2;

	.DSEG
;
;volatile unsigned char mony = 1;
;volatile unsigned char mond = 0;
;
;volatile unsigned char dayy = 1;
;volatile unsigned char dayd = 0;
;
;
;// --------------------------------------------------
;// Button functions
;// --------------------------------------------------
;
;unsigned char is_button_pressed(unsigned char pin)
; 0000 0037 {

	.CSEG
_is_button_pressed:
; .FSTART _is_button_pressed
; 0000 0038     return ((PINA & (1 << pin)) == 0);
	ST   -Y,R26
;	pin -> Y+0
	IN   R1,25
	LD   R30,Y
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	ADIW R28,1
	RET
; 0000 0039 }
; .FEND
;
;
;// --------------------------------------------------
;// Digit selection
;//
;// Digits 0-7: PORTC.0 to PORTC.7
;// Digits 8-13: PORTD.0 to PORTD.5
;// Assumption: digit enable is active-high.
;// --------------------------------------------------
;
;void select_digit(unsigned char digit, unsigned char state)
; 0000 0045 {
_select_digit:
; .FSTART _select_digit
; 0000 0046     if (digit < 8)
	ST   -Y,R26
;	digit -> Y+1
;	state -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x8)
	BRSH _0x6
; 0000 0047     {
; 0000 0048         if (state)
	LD   R30,Y
	CPI  R30,0
	BREQ _0x7
; 0000 0049             PORTC |= (1 << digit);
	IN   R1,21
	LDD  R30,Y+1
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	RJMP _0x6B
; 0000 004A         else
_0x7:
; 0000 004B             PORTC &= ~(1 << digit);
	IN   R1,21
	LDD  R30,Y+1
	LDI  R26,LOW(1)
	CALL __LSLB12
	COM  R30
	AND  R30,R1
_0x6B:
	OUT  0x15,R30
; 0000 004C     }
; 0000 004D     else if (digit < 14)
	RJMP _0x9
_0x6:
	LDD  R26,Y+1
	CPI  R26,LOW(0xE)
	BRSH _0xA
; 0000 004E     {
; 0000 004F         if (state)
	LD   R30,Y
	CPI  R30,0
	BREQ _0xB
; 0000 0050             PORTD |= (1 << (digit - 8));
	RCALL SUBOPT_0x0
	OR   R30,R1
	RJMP _0x6C
; 0000 0051         else
_0xB:
; 0000 0052             PORTD &= ~(1 << (digit - 8));
	RCALL SUBOPT_0x0
	COM  R30
	AND  R30,R1
_0x6C:
	OUT  0x12,R30
; 0000 0053     }
; 0000 0054 }
_0xA:
_0x9:
	RJMP _0x2000002
; .FEND
;
;
;void all_digits_off(void)
; 0000 0058 {
_all_digits_off:
; .FSTART _all_digits_off
; 0000 0059     PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 005A     PORTD &= 0xC0;
	IN   R30,0x12
	ANDI R30,LOW(0xC0)
	OUT  0x12,R30
; 0000 005B }
	RET
; .FEND
;
;
;void display_digit(unsigned char digit, unsigned char value)
; 0000 005F {
_display_digit:
; .FSTART _display_digit
; 0000 0060     if (value > 9)
	ST   -Y,R26
;	digit -> Y+1
;	value -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRLO _0xD
; 0000 0061         value = 0;
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 0062 
; 0000 0063     all_digits_off();
_0xD:
	RCALL _all_digits_off
; 0000 0064 
; 0000 0065     PORTB = sevenSegment[value];
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_sevenSegment*2)
	SBCI R31,HIGH(-_sevenSegment*2)
	LPM  R0,Z
	OUT  0x18,R0
; 0000 0066 
; 0000 0067     select_digit(digit, 1);
	LDD  R30,Y+1
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _select_digit
; 0000 0068     delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0069     select_digit(digit, 0);
	LDD  R30,Y+1
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _select_digit
; 0000 006A }
_0x2000002:
	ADIW R28,2
	RET
; .FEND
;
;
;// --------------------------------------------------
;// Read a digit using the buttons
;// INC: PA0
;// DEC: PA1
;// BREAK: PA2
;// --------------------------------------------------
;
;unsigned char getval(unsigned char max,
; 0000 0075                      unsigned char digit)
; 0000 0076 {
_getval:
; .FSTART _getval
; 0000 0077     unsigned char counter = 0;
; 0000 0078 
; 0000 0079     while (1)
	ST   -Y,R26
	ST   -Y,R17
;	max -> Y+2
;	digit -> Y+1
;	counter -> R17
	LDI  R17,0
_0xE:
; 0000 007A     {
; 0000 007B         display_digit(digit, counter);
	RCALL SUBOPT_0x1
; 0000 007C 
; 0000 007D         if (is_button_pressed(BUTTON_INC_PIN))
	RCALL SUBOPT_0x2
	BREQ _0x11
; 0000 007E         {
; 0000 007F             delay_ms(20);
	RCALL SUBOPT_0x3
; 0000 0080 
; 0000 0081             if (is_button_pressed(BUTTON_INC_PIN))
	RCALL SUBOPT_0x2
	BREQ _0x12
; 0000 0082             {
; 0000 0083                 if (counter < max)
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0x13
; 0000 0084                     counter++;
	SUBI R17,-1
; 0000 0085 
; 0000 0086                 while (is_button_pressed(BUTTON_INC_PIN))
_0x13:
_0x14:
	RCALL SUBOPT_0x2
	BREQ _0x16
; 0000 0087                     display_digit(digit, counter);
	RCALL SUBOPT_0x1
	RJMP _0x14
_0x16:
; 0000 0088 }
; 0000 0089         }
_0x12:
; 0000 008A 
; 0000 008B         if (is_button_pressed(BUTTON_DEC_PIN))
_0x11:
	RCALL SUBOPT_0x4
	BREQ _0x17
; 0000 008C         {
; 0000 008D             delay_ms(20);
	RCALL SUBOPT_0x3
; 0000 008E 
; 0000 008F             if (is_button_pressed(BUTTON_DEC_PIN))
	RCALL SUBOPT_0x4
	BREQ _0x18
; 0000 0090             {
; 0000 0091                 if (counter > 0)
	CPI  R17,1
	BRLO _0x19
; 0000 0092                     counter--;
	SUBI R17,1
; 0000 0093 
; 0000 0094                 while (is_button_pressed(BUTTON_DEC_PIN))
_0x19:
_0x1A:
	RCALL SUBOPT_0x4
	BREQ _0x1C
; 0000 0095                     display_digit(digit, counter);
	RCALL SUBOPT_0x1
	RJMP _0x1A
_0x1C:
; 0000 0096 }
; 0000 0097         }
_0x18:
; 0000 0098 
; 0000 0099         if (is_button_pressed(BUTTON_BREAK_PIN))
_0x17:
	RCALL SUBOPT_0x5
	BREQ _0x1D
; 0000 009A         {
; 0000 009B             delay_ms(20);
	RCALL SUBOPT_0x3
; 0000 009C 
; 0000 009D             if (is_button_pressed(BUTTON_BREAK_PIN))
	RCALL SUBOPT_0x5
	BREQ _0x1E
; 0000 009E             {
; 0000 009F                 while (is_button_pressed(BUTTON_BREAK_PIN))
_0x1F:
	RCALL SUBOPT_0x5
	BREQ _0x21
; 0000 00A0                     display_digit(digit, counter);
	RCALL SUBOPT_0x1
	RJMP _0x1F
_0x21:
; 0000 00A2 break;
	RJMP _0x10
; 0000 00A3             }
; 0000 00A4         }
_0x1E:
; 0000 00A5     }
_0x1D:
	RJMP _0xE
_0x10:
; 0000 00A6 
; 0000 00A7     return counter;
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2000001
; 0000 00A8 }
; .FEND
;
;
;// --------------------------------------------------
;// Calendar functions
;// --------------------------------------------------
;
;unsigned char days_in_month(unsigned char month,
; 0000 00B0                             unsigned int year)
; 0000 00B1 {
_days_in_month:
; .FSTART _days_in_month
; 0000 00B2     switch (month)
	ST   -Y,R27
	ST   -Y,R26
;	month -> Y+2
;	year -> Y+0
	LDD  R30,Y+2
	LDI  R31,0
; 0000 00B3     {
; 0000 00B4         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x26
; 0000 00B5         case 3:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x27
_0x26:
; 0000 00B6         case 5:
	RJMP _0x28
_0x27:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x29
_0x28:
; 0000 00B7         case 7:
	RJMP _0x2A
_0x29:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2B
_0x2A:
; 0000 00B8         case 8:
	RJMP _0x2C
_0x2B:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2D
_0x2C:
; 0000 00B9         case 10:
	RJMP _0x2E
_0x2D:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x2F
_0x2E:
; 0000 00BA         case 12:
	RJMP _0x30
_0x2F:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x31
_0x30:
; 0000 00BB             return 31;
	LDI  R30,LOW(31)
	RJMP _0x2000001
; 0000 00BC 
; 0000 00BD         case 4:
_0x31:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x33
; 0000 00BE         case 6:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x34
_0x33:
; 0000 00BF         case 9:
	RJMP _0x35
_0x34:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x36
_0x35:
; 0000 00C0         case 11:
	RJMP _0x37
_0x36:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x38
_0x37:
; 0000 00C1             return 30;
	LDI  R30,LOW(30)
	RJMP _0x2000001
; 0000 00C2 
; 0000 00C3         case 2:
_0x38:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3F
; 0000 00C4             if ((year % 400 == 0) ||
; 0000 00C5                 ((year % 4 == 0) && (year % 100 != 0)))
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL __MODW21U
	SBIW R30,0
	BREQ _0x3B
	LD   R30,Y
	ANDI R30,LOW(0x3)
	BRNE _0x3C
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	SBIW R30,0
	BRNE _0x3B
_0x3C:
	RJMP _0x3A
_0x3B:
; 0000 00C6                 return 29;
	LDI  R30,LOW(29)
	RJMP _0x2000001
; 0000 00C7 
; 0000 00C8             return 28;
_0x3A:
	LDI  R30,LOW(28)
	RJMP _0x2000001
; 0000 00C9 
; 0000 00CA         default:
_0x3F:
; 0000 00CB             return 31;
	LDI  R30,LOW(31)
; 0000 00CC     }
; 0000 00CD }
_0x2000001:
	ADIW R28,3
	RET
; .FEND
;
;
;void increment_date(void)
; 0000 00D1 {
_increment_date:
; .FSTART _increment_date
; 0000 00D2     unsigned int year;
; 0000 00D3     unsigned char month;
; 0000 00D4     unsigned char day;
; 0000 00D5 
; 0000 00D6     year = yearh * 1000U
	CALL __SAVELOCR4
;	year -> R16,R17
;	month -> R19
;	day -> R18
; 0000 00D7          + years * 100U
; 0000 00D8          + yeard * 10U
; 0000 00D9          + yeary;
	LDS  R26,_yearh
	LDI  R27,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MULW12
	MOVW R22,R30
	LDS  R26,_years
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	__ADDWRR 22,23,30,31
	LDS  R26,_yeard
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_yeary
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
; 0000 00DA 
; 0000 00DB     month = mond * 10 + mony;
	LDS  R30,_mond
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	LDS  R26,_mony
	ADD  R30,R26
	MOV  R19,R30
; 0000 00DC     day = dayd * 10 + dayy;
	LDS  R30,_dayd
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	LDS  R26,_dayy
	ADD  R30,R26
	MOV  R18,R30
; 0000 00DD 
; 0000 00DE     if (month < 1 || month > 12)
	CPI  R19,1
	BRLO _0x41
	CPI  R19,13
	BRLO _0x40
_0x41:
; 0000 00DF         month = 1;
	LDI  R19,LOW(1)
; 0000 00E0 
; 0000 00E1     day++;
_0x40:
	SUBI R18,-1
; 0000 00E2 
; 0000 00E3     if (day > days_in_month(month, year))
	ST   -Y,R19
	MOVW R26,R16
	RCALL _days_in_month
	CP   R30,R18
	BRSH _0x43
; 0000 00E4     {
; 0000 00E5         day = 1;
	LDI  R18,LOW(1)
; 0000 00E6         month++;
	SUBI R19,-1
; 0000 00E7 
; 0000 00E8         if (month > 12)
	CPI  R19,13
	BRLO _0x44
; 0000 00E9         {
; 0000 00EA             month = 1;
	LDI  R19,LOW(1)
; 0000 00EB             year++;
	__ADDWRN 16,17,1
; 0000 00EC 
; 0000 00ED             if (year > 9999)
	__CPWRN 16,17,10000
	BRLO _0x45
; 0000 00EE                 year = 0;
	__GETWRN 16,17,0
; 0000 00EF         }
_0x45:
; 0000 00F0     }
_0x44:
; 0000 00F1 
; 0000 00F2     dayd = day / 10;
_0x43:
	MOV  R26,R18
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STS  _dayd,R30
; 0000 00F3     dayy = day % 10;
	MOV  R26,R18
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STS  _dayy,R30
; 0000 00F4 
; 0000 00F5     mond = month / 10;
	MOV  R26,R19
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STS  _mond,R30
; 0000 00F6     mony = month % 10;
	MOV  R26,R19
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STS  _mony,R30
; 0000 00F7 
; 0000 00F8     yearh = year / 1000;
	MOVW R26,R16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	STS  _yearh,R30
; 0000 00F9     years = (year / 100) % 10;
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x6
	STS  _years,R30
; 0000 00FA     yeard = (year / 10) % 10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x6
	STS  _yeard,R30
; 0000 00FB     yeary = year % 10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	STS  _yeary,R30
; 0000 00FC }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;
;// --------------------------------------------------
;// Increment clock by one second
;// --------------------------------------------------
;
;void increase_func(void)
; 0000 0104 {
_increase_func:
; .FSTART _increase_func
; 0000 0105     secy++;
	LDS  R30,_secy
	SUBI R30,-LOW(1)
	STS  _secy,R30
; 0000 0106 
; 0000 0107     if (secy >= 10)
	LDS  R26,_secy
	CPI  R26,LOW(0xA)
	BRSH PC+2
	RJMP _0x46
; 0000 0108     {
; 0000 0109         secy = 0;
	LDI  R30,LOW(0)
	STS  _secy,R30
; 0000 010A         secd++;
	LDS  R30,_secd
	SUBI R30,-LOW(1)
	STS  _secd,R30
; 0000 010B 
; 0000 010C         if (secd >= 6)
	LDS  R26,_secd
	CPI  R26,LOW(0x6)
	BRSH PC+2
	RJMP _0x47
; 0000 010D         {
; 0000 010E             secd = 0;
	LDI  R30,LOW(0)
	STS  _secd,R30
; 0000 010F             miny++;
	LDS  R30,_miny
	SUBI R30,-LOW(1)
	STS  _miny,R30
; 0000 0110 
; 0000 0111             if (miny >= 10)
	LDS  R26,_miny
	CPI  R26,LOW(0xA)
	BRLO _0x48
; 0000 0112             {
; 0000 0113                 miny = 0;
	LDI  R30,LOW(0)
	STS  _miny,R30
; 0000 0114                 mind++;
	LDS  R30,_mind
	SUBI R30,-LOW(1)
	STS  _mind,R30
; 0000 0115 
; 0000 0116                 if (mind >= 6)
	LDS  R26,_mind
	CPI  R26,LOW(0x6)
	BRLO _0x49
; 0000 0117                 {
; 0000 0118                     mind = 0;
	LDI  R30,LOW(0)
	STS  _mind,R30
; 0000 0119                     hry++;
	LDS  R30,_hry
	SUBI R30,-LOW(1)
	STS  _hry,R30
; 0000 011A 
; 0000 011B                     if (hry >= ((hrd == 2) ? 4 : 10))
	LDS  R26,_hrd
	CPI  R26,LOW(0x2)
	BRNE _0x4B
	LDI  R30,LOW(4)
	RJMP _0x4C
_0x4B:
	LDI  R30,LOW(10)
_0x4C:
	LDS  R26,_hry
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x4A
; 0000 011C                     {
; 0000 011D                         hry = 0;
	LDI  R30,LOW(0)
	STS  _hry,R30
; 0000 011E                         hrd++;
	LDS  R30,_hrd
	SUBI R30,-LOW(1)
	STS  _hrd,R30
; 0000 011F 
; 0000 0120                         if (hrd >= 3)
	LDS  R26,_hrd
	CPI  R26,LOW(0x3)
	BRLO _0x4E
; 0000 0121                         {
; 0000 0122                             hrd = 0;
	LDI  R30,LOW(0)
	STS  _hrd,R30
; 0000 0123                             increment_date();
	RCALL _increment_date
; 0000 0124                         }
; 0000 0125                     }
_0x4E:
; 0000 0126                 }
_0x4A:
; 0000 0127             }
_0x49:
; 0000 0128         }
_0x48:
; 0000 0129     }
_0x47:
; 0000 012A }
_0x46:
	RET
; .FEND
;
;
;// --------------------------------------------------
;// Timer1: CTC mode, 1 Hz at 16 MHz
;// Prescaler = 256
;// OCR1A = 62499
;// --------------------------------------------------
;
;void timer1_init(void)
; 0000 0134 {
_timer1_init:
; .FSTART _timer1_init
; 0000 0135     TCCR1A = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0136     TCCR1B = 0x00;
	OUT  0x2E,R30
; 0000 0137 
; 0000 0138     TCNT1H = 0x00;
	OUT  0x2D,R30
; 0000 0139     TCNT1L = 0x00;
	OUT  0x2C,R30
; 0000 013A 
; 0000 013B     OCR1AH = 0xF4;
	LDI  R30,LOW(244)
	OUT  0x2B,R30
; 0000 013C     OCR1AL = 0x23;
	LDI  R30,LOW(35)
	OUT  0x2A,R30
; 0000 013D 
; 0000 013E     // Clear pending Timer1 Compare A flag
; 0000 013F     TIFR = 0x10;
	LDI  R30,LOW(16)
	OUT  0x38,R30
; 0000 0140 
; 0000 0141     // Enable Timer1 Compare A interrupt
; 0000 0142     TIMSK |= 0x10;
	IN   R30,0x39
	ORI  R30,0x10
	OUT  0x39,R30
; 0000 0143 
; 0000 0144     // CTC mode, prescaler 256
; 0000 0145     TCCR1B = 0x0C;
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 0146 
; 0000 0147     #asm("sei")
	sei
; 0000 0148 }
	RET
; .FEND
;
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 014C {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
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
; 0000 014D     increase_func();
	RCALL _increase_func
; 0000 014E }
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
;
;
;// --------------------------------------------------
;// Main program
;// --------------------------------------------------
;
;void main(void)
; 0000 0156 {
_main:
; .FSTART _main
; 0000 0157     unsigned char select = 0;
; 0000 0158 
; 0000 0159     // PORTA: button inputs with internal pull-ups
; 0000 015A     DDRA = 0x00;
;	select -> R17
	LDI  R17,0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 015B     PORTA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 015C 
; 0000 015D     // PORTB: all seven-segment segment outputs
; 0000 015E     DDRB = 0xFF;
	OUT  0x17,R30
; 0000 015F     PORTB = 0xFF;
	OUT  0x18,R30
; 0000 0160 
; 0000 0161     // PORTC: first eight digit-enable outputs
; 0000 0162     DDRC = 0xFF;
	OUT  0x14,R30
; 0000 0163     PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0164 
; 0000 0165     // PORTD.0 - PORTD.5: remaining six digit enables
; 0000 0166     DDRD = 0x3F;
	LDI  R30,LOW(63)
	OUT  0x11,R30
; 0000 0167     PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0168 
; 0000 0169     // ----------------------------------------------
; 0000 016A     // Initial time setup
; 0000 016B     // Press BREAK to confirm each digit.
; 0000 016C     // ----------------------------------------------
; 0000 016D 
; 0000 016E     hrd = getval(2, 0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _getval
	STS  _hrd,R30
; 0000 016F 
; 0000 0170     if (hrd == 2)
	LDS  R26,_hrd
	CPI  R26,LOW(0x2)
	BRNE _0x4F
; 0000 0171         hry = getval(3, 1);
	LDI  R30,LOW(3)
	RJMP _0x6D
; 0000 0172     else
_0x4F:
; 0000 0173         hry = getval(9, 1);
	LDI  R30,LOW(9)
_0x6D:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _getval
	STS  _hry,R30
; 0000 0174 
; 0000 0175     mind = getval(5, 2);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _getval
	STS  _mind,R30
; 0000 0176     miny = getval(9, 3);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _getval
	STS  _miny,R30
; 0000 0177 
; 0000 0178     secd = getval(5, 4);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _getval
	STS  _secd,R30
; 0000 0179     secy = getval(9, 5);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _getval
	STS  _secy,R30
; 0000 017A 
; 0000 017B     // Year: thousands, hundreds, tens, units
; 0000 017C     yearh = getval(9, 6);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(6)
	RCALL _getval
	STS  _yearh,R30
; 0000 017D     years = getval(9, 7);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _getval
	STS  _years,R30
; 0000 017E     yeard = getval(9, 8);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _getval
	STS  _yeard,R30
; 0000 017F     yeary = getval(9, 9);
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(9)
	RCALL _getval
	STS  _yeary,R30
; 0000 0180 
; 0000 0181     // Month: 01-12
; 0000 0182     mond = getval(1, 10);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(10)
	RCALL _getval
	STS  _mond,R30
; 0000 0183 
; 0000 0184     if (mond == 1)
	LDS  R26,_mond
	CPI  R26,LOW(0x1)
	BRNE _0x51
; 0000 0185         mony = getval(2, 11);
	LDI  R30,LOW(2)
	RJMP _0x6E
; 0000 0186     else
_0x51:
; 0000 0187         mony = getval(9, 11);
	LDI  R30,LOW(9)
_0x6E:
	ST   -Y,R30
	LDI  R26,LOW(11)
	RCALL _getval
	STS  _mony,R30
; 0000 0188 
; 0000 0189     // Day: select tens and units
; 0000 018A     dayd = getval(3, 12);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(12)
	RCALL _getval
	STS  _dayd,R30
; 0000 018B 
; 0000 018C     if (dayd == 3)
	LDS  R26,_dayd
	CPI  R26,LOW(0x3)
	BRNE _0x53
; 0000 018D         dayy = getval(1, 13);
	LDI  R30,LOW(1)
	RJMP _0x6F
; 0000 018E     else
_0x53:
; 0000 018F         dayy = getval(9, 13);
	LDI  R30,LOW(9)
_0x6F:
	ST   -Y,R30
	LDI  R26,LOW(13)
	RCALL _getval
	STS  _dayy,R30
; 0000 0190 
; 0000 0191     // Start the clock after setting the date and time
; 0000 0192     timer1_init();
	RCALL _timer1_init
; 0000 0193 
; 0000 0194     // ----------------------------------------------
; 0000 0195     // Display multiplexing
; 0000 0196     //
; 0000 0197     // 0-1:   Hour
; 0000 0198     // 2-3:   Minute
; 0000 0199     // 4-5:   Second
; 0000 019A     // 6-9:   Year
; 0000 019B     // 10-11: Month
; 0000 019C     // 12-13: Day
; 0000 019D     // ----------------------------------------------
; 0000 019E 
; 0000 019F     while (1)
_0x55:
; 0000 01A0     {
; 0000 01A1         switch (select)
	MOV  R30,R17
	LDI  R31,0
; 0000 01A2         {
; 0000 01A3             case 0:  display_digit(0, hrd);   break;
	SBIW R30,0
	BRNE _0x5B
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,_hrd
	RJMP _0x70
; 0000 01A4             case 1:  display_digit(1, hry);   break;
_0x5B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5C
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R26,_hry
	RJMP _0x70
; 0000 01A5 
; 0000 01A6             case 2:  display_digit(2, mind);  break;
_0x5C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5D
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R26,_mind
	RJMP _0x70
; 0000 01A7             case 3:  display_digit(3, miny);  break;
_0x5D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5E
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R26,_miny
	RJMP _0x70
; 0000 01A8 
; 0000 01A9             case 4:  display_digit(4, secd);  break;
_0x5E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x5F
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDS  R26,_secd
	RJMP _0x70
; 0000 01AA             case 5:  display_digit(5, secy);  break;
_0x5F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x60
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDS  R26,_secy
	RJMP _0x70
; 0000 01AB 
; 0000 01AC             case 6:  display_digit(6, yearh); break;
_0x60:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x61
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDS  R26,_yearh
	RJMP _0x70
; 0000 01AD             case 7:  display_digit(7, years); break;
_0x61:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x62
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDS  R26,_years
	RJMP _0x70
; 0000 01AE             case 8:  display_digit(8, yeard); break;
_0x62:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x63
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDS  R26,_yeard
	RJMP _0x70
; 0000 01AF             case 9:  display_digit(9, yeary); break;
_0x63:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x64
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDS  R26,_yeary
	RJMP _0x70
; 0000 01B0 
; 0000 01B1             case 10: display_digit(10, mond); break;
_0x64:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x65
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDS  R26,_mond
	RJMP _0x70
; 0000 01B2             case 11: display_digit(11, mony); break;
_0x65:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x66
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDS  R26,_mony
	RJMP _0x70
; 0000 01B3 
; 0000 01B4             case 12: display_digit(12, dayd); break;
_0x66:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x67
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDS  R26,_dayd
	RJMP _0x70
; 0000 01B5             case 13: display_digit(13, dayy); break;
_0x67:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x5A
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDS  R26,_dayy
_0x70:
	RCALL _display_digit
; 0000 01B6         }
_0x5A:
; 0000 01B7 
; 0000 01B8         select++;
	SUBI R17,-1
; 0000 01B9 
; 0000 01BA         if (select >= 14)
	CPI  R17,14
	BRLO _0x69
; 0000 01BB             select = 0;
	LDI  R17,LOW(0)
; 0000 01BC     }
_0x69:
	RJMP _0x55
; 0000 01BD }
_0x6A:
	RJMP _0x6A
; .FEND

	.DSEG
_secy:
	.BYTE 0x1
_secd:
	.BYTE 0x1
_miny:
	.BYTE 0x1
_mind:
	.BYTE 0x1
_hry:
	.BYTE 0x1
_hrd:
	.BYTE 0x1
_yeary:
	.BYTE 0x1
_yeard:
	.BYTE 0x1
_years:
	.BYTE 0x1
_yearh:
	.BYTE 0x1
_mony:
	.BYTE 0x1
_mond:
	.BYTE 0x1
_dayy:
	.BYTE 0x1
_dayd:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	IN   R1,18
	LDD  R30,Y+1
	SUBI R30,LOW(8)
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDD  R30,Y+1
	ST   -Y,R30
	MOV  R26,R17
	RJMP _display_digit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(0)
	RCALL _is_button_pressed
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(1)
	RCALL _is_button_pressed
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(2)
	RCALL _is_button_pressed
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
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
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
