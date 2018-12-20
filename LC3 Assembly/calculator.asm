; ascameron
; minimal function calculator written in LC3 Assembly


;**NOTES**
;>code has not been cleaned up yet(some nonsense label names, possibly unused/repetitive code)
;>parenthesis are not supported at this time
;>at the moment, priority is not finished(aka */ should be done before +-)
;>division: the divisor cannot be negative, but the dividend cannot
;>multiplication: the second number cannot be negative
	
	.ORIG x3000
;_________STRINGS___________________________________________
DESC	.STRINGZ "Calculator program: add(+), subtract(-), multiply(*), divide(/)\n"
TOEND	.STRINGZ "Press 'x' to quit"
SEMI	.STRINGZ "\n:> "
INVALID	.STRINGZ "\nNot a valid character."
szError .STRINGZ "\nExceeds range (-32,768 <= x <= 32,767)\n"
;welcome messages
	LEA R0, DESC		; load description
	PUTS
	LEA R0, TOEND
	PUTS
;start the program
BEGIN	LD R1, numTOP		; set the current number stack position
	ST R1, nCUR		
	LD R1, opTOP		; set the current operand stack position
	ST R1, opCUR		
		
	LEA R0, SEMI		; load ":> " to start equation
	PUTS
	AND R1, R1, #0
	AND R2, R2, #0		; clear for input loop
	AND R3, R3, #0 
	AND R4, R4, #0
		
;INPUT LOOP
; R2  number, R1  digit, R3 temp
; R6 queue ptr
INPUT	GETC			; get input from keyboard
	OUT
	; check for "x"
	LD R7, CANCEL
	ADD R7, R0, R7
	BRz FINISH
	; check for " = "
	LD R7, nEQUAL
	ADD R7, R0, R7
	BRz CALCULATE
	;check if input is digit
	LD R7, upLIM
	ADD R7, R0, R7		; check upper limit of 9
	BRp checkOP
	LD R7, lowLIM	
	ADD R1, R0, R7		; check lower limit of 0
	BRn checkOP
;NUMBER
	ADD R2, R2, #0
	BRz SKIP 		; if first digit, skip multiplication
	; shift place of previous digit
	AND R3, R3, #0
	ADD R3, R3, #10
	AND R7, R7, #0
SHIFT 	; multiplies the previous digits by 10
	ADD R7, R7, R2;
	ADD R3, R3, #-1;
	BRp SHIFT
	ADD R2, R7, #0
		
SKIP	ADD R2, R2, R1 		; add the new digit to number
	BR INPUT
;CHECK FOR OPERANDS
checkOP ADD R2, R2, #0		; make sure number isn't too large
	BRn sError		; if it is print error message

	LD R3, NEG		;check flag
	BRzp POS
	JSR twoC			
	AND R3, R3, #0
	ST R3, NEG
		
POS	LD R6, nCUR
	JSR OFFER		; store previous number in stack
	ST R6, nCUR
	ADD R5, R5, #0
	BRz BEGIN
		
	AND R2, R2, #0		;put op in R2
	ADD R2, R2, R0
	;check for subtraction
	LD R7, nSUB
	ADD R7, R2, R7
	BRnp notSub
	ADD R7, R7, #-1		; op was -
	LD R2, PLUS		; set op to +
	ST R7, NEG		; store flag
	BR strOP
	;check for addition
notSub	LD R7, nADD
	ADD R7, R2, R7
	BRz strOP
	;check for multiplication
	LD R7, nMULT
	ADD R7, R2, R7
	BRz strOP
	;check for division
	LD R7, nDIV
	ADD R7, R2, R7
	BRz strOP
	; if input is none of these
	; invalid input, start again
	LEA R0, INVALID
	PUTS
	BR BEGIN
	;input too large start again
sError	LEA R0, szError
	PUTS	
	BR BEGIN

; store the operand in op stack
strOP	LD R6, opCUR
	JSR OFFER
	ST R6, opCUR
	ADD R5, R5, #0
	BRz BEGIN
	AND R2, R2, #0
	AND R1, R1, #0	; clear for input loop
	AND R3, R3, #0 
	AND R4, R4, #0
	BR INPUT

; R1 num2, R2 num1, R3 operand
; R3 temp, and R4, and R5, and R7 maybe
; R6 stack pointer
CALCULATE ; R2 has the last digit entered
	;store previous number in memory
	LD R3, NEG
	BRzp nope		;check if it was negative
	AND R3, R3, #0
	ST R3, NEG		; set the flag
	JSR twoC			
	;put xD0A at end of each queue
