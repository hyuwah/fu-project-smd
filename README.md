# fu-project-smd
Tugas Mata Kuliah Sistem Mikroprosesor Digital Fisika Unpad 2015

## Deskripsi
Sistem pengontrolan suhu pada plant berbasis microcontroler AT89C51.  

Input: 
* Temperatur dari sensor LM35
* 4 PB (Up,Down,Ok,Reset) untuk mengatur setting value dari suhu plant

Output:
* LCD 16x2
* Hyperterminal
* Virtual Com RS232
* Heater (Oven)
* Motor (Fan)

Source code : `ProjectSMD.asm`

Proteus File : `Project_SMD.pdsprj`

Current Version : 0.4

### WORK IN PROGRESS !
##### Done
1. Port Assignment ADC, LCD, Button Controller, RS232 & Relay
2. LCD Interfacing
3. Button Controller Interfacing
4. ADC data conversion to LCD
5. Temperature display on LCD
6. heater logic (plant), present value and setting value
7. Serial communication to hyperterminal

##### To do
1. Serial Communication via RS232 to virtual com
2. save data from virtual com to excel
2. System Integration

## Alur Kerja Sistem
Sensor Suhu --> ADC 0804 --> Mikrokontroler AT89C51 --> LCD & RS232  
^-- Heater <-- Relay <-- PB Kontrol <-'   

## Screenshot
Skematik Proteus:
![alt text](https://raw.githubusercontent.com/hyuwah/fu-project-smd/master/screenshot.png "Skematik Proteus")
Saat Running:
![alt text](https://raw.githubusercontent.com/hyuwah/fu-project-smd/master/screenshot_run.png "Simulasi")

## Referensi
#### LCD
* [LCD Interface](http://8051programming.blogspot.co.id/2014/02/8051-lcd-interface.html)
* [hextoascii converter](http://www.dnatechindia.com/8-bit-HEX-to-ASCII-Convertor.html)
* [CSCI 305/306 (ECE 325/326) - Lab #7: LCD Display and Displaying Numbers](http://mathcs.slu.edu/~fritts/csci305/labs/lab7.html)
* [LCD Interface with 8051](http://ramoliyabiren.blogspot.co.id/2011/12/lcd-16x2-interface-with-8051.html)
* [LCD Tutorial for interfacing with Microcontrollers](http://www.8051projects.net/lcd-interfacing/index.php)

#### Misc
* [If-Else Assembly Gist](https://gist.github.com/kingster/1234734)
