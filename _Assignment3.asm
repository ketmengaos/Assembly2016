;========================================================================
;========== Assignment 3 - Computer Org. and Assembly Language ==========
;========== -------------------------------------------------- ==========
;==========     Ket-Meng Cheng - Due: November 3, 2016         ==========
;========================================================================

INCLUDE Irvine32.inc

.data

Arr  DWORD 10 DUP (?)
Arr1 DWORD 10 DUP (?)
Arr2 DWORD 11 DUP (?)
insertcell  DWORD ?
sentinel    DWORD 1
Counter     DWORD ?
RandomVal   DWORD ?

Space  BYTE "==========================================================================", 0dh, 0ah, 0
SpaceC BYTE " ", 0
Intro1 BYTE "Please enter ten digits: (Enter 0 to auto-fill with predetermined numbers)", 0dh, 0ah, 0
SpaceD BYTE "--------------------------------------------------------------------------", 0dh, 0ah, 0
Intro2 BYTE "Please enter the number corresponding to the process you wish to run:", 0dh, 0ah, "--------------------------------------------------------------------------", 0dh, 0ah, "1: Multiply", 0dh, 0ah, "2: Insert", 0dh, 0ah, "3: Delete 75", 0dh, 0ah, "4: Reverse Array", 0dh, 0ah, "5: Sort and Search", 0dh, 0ah, "0: Exit Program", 0dh, 0ah, "--------------------------------------------------------------------------", 0dh, 0ah, 0

MulInt BYTE "Now multiplying each digit by four: ", 0dh, 0ah, 0
InsInt BYTE "Inserting 43 in a random position... (0 - 10) ", 0dh, 0ah, 0
DelInt BYTE "Deleting Number 75...", 0dh, 0ah, 0
RevArr BYTE "Reversing array...", 0dh, 0ah, 0
SortAr BYTE "Sorting array...", 0dh, 0ah, 0
BinSea BYTE "Enter a value to be searched: ", 0dh, 0ah, 0
BinHit BYTE "Value exists in Array.", 0dh, 0ah, 0
BinMis BYTE "Value does not exist in Array.", 0dh, 0ah, 0

SearchValue DWORD ?
First       DWORD ?
Last        DWORD ?
Middle      DWORD ?

.code

main proc

mov  edx, 0
mov  edx, offset Space
call WriteString
mov  edx, 0
mov  edx, offset Intro1
call WriteString
mov  edx, 0
mov  edx, offset Space
call WriteString

mov  esi, offset Arr		;Sets esi to point to the beginning of Arr

mov  ecx, 10
ReadDecLoop:
	call ReadDec
	cmp  eax, 0
	jE   AutoFill
	jMP  Skip
	AutoFill:		;Autofiller because people are lazy.
		mov eax, 25
		mov [esi], eax
		add esi, type Arr
		mov eax, 67
		mov [esi], eax
		add esi, type Arr
		mov eax, 23
		mov [esi], eax
		add esi, type Arr
		mov eax, 32
		mov [esi], eax
		add esi, type Arr
		mov eax, 75
		mov [esi], eax
		add esi, type Arr
		mov eax, 91
		mov [esi], eax
		add esi, type Arr
		mov eax, 40
		mov [esi], eax
		add esi, type Arr
		mov eax, 77
		mov [esi], eax
		add esi, type Arr
		mov eax, 23
		mov [esi], eax
		add esi, type Arr
		mov eax, 41
		mov [esi], eax
		add esi, type Arr
		jmp Fin
	Skip:
	mov  [esi], eax
 	add  esi, type Arr	;Increments the array by 4 so that it points to the next area.
Loop ReadDecLoop
Fin:

call crlf
mov  edx, 0
mov  edx, offset Space
call WriteString

