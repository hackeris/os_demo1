; Listing generated by Microsoft (R) Optimizing Compiler Version 14.00.50727.762 

	TITLE	i:\os\10\a\krnl\krnl\syscall.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	?sys_printx@@YAHPADHPAU_tagPROC@@@Z		; sys_printx
PUBLIC	?sys_recv@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z	; sys_recv
PUBLIC	?sys_send@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z	; sys_send
PUBLIC	?ret_val@@3IA					; ret_val
PUBLIC	?sys_call_num@@3IA				; sys_call_num
PUBLIC	?p_current_proc@@3PAU_tagPROC@@A		; p_current_proc
PUBLIC	?sys_call_table@@3PAP6AXXZA			; sys_call_table
_BSS	SEGMENT
?ret_val@@3IA DD 01H DUP (?)				; ret_val
?sys_call_num@@3IA DD 01H DUP (?)			; sys_call_num
?p_current_proc@@3PAU_tagPROC@@A DD 01H DUP (?)		; p_current_proc
_BSS	ENDS
_DATA	SEGMENT
?sys_call_table@@3PAP6AXXZA DD FLAT:?sys_send@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z ; sys_call_table
	DD	FLAT:?sys_recv@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z
	DD	FLAT:?sys_printx@@YAHPADHPAU_tagPROC@@@Z
_DATA	ENDS
PUBLIC	?sys_call@@YAXXZ				; sys_call
EXTRN	?_save@@YAXXZ:PROC				; _save
; Function compile flags: /Ogtpy
; File i:\os\10\a\krnl\krnl\syscall.cpp
;	COMDAT ?sys_call@@YAXXZ
_TEXT	SEGMENT
?sys_call@@YAXXZ PROC					; sys_call, COMDAT

; 35   : 	_asm mov [sys_call_num],eax

	mov	DWORD PTR ?sys_call_num@@3IA, eax	; sys_call_num

; 36   : 	save();

	sub	esp, 4
	pushad
	call	?_save@@YAXXZ				; _save

; 37   : 	//	the function save() put the address of process in esi
; 38   : 	_asm mov [p_current_proc],esi

	mov	DWORD PTR ?p_current_proc@@3PAU_tagPROC@@A, esi ; p_current_proc

; 39   : 	_asm sti

	sti

; 40   : 	_asm push p_current_proc

	push	DWORD PTR ?p_current_proc@@3PAU_tagPROC@@A ; p_current_proc

; 41   : 	_asm push edx

	push	edx

; 42   : 	_asm push ecx

	push	ecx

; 43   : 	sys_call_table[sys_call_num]();

	mov	eax, DWORD PTR ?sys_call_num@@3IA	; sys_call_num
	mov	ecx, DWORD PTR ?sys_call_table@@3PAP6AXXZA[eax*4]
	call	ecx

; 44   : 	_asm add esp,4*3

	add	esp, 12					; 0000000cH

; 45   : 	_asm mov [ret_val],eax

	mov	DWORD PTR ?ret_val@@3IA, eax		; ret_val

; 46   : 	p_current_proc->regs.eax = ret_val;

	mov	edx, DWORD PTR ?p_current_proc@@3PAU_tagPROC@@A ; p_current_proc
	mov	eax, DWORD PTR ?ret_val@@3IA		; ret_val
	mov	DWORD PTR [edx+44], eax

; 47   : 	_asm cli

	cli

; 48   : 	_asm ret

	ret	0
?sys_call@@YAXXZ ENDP					; sys_call
_TEXT	ENDS
EXTRN	?tty_write@@YAXPAU_tagTTY@@PADH@Z:PROC		; tty_write
EXTRN	?tty_table@@3PAU_tagTTY@@A:BYTE			; tty_table
EXTRN	?va2la@@YAPAXHPAX@Z:PROC			; va2la
; Function compile flags: /Ogtpy
;	COMDAT ?sys_printx@@YAHPADHPAU_tagPROC@@@Z
_TEXT	SEGMENT
_buf$ = 8						; size = 4
_len$ = 12						; size = 4
_p_proc$ = 16						; size = 4
?sys_printx@@YAHPADHPAU_tagPROC@@@Z PROC		; sys_printx, COMDAT

; 54   : 	char* s =(char*)va2la(p_proc->pid,buf);

	mov	eax, DWORD PTR _buf$[esp-4]
	push	esi
	mov	esi, DWORD PTR _p_proc$[esp]
	mov	ecx, DWORD PTR [esi+90]
	push	eax
	push	ecx
	call	?va2la@@YAPAXHPAX@Z			; va2la