nope	LD R6, nCUR			
	JSR OFFER
	ADD R6, R6, #1
	LD R5, qEND
	STR R5, R6, #0
	LD R6, opCUR
	ADD R6, R6, #1
	STR R5, R6, #0
	;set pointers to top of the queue
	LD R6, numTOP
	ADD R6, R6, #1
	ST R6, nCUR
	LD R6, opTOP
	ADD R6, R6, #1
	ST R6, opCUR
; now that everything is ready
; time to start the calculation
START	AND R2, R2, #0
	AND R1, R1, #0
	AND R3, R3, #0
	AND R4, R4, #0
	ADD R4, R4, #1
	;get first number
	LD R6, nCUR
	JSR POLL
	ADD R2, R2, R0		; put first term in R2
	;get second number
	JSR POLL
	ST R6, nCUR
	ADD R1, R0, R1		; put second term in R1
	;check if done
	ADD R5, R5, #0
	BRz FIN
	;get the opcode
	;**********put the priority check here*******************
	LD R6, opCUR
	JSR POLL
	ST R6, opCUR
	ADD R3, R0, R3		; put operand in R3
	
	;************************************
	;check if next operand is of higher priority, aka if of is +, and next is */
	;then the existing op and first number need to be stored, poll the next op and number
	;and perform check again, if bad, repeat process, if good, perform calculation
	;then return the other operand into its original position along with the first number
	
	
	
	
	;******************************************************
	LD R7, nADD
	ADD R7, R3, R7
	BRz ADDITION
		
	LD R7, nMULT
	ADD R7, R3, R7
	BRz MULTIPLY
		
; put answers in R2 in-case offer is needed
;division
	ADD R1, R1, #0
	BRz dError 		; cannot divide by zero
	JSR chNUM		;check if the numbers are neg, and adjust

	AND R3, R3, #0
	ADD R3, R3, #-1 	; start a counter for the quotient
	NOT R1, R1		;convert second number for division
	ADD R1, R1, #1
	
DIVLOOP ADD R3, R3, #1 		; loop subtracting to divide
	ADD R2, R2, R1
	BRzp DIVLOOP
	AND R2, R2, #0
	ADD R2, R2, R3

	ADD R5, R5, #0
	BRz FIN			; check if done
	LD R6, nCUR
	ADD R6, R6, #-2
	LD R4, nFLAG
	BRzp sk
	JSR twoC			
sk	JSR OFFER		
	ST R6, nCUR
	BR START
dError	;divisor is zero, output message
	LEA R0, zError
	PUTS
	BR START

;multiplication		
MULTIPLY AND R3, R3, #0
	JSR chNUM		;check if the numbers are neg, and adjust
mLOOP	ADD R3, R2, R3
	BRn sError		; numbers too big, output size limit
	ADD R1, R1, #-1
	BRp mLOOP
	AND R2, R2, #0
	ADD R2, R2, R3
	ADD R5, R5, #0
	BRz FIN			; done?
	LD R6, nCUR
		
	ADD R6, R6, #-2
	LD R4, nFLAG
	BRzp skp
	JSR twoC			
skp	JSR OFFER
	ST R6, nCUR
	BR START
;addition
ADDITION ADD R2, R1, R2
	;insert a check for size thing here
	ADD R5, R5, #0
	BRz FIN			;done?
	LD R6, nCUR
	ADD R6, R6, #-2
	JSR OFFER
	ST R6, nCUR
	BR START
	
FIN	ST R2, dANSWER		; calculations are all done, time to print answer
	AND R5, R5, #0

; R0 string, R1 answer, R2 counting digit
; R3 units subtracter, R4 leading zero switch
; R5 temp
PRINT
	AND R4, R4, #0 		; leading zero switch, 0 if no digits recorded
	LD R1, dANSWER		; R1 = number
	BRzp sKIP
	NOT R1, R1
	ADD R1, R1, #1
	
	LD R0, SUB
	OUT
sKIP	LEA R0, sANSWER		; R0 is where number string will be stored
	ADD R1, R1, #1 		
	AND R3, R3, #0
	LD R3, ntenthou 	; tenthousands place
	JSR CONVERT
	AND R3, R3, #0
	LD R3, nthou 		; thousands place
	JSR CONVERT
	AND R3, R3, #0
	LD R3, nhund 		; hundreds place
	JSR CONVERT
	AND R3, R3, #0
	ADD R3, R3, #-10 	; tens place
	JSR CONVERT
	AND R3, R3, #0
	ADD R3, R3, #-1 	; ones place
	JSR CONVERT
	AND R1, R1, #0 		; put EOT at end of string
	STR R1, R0, #0
	LEA R0, sANSWER		; load start of string, and output
	PUTS
	LD R0, newline
	OUT

	BR BEGIN		; start over

