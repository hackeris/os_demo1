; Listing generated by Microsoft (R) Optimizing Compiler Version 14.00.50727.762 

	TITLE	i:\os\10\a\krnl\krnl\close.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	?close@@YAHH@Z					; close
EXTRN	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z:PROC	; send_recv
; Function compile flags: /Ogtpy
; File i:\os\10\a\krnl\krnl\close.cpp
;	COMDAT ?close@@YAHH@Z
_TEXT	SEGMENT
_msg$ = -48						; size = 48
_fd$ = 8						; size = 4
?close@@YAHH@Z PROC					; close, COMDAT

; 5    : {

	sub	esp, 48					; 00000030H

; 6    : 	MESSAGE	msg;
; 7    : 	msg.type = CLOSE;
; 8    : 	msg.FD = fd;

	mov	eax, DWORD PTR _fd$[esp+44]

; 9    : 
; 10   : 	send_recv(BOTH,TASK_FS,&msg);

	lea	ecx, DWORD PTR _msg$[esp+48]
	push	ecx
	push	3
	push	3
	mov	DWORD PTR _msg$[esp+64], 1007		; 000003efH
	mov	DWORD PTR _msg$[esp+68], eax
	call	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z	; send_recv

; 11   : 	return msg.RETVAL;

	mov	eax, DWORD PTR _msg$[esp+68]

; 12   : }

	add	esp, 60					; 0000003cH
	ret	0
?close@@YAHH@Z ENDP					; close
_TEXT	ENDS
END