; 55   : 	tty_write(&tty_table[p_proc->nr_tty],s,len);

	mov	edx, DWORD PTR _len$[esp+8]
	push	edx
	push	eax
	mov	eax, DWORD PTR [esi+114]
	imul	eax, 1040				; 00000410H
	add	eax, OFFSET ?tty_table@@3PAU_tagTTY@@A	; tty_table
	push	eax
	call	?tty_write@@YAXPAU_tagTTY@@PADH@Z	; tty_write
	add	esp, 20					; 00000014H

; 56   : 	return 0;

	xor	eax, eax
	pop	esi

; 57   : }

	ret	0
?sys_printx@@YAHPADHPAU_tagPROC@@@Z ENDP		; sys_printx
_TEXT	ENDS
PUBLIC	?sys_sendrec@@YAHHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z ; sys_sendrec
EXTRN	?msg_receive@@YAHPAU_tagPROC@@HPAU_tagMESSAGE@@@Z:PROC ; msg_receive
EXTRN	?msg_send@@YAHPAU_tagPROC@@HPAU_tagMESSAGE@@@Z:PROC ; msg_send
; Function compile flags: /Ogtpy
;	COMDAT ?sys_sendrec@@YAHHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z
_TEXT	SEGMENT
_function$ = 8						; size = 4
_src_dest$ = 12						; size = 4
_m$ = 16						; size = 4
_p$ = 20						; size = 4
?sys_sendrec@@YAHHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z PROC	; sys_sendrec, COMDAT

; 60   : {

	push	ebx

; 61   : 	int ret = 0;
; 62   : 	int caller = p->pid;
; 63   : 
; 64   : 	MESSAGE* mla = (MESSAGE*)va2la(caller,m);

	mov	ebx, DWORD PTR _m$[esp]
	push	esi
	push	edi
	mov	edi, DWORD PTR _p$[esp+8]
	mov	esi, DWORD PTR [edi+90]
	push	ebx
	push	esi
	call	?va2la@@YAPAXHPAX@Z			; va2la

; 65   : 
; 66   : 	mla->source = caller;

	mov	DWORD PTR [eax], esi

; 67   : 
; 68   : 	if(function == SEND){

	mov	eax, DWORD PTR _function$[esp+16]
	add	esp, 8
	cmp	eax, 1
	jne	SHORT $LN5@sys_sendre

; 69   : 		ret = msg_send(p,src_dest,m);

	mov	eax, DWORD PTR _src_dest$[esp+8]
	push	ebx
	push	eax
	push	edi
	call	?msg_send@@YAHPAU_tagPROC@@HPAU_tagMESSAGE@@@Z ; msg_send
	add	esp, 12					; 0000000cH
	pop	edi
	pop	esi

; 76   : 	}
; 77   : 	else{
; 78   : 		//	panic("sys_sendrec invalid function");
; 79   : 	}
; 80   : 
; 81   : 	return 0;

	xor	eax, eax
	pop	ebx

; 82   : }

	ret	0
$LN5@sys_sendre:

; 70   : 	}
; 71   : 
; 72   : 	else if(function == RECEIVE){

	cmp	eax, 2
	jne	SHORT $LN2@sys_sendre

; 73   : 		ret = msg_receive(p,src_dest,m);

	mov	ecx, DWORD PTR _src_dest$[esp+8]
	push	ebx
	push	ecx
	push	edi
	call	?msg_receive@@YAHPAU_tagPROC@@HPAU_tagMESSAGE@@@Z ; msg_receive
	add	esp, 12					; 0000000cH

; 74   : 		if(ret != 0)

	test	eax, eax

; 75   : 			return ret;

	jne	SHORT $LN6@sys_sendre
$LN2@sys_sendre:

; 76   : 	}
; 77   : 	else{
; 78   : 		//	panic("sys_sendrec invalid function");
; 79   : 	}
; 80   : 
; 81   : 	return 0;

	xor	eax, eax
$LN6@sys_sendre:
	pop	edi
	pop	esi
	pop	ebx

; 82   : }

	ret	0
?sys_sendrec@@YAHHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z ENDP	; sys_sendrec
; Function compile flags: /Ogtpy
_TEXT	ENDS
;	COMDAT ?sys_send@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z
_TEXT	SEGMENT
_dest$ = 8						; size = 4
_msg$ = 12						; size = 4
_p$ = 16						; size = 4
?sys_send@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z PROC	; sys_send, COMDAT

