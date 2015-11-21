# fu-project-smd
Tugas Mata Kuliah Sistem Mikroprosesor Digital Fisika Unpad 2015

Source code : `ProjectSMD.asm`

Proteus File : `Project_SMD.pdsprj`

### WORK IN PROGRESS !
##### Done
1. Port Assignment ADC, LCD, Button Controller, RS232 & Relay
2. LCD Interfacing
3. Button Controller Interfacing
4. ADC data conversion to LCD

##### To do
1. decimal data from adc to temperature
2. Serial Communication via RS232
3. System Integration

## Alur Kerja Sistem
Sensor Suhu --> ADC 0804 --> Mikrokontroler AT89C51 --> LCD & RS232

^-- Heater <-- Relay <-- PB Kontrol <-'   

## Skematik Proteus
![alt text](https://raw.githubusercontent.com/hyuwah/fu-project-smd/master/screenshot.png "Skematik Proteus")

## Referensi
#### LCD
* [LCD Interface](http://8051programming.blogspot.co.id/2014/02/8051-lcd-interface.html)
* [hextoascii converter](http://www.dnatechindia.com/8-bit-HEX-to-ASCII-Convertor.html)
* [CSCI 305/306 (ECE 325/326) - Lab #7: LCD Display and Displaying Numbers](http://mathcs.slu.edu/~fritts/csci305/labs/lab7.html)
* [LCD Interface with 8051](http://ramoliyabiren.blogspot.co.id/2011/12/lcd-16x2-interface-with-8051.html)
* [LCD Tutorial for interfacing with Microcontrollers](http://www.8051projects.net/lcd-interfacing/index.php)