MainMenu:
	mov  edx, 0
	mov  edx, offset SpaceD
	call WriteString
	mov  edx, 0
	mov  edx, offset Intro2
	call WriteString
	call ReadChar
	cmp  al, '1'
	jE   Menu1
	cmp  al, '2'
	jE   Menu2
	cmp  al, '3'
	jE   Menu3
	cmp  al, '4'
	jE   Menu4
	cmp  al, '5'
	jE   Menu5
	cmp  al, '0'
	jE   FinMain
	jNE  MainMenu
	

	Menu1:
		call MultiplyFour
		call crlf
		call Copy
		jmp  MainMenu
	Menu2:
		call InsertNumber
		call crlf
		call Erase2
		mov sentinel, 1
		jmp  MainMenu
	Menu3:
		call DeleteNum
		call crlf
		call Copy
		jmp  MainMenu
	Menu4:
		call ReverseArray
		call crlf
		call Copy
		jmp  MainMenu
	Menu5:
		call Sort
		call crlf
		call Copy
		jmp  MainMenu 

FinMain:

exit
main endp 

;=====Multiply by Four Procedure=====

MultiplyFour proc

call crlf			;Introduction
mov  edx, 0			
mov  edx, offset MulInt
call WriteString

mov  esi, offset Arr		;Uses EDI to point to the next array element. I could use esi+4 as well.
mov  edi, offset Arr1		

mov  ecx, LengthOf Arr1	
MulLoop:
	mov  eax, [esi]		
	mov  ebx, 4
	mul  ebx
	mov  [edi], eax
	add  esi, Type Arr
	add  edi, type Arr1
Loop MulLoop

call Display			;Custom procedure to list items.
call crlf

ret
MultiplyFour endp

;=====Inserts Number 43 Procedure=====
InsertNumber proc

call crlf					
mov  edx, 0
mov  edx, offset InsInt			;Displays introduction.
call WriteString

call RandomRa				;Uses an RNG to generate where to insert the number.
mov  eax, RandomVal
sub  eax, 1				;Decrements since it's on a 0-10 scale
mov  insertcell, eax

mov  esi, offset Arr			;Uses EDI to keep a pointer on the next  value so that I am able to cycle the next value into the current ESI.
mov  edi, offset Arr2

mov  ecx, LengthOf Arr2
InsLoop:
	mov  eax, sentinel		;Uses a sentinel to keep track of when to go skip Insertion.
	cmp  eax, 0
	jE   AlreadyInserted

	mov  eax, insertcell
	add  eax, ecx
	cmp  eax, LengthOf Arr
	jLE  Insertion
	JMP  NoInsertion

	;Inserts when InsertCell + ECX = The Length of the Array. This should ideally insert it into where the user specifies.
	Insertion:
		mov  eax, 43
		mov  [edi], eax
		add  edi, Type Arr2
		mov  eax, 0
		mov  sentinel, eax

	AlreadyInserted:
	NoInsertion:
	mov  eax, [esi]
	mov  [edi], eax
	add  esi, Type Arr
	add  edi, Type Arr2
	Loop InsLoop

;Modified Display procedure for Arr2
mov  ecx, LengthOf Arr2
mov  esi, offset Arr2
call crlf
TestLoop:
	mov  eax, [esi]
	call WriteDec
	call Spacer	
	add  esi, type Arr2
	Loop TestLoop
call crlf
ret
InsertNumber endp

;======DeleteNumber Procedure=====

DeleteNum proc

call crlf
mov  edx, 0
mov  edx, offset DelInt
call WriteString

;Custom Copy Array procedure to copy Arr to Arr1
call Copy

;Utilizes both ESI and EDI to point one array location further.

mov  esi, offset Arr1
mov  edi, offset Arr1
mov  ecx, LengthOf Arr1
DelLoop:
	mov  eax, [esi]
	cmp  eax, 75
	jE   DelSevenFive
	jmp  SkipDel
	DelSevenFive:
		add  edi, type Arr1		;Points one array location further.
		mov  eax, [edi]
		mov  [esi], eax
		add  esi, type Arr1		;Increments after to create a cascade.
		Loop DelSevenFive
	JMP  FinDel
	SkipDel:
	add  esi, type Arr1
	add  edi, type Arr1	
	Loop DelLoop

FinDel:

call Display
call crlf

ret
DeleteNum endp

;=====Reverse Array Procedure=====

ReverseArray proc

call crlf
mov  edx, 0
mov  edx, offset RevArr
call WriteString