FINISH	HALT

;_________POINTERS__________________________________
; check equal
nEQUAL		.FILL #-61
CANCEL		.FILL #-120
; check digit	
lowLIM 		.FILL #-48
upLIM 		.FILL #-57
; number stack
numTOP	.FILL x4000		  
nNBOT	.FILL #-16393	; bottom is x4009
nCUR	.BLKW 1
; operand stack
opTOP	.FILL x400B		  
nOPBOT	.FILL #-16405	; bottom is x4015
opCUR	.BLKW 1
; store the answer
sANSWER 	.BLKW 6
dANSWER		.BLKW 1
NEG		.BLKW 1
; temp storage
oTEMP		.BLKW 1
nTEMP		.BLKW 1
rTEMP		.BLKW 1
nFLAG		.BLKW 1
;_________DATA FILLS AND CHECKS_____________________
newline		.FILL #10
qEND		.FILL #3338
nqEND		.FILL #-3338
; check operators
nMULT		.FILL #-42
nDIV		.FILL #-47
nADD		.FILL #-43
PLUS		.FILL #43
nSUB		.FILL #-45
SUB		.FILL #45
;_________SUB ROUTINES_____________________________
;adds from the top down
OFFER	ST R7, rTEMP
        ADD R6, R6, #1
	LD R5, nNBOT
	ADD R5, R5, R6
	BRz FULL		;num queue is full
	LD R5, nOPBOT
	ADD R5, R5, R6
	BRz FULL		;op queue is full
        STR R2, R6, #0
	BR Done
FULL	LEA R0, sFULL
	PUTS
	AND R5, R5, #0
Done   LD R7, rTEMP
	RET

; gets from the top down
POLL	ST R7, rTEMP
        LDR R0, R6, #0
        ADD R6, R6, #1
	LD R5, nNBOT
	ADD R5, R5, R6
	BRz EMPTY		; num queue is empty
	LD R5, nOPBOT
	ADD R5, R5, R6
	BRz EMPTY		; op queue is empty
	LD R5, nqEND
	ADD R5, R5, R0
EMPTY	LD R7, rTEMP
	RET

PEEK ST R7, rTEMP
	LDR R0, R6, #0
	LD R7, rTEMP
	RET

CONVERT
	LD R2, sADJUST 		; ASCII representation starting point
	ADD R5, R4, #0		; check for existing digit
	BRp LOOP 		; record zero, if its not the first digit
	ADD R5, R1, R3 		; R5 temp
	BRn ZERO 		; don't record first zero
LOOP	ADD R2, R2, #1 		; increment ASCII for each "division"
	ADD R1, R1, R3
	BRp LOOP
	STR R2, R0, #0 		; store the ASCII for each digit
	NOT R3, R3 		; return digit to positive
	ADD R3, R3, #1 		
	ADD R1, R1, R3 		
	ADD R0, R0, #1 		; increment string pointer
	ADD R4, R4, #1 		; now there are digits, set marker
ZERO
	RET
		
PEEK	LDR R0, R6, #0		; implement in the priority check
	RET
		
; for multiplication/division
;cannot multiply/divide neg numbers
;this checks if number is neg
;converts to positive and sets a flag
; once mult/div is performed, sum should
;converted using 2's compliment before being stored
chNUM	ST R4, rTEMP
	AND R4, R4, #0
	ADD R1, R1, #0		; test first number
	BRn ADjust		; if neg, adjust it
SND	ADD R2, R2, #0
	BRzp GOOD
	NOT R2, R2		; adjust second number
	ADD R2, R2, #1
	ADD R4, R4, #-1
	BR GOOD
ADjust	NOT R1, R1		; adjust first number, then check second
	ADD R1, R1, #1
	ADD R4, R4, #-1
	BR SND			; go to check 2nd number
GOOD	ST R4, nFLAG		; store the flag for +/-
	LD R4, rTEMP
	RET

;2's comp sub routine
twoC	NOT R2, R2
	ADD R2, R2, #1
	RET

; adjust decimal places
nhund 	.FILL #-100
nthou	.FILL #-1000
ntenthou .FILL #-10000
sADJUST .FILL #47
dADJUST	.FILL #48
zError	.STRINGZ "\nCannot divide by zero.\n"
newln	.STRINGZ "\n"
sFULL	.STRINGZ "\nToo many operations, try again."	
	
		.END
		