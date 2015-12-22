;-------------------------------------------------------------------
; Kuliah SMD 2015
; M.Wahyudin (140310120031)
;
; Name   : Project SMD
; Desc   :
; Input  : 4 Control PB, 1 Saklar, Sensor Suhu LM35
; Output : LCD, Serial RS232
; Version: 0.7
;-------------------------------------------------------------------

$NOMOD51
$INCLUDE (8051.MCU)

      org   0000h

;========
;Definisi Variabel
;========
;LCD
RS BIT P3.5
RW BIT P3.6
E  BIT P3.7

count equ 33h
countbefore equ 34h
setval equ 45h
memory equ 36h

ratus equ 42h
puluh equ 41h
satu equ 40h

r5sv equ 51h
r6sv equ 52h
r7sv equ 53h

degree equ 43h
celcius equ 44h
mov degree,#0DFh    ; degree symbol
mov celcius,#'C'

sdata equ 46h
mov r5,#30h
mov r6,#30h
mov r7,#30h

;ADC
adc_cs equ P1.4             ;Chip Select P1.4
adc_rd equ P1.5             ;Read signal P1.5
adc_wr equ P1.6             ;Write signal P1.6
adc_intr equ P1.7           ;INTR signal P1.7

adc_port equ P0         ;ADC data pins P0
data_adc equ 30h

;============
;Inisialisasi
;============
mov scon,#52h ;aktifkan port serial, mode 1
mov tmod,#20h ;timer 1, mode 2
mov th1,#-13  ;nilai reload untuk baudrate 2400
setb tr1  ;aktifkan timer 1


setb P1.0
setb P1.1
setb P1.2
setb P1.3

clr P3.4  ;relay off

mov count,#0
mov countbefore, #0
mov setval,#0


;====tampilan awal====

   acall init
   MOV P2,#0CH ; LCD ON, cursor OFF
   ACALL LCDCONTROL

   mov P2,#80H    ; Set cursor line 1 kotak 0
   acall LCDCONTROL
   MOV P2,#'P'
   ACALL LCDDATA
   MOV P2,#'V'
   ACALL LCDDATA
   MOV P2,#':'
   ACALL LCDDATA

   mov P2,#0C0H   ; Set cursor line 2
   acall LCDCONTROL
   MOV P2,#'S'
   ACALL LCDDATA
   MOV P2,#'V'
   ACALL LCDDATA
   MOV P2,#':'
   ACALL LCDDATA

   mov count, setval
   lcall hextoascii
   mov p2,#0C3h
   ACALL LCDCONTROL
   ljmp print

;=========
;Main Loop
;=========

Loop:
   lcall scom_send
   acall get_adc  ; konversi dan baca data adc      ;
   MOV count,data_adc
   mov a,count
   cjne a, countbefore, update
   ;Polling Button
   jnb P1.0, up
   jnb P1.1, down
   jnb P1.2, ok
   jnb P1.3, hapus
   ;Polling relay
   cjne a, memory, not_equal
   equal:
   jmp loop
   not_equal:
   jc kurang_dari
   lebih_dari:  ;A > 27
   clr p3.4
    JMP Loop
   kurang_dari: ;A < 27
   setb p3.4
   jmp Loop

update:
   mov countbefore, count
   lcall hextoascii
   mov p2,#083h
   ACALL LCDCONTROL
   lcall DELAY
   ljmp print

up:
   lcall delaybutton
   inc setval
   mov count, setval
   lcall hextoasciisv
   mov p2,#0C3h
   ACALL LCDCONTROL
   jmp printsv
down:
   lcall delaybutton
   dec setval
   mov count, setval
   lcall hextoasciisv
   mov p2,#0C3h
   ACALL LCDCONTROL
   jmp printsv
ok:
   lcall delaybutton
   mov memory, setval
   mov count, setval
   lcall hextoasciisv
   mov p2,#0CAh
   ACALL LCDCONTROL
   jmp printsv
hapus:
   lcall delaybutton
   mov setval, #0
   mov count, setval
   lcall hextoasciisv
   mov p2,#0C3h
   ACALL LCDCONTROL
   jmp printsv

;=========
;Routine
;=========

;ADC CONVERSION + READING
get_adc:
   setb adc_intr
   CLR adc_cs ;// makes CS=0
   SETB adc_rd ;// makes RD high
   CLR adc_wr ;// makes WR low
   SETB adc_wr ;// low to high pulse to WR for starting conversion