; 85   : {

	push	ebx

; 86   : 	return sys_sendrec(SEND,dest,msg,p);

	mov	ebx, DWORD PTR _msg$[esp]
	push	esi
	push	edi
	mov	edi, DWORD PTR _p$[esp+8]
	mov	esi, DWORD PTR [edi+90]
	push	ebx
	push	esi
	call	?va2la@@YAPAXHPAX@Z			; va2la
	mov	DWORD PTR [eax], esi
	mov	eax, DWORD PTR _dest$[esp+16]
	push	ebx
	push	eax
	push	edi
	call	?msg_send@@YAHPAU_tagPROC@@HPAU_tagMESSAGE@@@Z ; msg_send
	add	esp, 20					; 00000014H
	pop	edi
	pop	esi
	xor	eax, eax
	pop	ebx

; 87   : }

	ret	0
?sys_send@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z ENDP	; sys_send
; Function compile flags: /Ogtpy
_TEXT	ENDS
;	COMDAT ?sys_recv@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z
_TEXT	SEGMENT
_src$ = 8						; size = 4
_msg$ = 12						; size = 4
_p$ = 16						; size = 4
?sys_recv@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z PROC	; sys_recv, COMDAT

; 90   : {

	push	ebx

; 91   : 	return sys_sendrec(RECEIVE,src,msg,p);

	mov	ebx, DWORD PTR _msg$[esp]
	push	esi
	push	edi
	mov	edi, DWORD PTR _p$[esp+8]
	mov	esi, DWORD PTR [edi+90]
	push	ebx
	push	esi
	call	?va2la@@YAPAXHPAX@Z			; va2la
	mov	DWORD PTR [eax], esi
	mov	eax, DWORD PTR _src$[esp+16]
	push	ebx
	push	eax
	push	edi
	call	?msg_receive@@YAHPAU_tagPROC@@HPAU_tagMESSAGE@@@Z ; msg_receive
	add	esp, 20					; 00000014H
	pop	edi
	pop	esi
	pop	ebx

; 92   : }

	ret	0
?sys_recv@@YAHHPAU_tagMESSAGE@@PAU_tagPROC@@@Z ENDP	; sys_recv
_TEXT	ENDS
PUBLIC	?get_ticks@@YAHXZ				; get_ticks
EXTRN	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z:PROC	; send_recv
EXTRN	?reset_msg@@YAXPAU_tagMESSAGE@@@Z:PROC		; reset_msg
; Function compile flags: /Ogtpy
;	COMDAT ?get_ticks@@YAHXZ
_TEXT	SEGMENT
_msg$ = -48						; size = 48
?get_ticks@@YAHXZ PROC					; get_ticks, COMDAT

; 95   : {

	sub	esp, 48					; 00000030H

; 96   : 	MESSAGE msg;
; 97   : 	reset_msg(&msg);

	lea	eax, DWORD PTR _msg$[esp+48]
	push	eax
	call	?reset_msg@@YAXPAU_tagMESSAGE@@@Z	; reset_msg

; 98   : 	msg.type = GET_TICKS;
; 99   : 	send_recv(BOTH,TASK_SYS,&msg);

	lea	ecx, DWORD PTR _msg$[esp+52]
	push	ecx
	push	1
	push	3
	mov	DWORD PTR _msg$[esp+68], 3
	call	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z	; send_recv

; 100  : 	return msg.RETVAL;

	mov	eax, DWORD PTR _msg$[esp+72]

; 101  : }

	add	esp, 64					; 00000040H
	ret	0
?get_ticks@@YAHXZ ENDP					; get_ticks
_TEXT	ENDS
PUBLIC	?init_syscall@@YAHXZ				; init_syscall
EXTRN	?init_idt_desc@@YAXIP6AXXZEEG@Z:PROC		; init_idt_desc
; Function compile flags: /Ogtpy
;	COMDAT ?init_syscall@@YAHXZ
_TEXT	SEGMENT
?init_syscall@@YAHXZ PROC				; init_syscall, COMDAT

; 29   : 	init_idt_desc(INT_VECTOR_SYS_CALL,sys_call,DA_386IGATE,PRIVILEGE_USER,0x8);

	push	8
	push	3
	push	142					; 0000008eH
	push	OFFSET ?sys_call@@YAXXZ			; sys_call
	push	144					; 00000090H
	call	?init_idt_desc@@YAXIP6AXXZEEG@Z		; init_idt_desc
	add	esp, 20					; 00000014H

; 30   : 	return 0;

	xor	eax, eax

; 31   : }

	ret	0
?init_syscall@@YAHXZ ENDP				; init_syscall
_TEXT	ENDS
END