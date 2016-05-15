EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:wakelight-cache
EELAYER 25 0
EELAYER END
$Descr User 5906 5906
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L ESP-01v090 U1
U 1 1 573872DB
P 2750 1750
F 0 "U1" H 2750 1650 50  0000 C CNN
F 1 "ESP-01v090" H 2750 1850 50  0000 C CNN
F 2 "" H 2750 1750 50  0001 C CNN
F 3 "" H 2750 1750 50  0001 C CNN
	1    2750 1750
	1    0    0    -1  
$EndComp
$Comp
L Earth #PWR2
U 1 1 5738743E
P 3900 2900
F 0 "#PWR2" H 3900 2650 50  0001 C CNN
F 1 "Earth" H 3900 2750 50  0001 C CNN
F 2 "" H 3900 2900 50  0000 C CNN
F 3 "" H 3900 2900 50  0000 C CNN
	1    3900 2900
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR1
U 1 1 573875CD
P 1300 1500
F 0 "#PWR1" H 1300 1350 50  0001 C CNN
F 1 "+3.3V" H 1300 1640 50  0000 C CNN
F 2 "" H 1300 1500 50  0000 C CNN
F 3 "" H 1300 1500 50  0000 C CNN
	1    1300 1500
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X03 P2
U 1 1 57387644
P 4200 1700
F 0 "P2" H 4200 1900 50  0001 C CNN
F 1 "WS2812B LEDs" V 4300 1700 50  0000 C CNN
F 2 "" H 4200 1700 50  0000 C CNN
F 3 "" H 4200 1700 50  0000 C CNN
	1    4200 1700
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR3
U 1 1 57387746
P 4000 1600
F 0 "#PWR3" H 4000 1450 50  0001 C CNN
F 1 "+5V" H 4000 1740 50  0000 C CNN
F 2 "" H 4000 1600 50  0000 C CNN
F 3 "" H 4000 1600 50  0000 C CNN
	1    4000 1600
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 57387CA6
P 1550 1800
F 0 "R1" V 1630 1800 50  0000 C CNN
F 1 "10k" V 1550 1800 50  0000 C CNN
F 2 "" V 1480 1800 50  0000 C CNN
F 3 "" H 1550 1800 50  0000 C CNN
	1    1550 1800
	0    1    1    0   
$EndComp
Wire Wire Line
	3700 2500 3700 1900
Wire Wire Line
	2700 2500 3700 2500
Wire Wire Line
	2700 2850 2700 2500
Wire Wire Line
	2600 2350 2600 2850
Wire Wire Line
	3800 1800 3700 1800
Wire Wire Line
	3800 2350 3800 1800
Wire Wire Line
	2600 2350 3800 2350
Wire Wire Line
	2800 2200 2800 2850
Wire Wire Line
	1800 2200 2800 2200
Wire Wire Line
	1800 1600 1800 2200
Connection ~ 1750 1800
Wire Wire Line
	1750 1800 1750 2500
Connection ~ 1300 1800
Wire Wire Line
	1400 1800 1300 1800
Wire Wire Line
	1700 1800 1800 1800
Wire Wire Line
	2500 2500 2500 2850
Wire Wire Line
	1750 2500 2500 2500
Connection ~ 3900 1800
Wire Wire Line
	4000 1800 3900 1800
Wire Wire Line
	3900 1600 3900 2900
Connection ~ 1300 1700
Wire Wire Line
	1800 1700 1300 1700
Wire Wire Line
	1300 1900 1800 1900
Wire Wire Line
	3700 1700 4000 1700
Wire Wire Line
	3700 1600 3900 1600
Text Label 2500 2700 3    60   ~ 0
RTS
Text Label 2600 2700 3    60   ~ 0
DTR
Text Label 2700 2750 3    60   ~ 0
TX
Text Label 2800 2750 3    60   ~ 0
RX
Wire Wire Line
	1300 1900 1300 1500
$Comp
L CONN_01X05 P?
U 1 1 5738818E
P 2700 3050
F 0 "P?" H 2700 3350 50  0001 C CNN
F 1 "SERIAL" V 2800 3050 50  0000 C CNN
F 2 "" H 2700 3050 50  0000 C CNN
F 3 "" H 2700 3050 50  0000 C CNN
	1    2700 3050
	0    1    1    0   
$EndComp
Wire Wire Line
	3900 2850 2900 2850
Connection ~ 3900 2850
Text Label 2900 2850 0    60   ~ 0
GND
$EndSCHEMATC