WAIT:
   JB adc_intr,WAIT ;// polls until INTR=0
   CLR adc_cs ;// ensures CS=0
   CLR adc_rd ;// high to low pulse to RD for reading the data from ADC
   MOV data_adc,adc_port ;// moves the digital data to accumulator
ret

;LCD INITIALIZATION
init:   MOV P2, #38H
    ACALL LCDCONTROL
    ret
blink:    MOV P2, #0EH
    ACALL LCDCONTROL
    ret
clear:    MOV P2, #01H
    ACALL LCDCONTROL
    ret

;COMMAND SUB-ROUTINE FOR LCD CONTROL
LCDCONTROL:
  CLR RW
  CLR RS
  SETB E
  ACALL DELAY
  CLR E
  RET

;SUBROUTINE FOR DATA LACTCHING TO LCD
LCDDATA:
  CLR RW
  SETB RS
  SETB E
  ACALL DELAY
  CLR E
  RET

;PRINTING A CHARACTER
print:
    MOV P2,R5
    ACALL LCDDATA
    MOV P2,R6
    ACALL LCDDATA
    MOV P2,R7
    ACALL LCDDATA
    MOV P2,degree
    ACALL LCDDATA
    MOV P2,celcius
    ACALL LCDDATA
    lcall delay
    ljmp Loop

printsv:
    MOV P2,r5sv
    ACALL LCDDATA
    MOV P2,r6sv
    ACALL LCDDATA
    MOV P2,r7sv
    ACALL LCDDATA
    MOV P2,degree
    ACALL LCDDATA
    MOV P2,celcius
    ACALL LCDDATA
    lcall delay
    ljmp Loop

;Serial Comm Send
scom_send:
   mov a,count
   cjne a,countbefore,skip
   mov sdata,r5
   mov sbuf, sdata
   lcall delayser
   mov sdata,r6
   mov sbuf, sdata
   lcall delayser
   mov sdata,r7
   mov sbuf, sdata
   lcall delayser
   mov sdata,#0Dh ; Carriage Return / garis baru (Ascii 13d)
   mov sbuf, sdata
   lcall delayser
skip:
   ret

;DELAY SUBROUTINE
delayser:   ;Delay supaya satu klik satu increment di button
    MOV R0, #0    ;sama delay supaya data ke terminal muncul
    MOV R1, #55   ;delay nya jangan terlalu lambat atau terlalu cepet
tunggu1:
  DJNZ R0, tunggu1
  DJNZ R1, tunggu1
RET

delaybutton:
   mov r2,#3
tunggu3:
   lcall delayser
   djnz r2,tunggu3
   ret

DELAY:
    MOV R0, #0
    MOV R1, #1
tunggu:
  DJNZ R0, tunggu
  DJNZ R1, tunggu
RET


;Konversi Hex ke Ascii untuk LCD
hextoascii:
mov r5,#30h
mov r6,#30h
mov r7,#30h
mov a, count
cjne a,#000h,continue ;check if number is 0 if not then continue
ret
continue:

mov b,#17
div ab
mov puluh,a
mov satu,b
mov b,#10
mul ab
mov puluh,a
mov a,satu
mov b,#10d
mul ab
mov b,#17d
div ab;===hasil data sebenarnya untuk nilai satuan
mov b,puluh
add a,b

clr c
mov b,#100  ;divide by 100
div ab
orl a,r5
mov r5,a  ;save 100th place in R5

clr c
mov a,b

mov b,#10 ;Divide by 10
div ab
orl a,r6
mov r6,a  ;Save 10th place in R6

mov a,b
orl a,r7
mov r7,a  ;Save units place in R7
call delay
ret

hextoasciisv:
mov r5sv,#30h
mov r6sv,#30h
mov r7sv,#30h
mov a, count
cjne a,#000h,continuesv ;check if number is 0 if not then continue
ret
continuesv:

mov b,#17
div ab
mov puluh,a
mov satu,b
mov b,#10
mul ab
mov puluh,a
mov a,satu
mov b,#10d
mul ab
mov b,#17d
div ab;===hasil data sebenarnya untuk nilai satuan
mov b,puluh
add a,b

clr c
mov b,#100  ;divide by 100
div ab
orl a,r5sv
mov r5sv,a  ;save 100th place in R5

clr c
mov a,b

mov b,#10 ;Divide by 10
div ab
orl a,r6sv
mov r6sv,a  ;Save 10th place in R6

mov a,b
orl a,r7sv
mov r7sv,a  ;Save units place in R7
call delay
ret

jmp Loop

;===================================================================
END
