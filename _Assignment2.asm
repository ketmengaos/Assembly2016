;==========================================================================
;====== Assignment #2 ~ Due October 20, 2016 ~ Assembly and Comp Org ======
;==========================================================================

INCLUDE Irvine32.inc

.data

;Dataset used for Main.
border Byte "================================================================", 0dh, 0ah, 0
fancyb Byte "================================================================", 0dh, 0ah, "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=", 0dh, 0ah, "================================================================", 0dh, 0ah, 0
intro  Byte "~ Enter the number corresponding to the program you wish to run: ", 0dh, 0ah, "~ 1: ChangeBase:", 0dh, 0ah, "~ 2: ConvertLength:", 0dh, 0ah, "~ 3: ConvertWeight:", 0dh, 0ah, "~ 4: ConvertTime:", 0dh, 0ah, "~ 5: ChangeTime:", 0dh, 0ah, "~ 0: Exit:", 0dh, 0ah, 0
WrongInputMessage Byte "Wrong input, please try again.", 0dh, 0ah, 0
space  Byte " ", 0
backsl Byte "/", 0

;Common Datasets
value    Dword ?
InUnits  Byte ?
OutUnits Byte ?
temp     Dword ?

;Dataset used for ChangeBase
changebaseintro  Byte "You are now changing bases.", 0dh, 0ah, "Enter the Base you would like to convert to: (B for Binary, O for Octal, H for Hexadecimal, Q/0 to Exit) ", 0dh, 0ah, 0
numbertoconvert  Byte "Enter the number you wish to convert: ", 0dh, 0ah, 0
pleasetryagain   Byte "Incorrect Input, please try again.", 0dh, 0ah, 0
count         Dword 0
num           Dword 0
BaseToConvert Dword ?

;Dataset used for ConvertLength
convertlengthintro  Byte "You are now converting lengths.", 0dh, 0ah, "Enter a length value to be converted: (Q/0 to Exit) ", 0dh, 0ah, 0
enterinunits        Byte "Enter the original unit of measurement: (Y for Yards, F for Feet)", 0dh, 0ah, 0
enteroutunitsy      Byte "Enter the unit to be converted to: (F for Feet, I for Inches): ", 0dh, 0ah, 0
enteroutunitsf	    Byte "Converting to inches: ", 0dh, 0ah, 0
answerfeet          Byte " feet.", 0dh, 0ah, 0
answerinches        Byte " inches.", 0dh, 0ah, 0

;Dataset used for ConvertWeight
convertweightintro Byte "You are now converting lengths.", 0dh, 0ah, "Enter a weight value to be converted: (Q/0 to Exit)", 0dh, 0ah, 0
enterinunitscw     Byte "Enter the original unit of measurement: (P for Pounds, K for Kilograms) :", 0dh, 0ah, 0
enteroutunitp      Byte "Now converting to ounces.", 0dh, 0ah, 0
enteroutunitk      Byte "Enter the unit to be converted to: (P for Pounds, G for Grams)", 0dh, 0ah, 0
answerounces       Byte " ounces.", 0dh, 0ah, 0
answerpounds       Byte " pounds.", 0dh, 0ah, 0
answergrams        Byte " grams.", 0dh, 0ah, 0

;Dataset used for ConvertTime
converttimeintro   Byte "You are now converting time.", 0dh, 0ah, "Enter a time value to be converted: (Q/0 to Exit)", 0dh, 0ah, 0
enterinunitsct     Byte "Enter the original unit of time: (H for Hours, M for Minutes)", 0dh, 0ah, 0
enteroutunitsh     Byte "Enter the unit of to be converted to: (M for Minutes, S for Seconds)", 0dh, 0ah, 0
enteroutunitsm     Byte "Now converting to seconds.", 0dh, 0ah, 0
answerseconds      Byte " seconds.", 0dh, 0ah, 0
answerminutes      Byte " minutes.", 0dh, 0ah, 0

;DataSet used for ChangeTime
changetimeintro    Byte "You are now changing time.", 0dh, 0ah, "Enter a time in Military Format: (Q/0 to Exit)", 0dh, 0ah, 0
changetimeintro2   Byte "The converted time is: ", 0
hourstring	   Byte " hours, ", 0
minutestring       Byte " minutes, ", 0
displayampm	   Byte ?
hourstime 	   Word ?
minutestime        Word ?
militarytime 	   Word ?

.code

main proc

MenuLoop:
;====Displays Greeting Menu====
call FancyPageBorder
mov edx, 0
mov edx, offset intro
call WriteString
call FancyPageBorder
call ReadChar