mov esi, offset Arr
mov ecx, LengthOf Arr
LoopRev:
	push [esi]
	add  esi, Type Arr
	loop LoopRev	

mov esi, offset Arr1
mov ecx, LengthOf Arr1
LoopRev2:
	pop  [esi]
	add  esi, Type Arr1
	loop LoopRev2

call Display
call crlf
ret
ReverseArray endp

;=====Sorting Procedure=====

Sort proc

call crlf
mov  edx, 0 
mov  edx, offset SortAr
call WriteString

call Copy						;Copies ARR into ARR1
call Display						;Displays before-case.

mov  ecx, LengthOf Arr1
sub  ecx, 1

SortLoop1:
	push ecx
	mov  esi, offset Arr1
	mov  edi, offset Arr1
	add  edi, type   Arr1				;Increments by one to assign it as the next array element.
	
	SortLoop2:
		mov  eax, [esi]
		cmp  eax, [edi]
		jG   SortSwap
		JMP  SwapSkip
		SortSwap:
			xchg eax, [edi]			;Swaps EDI and ESI.
			mov  [esi], eax
		SwapSkip:
		add  esi, type Arr1			;Increment both pointers by one slot.
		add  edi, type Arr1 
		Loop SortLoop2				;Jumps back to SortLoop2 to reiterate the process until it reaches the end (when ECX = 0)

	pop  ecx
	Loop SortLoop1

call Display
call crlf

call BinarySearch

ret
Sort endp

BinarySearch proc

call crlf
mov  edx, 0
mov  edx, offset BinSea
call WriteString
call ReadDec
mov  SearchValue, eax

mov  First, 0
mov  Last,  LengthOf Arr1
dec  Last

BinSearchLoop1:
	mov  eax, First
	cmp  eax, Last
	jG   BinSearchOut	;Tests if First <= Last
	mov  eax, First
	add  eax, Last
	shr  eax, 1		;Divides by 2
	mov  Middle, eax	;Assigns Middle

	mov  eax, Middle 
	mov  ebx, Type Arr1	;Scales Middle.
	mul  ebx
	mov  esi, offset Arr1
	add  esi, eax		;Properly scales ESI so that it points in the right location.

	mov  eax, [esi]
	cmp  eax, SearchValue
	jL   BinLess
	jG   BinGreater
	jE   BinEqual

	BinGreater:		;Case where Mid > Value
		mov eax, Middle	;Sets Last to Middle-1 
		dec eax
		mov Last, eax
		jmp BinSearchLoop1

	BinLess:		;Case where Mid < Value
		mov eax, Middle	;Sets First to be Middle+1
		inc eax
		mov First, eax
		jmp BinSearchLoop1

	BinEqual:		;Case where Mid = Value
		mov  edx, 0
		mov  edx, offset BinHit
		call WriteString	
		jmp  BinSearchEnd

BinSearchOut:
mov  edx, 0
mov  edx, offset BinMis
call WriteString

BinSearchEnd:

ret
BinarySearch endp

;=====RandomRange Procedure=====

RandomRa proc

call Randomize
mov  eax, 11
call RandomRange
mov  RandomVal, eax

ret
RandomRa endp

;=====Auxilliary Procedures=====

Copy proc

mov  esi, offset Arr
mov  edi, offset Arr1

mov  ecx, LengthOf Arr
CopyLoop:
	mov  eax, [esi]
	mov  [edi], eax
	add  esi, Type Arr		;Increments both ESI and EDI to the next value
	add  edi, Type Arr1
Loop CopyLoop

ret
Copy endp

Erase2 proc

mov esi, offset Arr2
mov ecx, LengthOf Arr2	
EraseLoop:
	mov eax, 0
	mov [esi], eax
	add esi, type Arr2
	Loop EraseLoop

ret
Erase2 endp

;==Displays the contents of an array.
Display proc

mov ecx, LengthOf Arr1
mov esi, offset Arr1
call crlf
TestLoop:
	mov eax, [esi]
	call WriteDec
	call Spacer	
	add esi, type Arr1
Loop TestLoop

ret
Display endp

;==Generates a space character==
Spacer proc

mov  edx, 0
mov  edx, offset SpaceC
call WriteString

ret
Spacer endp

end main
