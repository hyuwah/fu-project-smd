;-------------------------------------------------------------------
; Kuliah SMD 2015
; M.Wahyudin (140310120031)
;
; Name  : Project SMD
; Desc  :
; Input : 4 Control PB, 1 Saklar, Sensor Suhu LM35
; Output: LCD, Serial RS232
;-------------------------------------------------------------------

$NOMOD51
$INCLUDE (8051.MCU)

      org   0000h

;========
;Definisi
;========
;LCD
RS BIT P3.5
RW BIT P3.6
E  BIT P3.7

count equ 33h
memory equ 36h

;============
;Inisialisasi
;============
setb P1.0
setb P1.1
setb P1.2
setb P1.3

mov count,#0
mov r5,#30h
mov r6,#30h
mov r7,#30h
;=========
;Main Loop
;=========
Loop:

    acall init
    acall blink
    acall clear
    jmp print

polls:
jnb P1.0, up
jnb P1.1, down
jnb P1.2, ok
jnb P1.3, hapus
jmp polls

up:
    inc count
    lcall hextoascii
    acall init
    acall blink
    acall clear
    jmp print
down:
    dec count
    lcall hextoascii
    acall init
    acall blink
    acall clear
    jmp print
ok:
   mov memory, count
   lcall hextoascii
   mov p2,#192
   ACALL LCDCONTROL
   jmp print
hapus:
mov count, #0
lcall hextoascii
    acall init
    acall blink
    acall clear
    jmp print

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

;PRINTING A CHARACTER
print:
    MOV P2, r5
    ACALL LCDDATA
    MOV P2, r6
    ACALL LCDDATA
    MOV P2, r7
    ACALL LCDDATA

ulang:
    lcall delay
    jmp polls


;DELAY SUBROUTINE
DELAY:
    MOV R0, #0
    MOV R1, #75
tunggu:
  DJNZ R0, tunggu
  DJNZ R1, tunggu
RET

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

;Konversi Hex ke Ascii untuk LCD
hextoascii:
mov r5,#30h
mov r6,#30h
mov r7,#30h
mov a, count
cjne a,#00h,c1_hextobcd ;check if number is 0 if not then continue
ret
c1_hextobcd:
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
ret

jmp Loop

;===================================================================
      END