;====Redirects Menu====
cmp al, '1'
jE Menu1
cmp al, '2'
jE Menu2
cmp al, '3'
jE Menu3
cmp al, '4'
jE Menu4
cmp al, '5'
jE Menu5
cmp al, '0'
jE ExitProgram

;Menu 1: Base Conversion.
Menu1:
call ChangeBase
jmp Finish

;Menu 2: Length Conversion.
Menu2:
call ConvertLength
jmp Finish

;Menu 3: Weight Conversion
Menu3:
call ConvertWeight
jmp Finish

;Menu 4: Time Unit Conversion
Menu4:
call ConvertTime
jmp Finish

;Menu 5: ChangeTime
Menu5:
call ChangeTime

;End marker for program that skips over the other methods.
Finish:
jmp MenuLoop

ExitProgram:
exit
main endp

;================================
;====Procedure for ChangeBase====
;================================
ChangeBase proc

Again:					;Jumps back for additional input.
mov edx, 0

mov edx, offset changebaseintro
call WriteString

;Try again loop just in case the input was incorrect.
TryAgain: 

	call ReadChar
	cmp al, 'B'
	jE  Binary
	cmp al, 'b'
	jE  Binary

	cmp al, 'O'
	jE  Octal
	cmp al, 'o'
	jE  Octal

	cmp al, 'H'
	jE  Hexadecim
	cmp al, 'h'
	jE  Hexadecim

	cmp al, '0'
	jE Ending
	cmp al, 'Q'
	jE Ending
	cmp al, 'q'	
	jE Ending

	jNE IncorrectInput			;Incorrect input case.

;Lets me write the loop once by defining what I should divide by.
Binary:
	mov BaseToConvert, 2
	jmp ExitSelection

Octal:
	mov BaseToConvert, 8
	jmp ExitSelection

Hexadecim:
	mov BaseToConvert, 16
	jmp ExitSelection

IncorrectInput:				;Jumps back to TryAgain: in the case the user enters an incorrect input.
	mov edx, 0
	mov edx, offset pleasetryagain
	call WriteString
	jmp TryAgain

ExitSelection:
	;Asks the user to input a number to be converted.
	mov edx, 0
	mov edx, offset numbertoconvert
	call WriteString
	mov edx, 0
	call ReadDec

;Continually divides and pushes the remainder to the stack.
L1:
	inc count
	mov edx, 0
	mov ebx, BaseToConvert
	div ebx
	push edx
	cmp eax, 0
	jA L1
call PageBorder
mov ecx, count
L2:
	;General popping procedure to list the numbers converted via remainders.
	pop eax
	;Checks if numbers are greater than 9 for Hexadecimal numbers.
	cmp eax, 10
	jE HexA
	cmp eax, 11
	jE HexB
	cmp eax, 12
	jE HexC
	cmp eax, 13
	jE HexD
	cmp eax, 14
	jE HexE
	cmp eax, 15
	jE HexF
	jNE HexReg			;General Case if the number were less than 10.
	;General selection process if the remainder was greater than 10, used for Hex.
	HexA:
		mov al, 'A'
		call WriteChar
		jmp HexFin
	HexB:
		mov al, 'B'
		call WriteChar
		jmp HexFin
	HexC:
		mov al, 'C'
		call WriteChar
		jmp HexFin
	HexD:
		mov al, 'D'
		call WriteChar
		jmp HexFin
	HexE:
		mov al, 'E'
		call WriteChar	
		jmp HexFin
	HexF:
		mov al, 'F'
		call WriteChar
		jmp HexFin
	HexReg:
		call WriteDec
	Hexfin:
		loop L2
call crlf
call crlf

mov count, 0			;Resets the counter

jmp Again

Ending:
call crlf
ret

ChangeBase endp

;===============================
;====ConvertLength Procedure====
;===============================
ConvertLength proc

Again2:

;Displays intro for ConvertLength
mov edx, 0
mov edx, offset convertlengthintro
call WriteString
call ReadDec

cmp eax, 0
jE endconvert				;Letters will return zero, thus quitting the program
 
mov  value, eax

CLIncorrectInput:			;Returns here if OutUnits is invalid
;Asks for the InUnits
mov edx, 0
mov edx, offset enterinunits
call WriteString
call ReadChar
mov  InUnits, al

;Test cases for Y or F as the InUnits
cmp InUnits, 'Y'
jE  YOutUnits
cmp InUnits, 'y'
jE  YOutUnits

cmp InUnits, 'F'
jE  FOutUnits
cmp InUnits, 'f'
jE  FOutUnits

;Case where input is incorrect.
call WrongInput
jNE CLIncorrectInput

YOutUnits:
	mov edx, 0
	mov edx, offset enteroutunitsy
	call WriteString
	call ReadChar
	mov OutUnits, al
	jmp Yards

FOutUnits:
	mov edx, 0
	mov edx, offset enteroutunitsf
	mov OutUnits, 'I'
	call WriteString
	jmp Feet

;Test cases for Yards to Feet and Inches.
Yards:
	cmp OutUnits, 'F'
	jE YToFeet
	cmp OutUnits, 'f'
	jE YToFeet
	cmp OutUnits, 'I'
	jE YToInch
	cmp OutUnits, 'i'
	jE YToInch	

	call WrongInput
	jNE CLIncorrectInput

	YToFeet:
		call PageBorder
		mov edx, 0
		mov eax, value
		mov ebx, 3
		mul ebx
		call WriteDec
	
		mov edx, 0
		mov edx, offset answerfeet
		call WriteString
		call crlf
		jmp Again2

	YToInch:
		call PageBorder
		mov eax, value
		mov ebx, 36
		mul ebx
		call WriteDec

		mov edx, 0
		mov edx, offset answerinches
		call WriteString
		call crlf
		jmp Again2

;Test cases for Feet to Inches
Feet:
	call PageBorder
	mov eax, value
	mov ebx, 12
	mul ebx
	call WriteDec
	
	mov edx, 0
	mov edx, offset answerinches
	call WriteString
	call crlf
	jmp Again2
	
endconvert:
call crlf
ret

ConvertLength endp

;===============================
;====ConvertWeight Procedure====
;===============================
ConvertWeight proc

Again3:
mov edx, 0
mov edx, offset convertweightintro
call WriteString
call ReadDec

cmp eax, 0
jE endconvertcw			;When reading dec, letters output as zeroes.

mov value, eax

CWIncorrectInput:

;Prompts user for initial unit of measurement
mov edx, 0
mov edx, offset enterinunitscw
call WriteString
call ReadChar

;Choses POutUnits or KOutUnits to run by comparison	
cmp al, 'P'
jE POutUnits
cmp al, 'p'
jE POutUnits

cmp al, 'K'
jE KOutUnits
cmp al, 'k'
jE KOutUnits

call WrongInput
jNE CWIncorrectInput

;Redirects to Pounds where it will convert to Ounces.
POutUnits:
	mov edx, 0
	mov edx, offset enteroutunitp
	call WriteString
	jmp Pounds

;Redirects to Kilograms where it will convert to Pounds or Grams.
KOutUnits:
	mov edx, 0
	mov edx, offset enteroutunitk  
	call WriteString
	call ReadChar
	mov OutUnits, al
	jmp Kilograms

;Performs the conversion from Pounds to Ounces.
Pounds:
	call PageBorder
	mov eax, value
	mov ebx, 16
	mul ebx
	call WriteDec
	
	mov edx, 0
	mov edx, offset answerounces
	call WriteString
	call crlf
	jmp Again3

;Performs the conversions from Kilograms to Grams/Pounds
Kilograms:
	;Test cases to redirect towards the necessary conversions
	cmp OutUnits, 'P'
	jE KToPounds
	cmp OutUnits, 'p'
	jE KToPounds

	cmp OutUnits, 'G'
	jE KToGrams
	cmp OutUnits, 'g'
	jE KToGrams
	
	call WrongInput
	jNE CWIncorrectInput
	;Displays answer for Kilograms to Pounds
	KToPounds:
		call PageBorder
		mov eax, value
		mov ebx, 2
		mul ebx
		mov temp, eax
	
		mov edx, 0
		mov eax, value
		mov ebx, 5
		div ebx
		add eax, temp
		call WriteDec
		mov temp, edx

		mov edx, 0
		mov edx, offset space
		call WriteString
		
		mov eax, temp
		call WriteDec 

		mov edx, 0 
		mov edx, offset backsl
		call WriteString
		
		mov eax, 5
		call WriteDec	

		mov edx, 0
		mov edx, offset answerpounds
		call WriteString
		call crlf
		jmp Again3
	;Displays answer for Kilograms to Grams
	KToGrams:
		call PageBorder
		mov eax, value
		mov ebx, 1000
		mul ebx
		call WriteDec
		
		mov edx, 0
		mov edx, offset answergrams
		call WriteString
		call crlf
		call Again3

endconvertcw:
call crlf
ret
ConvertWeight endp

;=================================
;====Procedure for ConvertTime====
;=================================

ConvertTime proc

Again4:

;Introduction for ConvertTime, asks user to input a time value and stores it inside value.
mov edx, 0
mov edx, offset converttimeintro
call WriteString
call ReadDec

cmp eax, 0
jE endconvertct

mov value, eax

CTIncorrectInput:

;Asks user to input inunit
mov edx, 0
mov edx, offset enterinunitsct
call WriteString
call ReadChar
mov InUnits, al

;Test cases for H or M as the Inunits.
cmp InUnits, 'H'
jE HOutUnits
cmp InUnits, 'h'
jE HOutUnits

cmp InUnits, 'M'
jE MOutUnits
cmp InUnits, 'm'
jE MOutUnits

call WrongInput
jNE CTIncorrectInput

HOutUnits:
	mov edx, 0
	mov edx, offset enteroutunitsh
	call WriteString
	call ReadChar
	mov OutUnits, al
	jmp Hours

MOutUnits:
	mov edx, 0
	mov edx, offset enteroutunitsm
	call WriteString
	jmp Minutes

Hours:
	cmp OutUnits, 'M'
	jE HToMinutes
	cmp OutUnits, 'm'
	jE HToMinutes

	cmp OutUnits, 'S'
	jE HToSeconds
	cmp OutUnits, 's'
	jE HToSeconds

;Performs conversion from Hours to Minutes
HToMinutes:
	call PageBorder
	mov eax, value
	mov ebx, 60
	mul ebx
	call WriteDec

;Displays units.
	mov edx, 0
	mov edx, offset answerminutes
	call WriteString
	call crlf
	jmp Again4

HToSeconds:
	;Displays Hours to Second
	call PageBorder
	mov eax, value
	mov ebx, 3600
	mul ebx
	call WriteDec

	mov edx, 0
	mov edx, offset answerseconds
	call WriteString
	call crlf
	jmp Again4

Minutes:
	;Display Minutes to Seconds
	call PageBorder 
	mov eax, value
	mov ebx, 60
	mul ebx
	call WriteDec
	
	mov edx, 0
	mov edx, offset answerseconds
	call WriteString
	call crlf
	jmp Again4

endconvertct:
call crlf
ret
ConvertTime endp

;============================
;====ChangeTime Procedure====
;============================

ChangeTime proc

ChTIncorrectInput:

Again5:
;Prompts user to enter a time in military.
mov edx, 0
mov edx, offset changetimeintro
call WriteString
call ReadDec

cmp eax, 0
jE endchangetime

mov militarytime, ax

;Obtains Hours and Minutes via Division and Modulo
mov dx, 0
mov ax, militarytime
mov bx, 100
div bx

mov minutestime, dx
mov hourstime, ax

;Loops back to CTIncorrectInput if minutes are greater than 60, loops back if it is
cmp minutestime, 60
jB ChTCorrectInput1
call WrongInput
jAE ChTIncorrectInput

;Loops back to CTIncorrectInput if hours is greater than 24, loops back if it is.
ChTCorrectInput1:
	cmp hourstime, 24
	jB ChTCorrectInput2
	call WrongInput
	jAE ChTIncorrectInput

ChTCorrectInput2:
	cmp hourstime, 13
	jAE OverThirteen
	mov displayampm, 'A'
	jmp ProcessMinutes

OverThirteen:
	mov ax, hourstime
	sub ax, 12
	mov hourstime, ax
	mov displayampm, 'P'	
	
ProcessMinutes:
	;Displays the converted time.
	call PageBorder
	mov edx, 0
	mov edx, offset changetimeintro2
	call WriteString
	
	mov ax, hourstime
	call WriteDec
	mov edx, 0
	mov edx, offset hourstring
	call WriteString
	
	mov ax, minutestime
	call WriteDec
	mov edx, 0
	mov edx, offset minutestring
	call WriteString

	mov al, displayampm
	call WriteChar
	call crlf	
	jmp Again5

endchangetime:
call crlf
ret
ChangeTime endp

;WrongInput output message
WrongInput proc

mov edx, 0
mov edx, offset WrongInputMessage
call WriteString
call crlf 
ret

WrongInput endp

;PageBorder output message.
PageBorder proc

mov edx, 0
mov edx, offset border
call WriteString

ret
PageBorder endp

;FancyPageBorder output message
FancyPageBorder proc

mov edx, 0
mov edx, offset fancyb
call WriteString

ret
FancyPageBorder endp

end main
