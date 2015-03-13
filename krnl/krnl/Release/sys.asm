; Listing generated by Microsoft (R) Optimizing Compiler Version 14.00.50727.762 

	TITLE	i:\os\10\a\krnl\krnl\sys.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	?do_fork@@YAHPAU_tagMESSAGE@@@Z			; do_fork
EXTRN	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z:PROC	; send_recv
EXTRN	?ldt_set_descriptor@@YAXPAU_tagLDT_DESCRIPTOR@@IIG@Z:PROC ; ldt_set_descriptor
EXTRN	?pmmgr_alloc_blocks@@YAPAXI@Z:PROC		; pmmgr_alloc_blocks
EXTRN	?memcpy@@YAPAXPAXPBXI@Z:PROC			; memcpy
EXTRN	?proc_table@@3PAU_tagPROC@@A:BYTE		; proc_table
; Function compile flags: /Ogtpy
; File i:\os\10\a\krnl\krnl\sys.cpp
;	COMDAT ?do_fork@@YAHPAU_tagMESSAGE@@@Z
_TEXT	SEGMENT
_child_ldt_sel$ = -52					; size = 2
_caller_t_size$ = -52					; size = 4
_m$ = -48						; size = 48
_msg$ = 8						; size = 4
?do_fork@@YAHPAU_tagMESSAGE@@@Z PROC			; do_fork, COMDAT

; 60   : {

	sub	esp, 52					; 00000034H
	push	ebp
	push	esi

; 61   : 	PROCESS* p = proc_table;

	mov	esi, OFFSET ?proc_table@@3PAU_tagPROC@@A ; proc_table

; 62   : 	int i ;
; 63   : 	for(i = 0; i < NR_TASKS+NR_PROCS; i++,p++){

	xor	ebp, ebp
	mov	eax, 8
$LL5@do_fork:

; 64   : 		if(p->p_flags == FREE_SLOT)

	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN16@do_fork
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN11@do_fork
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN12@do_fork
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN13@do_fork
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN14@do_fork
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN15@do_fork
	add	ebp, 6
	add	esi, 194				; 000000c2H
	cmp	ebp, 36					; 00000024H
	jl	SHORT $LL5@do_fork
	jmp	SHORT $LN16@do_fork
$LN11@do_fork:
	add	ebp, 1
	jmp	SHORT $LN16@do_fork
$LN12@do_fork:
	add	ebp, 2
	jmp	SHORT $LN16@do_fork
$LN13@do_fork:
	add	ebp, 3
	jmp	SHORT $LN16@do_fork
$LN14@do_fork:
	add	ebp, 4
	jmp	SHORT $LN16@do_fork
$LN15@do_fork:
	add	ebp, 5
$LN16@do_fork:

; 65   : 			break;
; 66   : 	}
; 67   : 
; 68   : 	int child_pid = i;
; 69   : 	if(child_pid == NR_TASKS + NR_PROCS)

	cmp	ebp, 36					; 00000024H
	jne	SHORT $LN1@do_fork
	pop	esi

; 70   : 		return -1;

	or	eax, -1
	pop	ebp

; 118  : }

	add	esp, 52					; 00000034H
	ret	0
$LN1@do_fork:

; 71   : 
; 72   : 	//	duplicate the process table
; 73   : 	int pid = msg->source;

	mov	eax, DWORD PTR _msg$[esp+56]

; 74   : 	uint16_t child_ldt_sel = p->ldt_sel;

	movzx	ecx, WORD PTR [esi+72]
	push	ebx
	mov	ebx, DWORD PTR [eax]
	push	edi

; 75   : 	//*p = proc_table[pid];
; 76   : 	memcpy(p,&proc_table[pid],sizeof(PROCESS));

	mov	edi, ebx
	imul	edi, 194				; 000000c2H
	push	194					; 000000c2H
	lea	edx, DWORD PTR ?proc_table@@3PAU_tagPROC@@A[edi]
	push	edx
	push	esi
	mov	DWORD PTR _child_ldt_sel$[esp+80], ecx
	call	?memcpy@@YAPAXPAXPBXI@Z			; memcpy

; 77   : 	p->ldt_sel = child_ldt_sel;

	mov	ax, WORD PTR _child_ldt_sel$[esp+80]
	mov	WORD PTR [esi+72], ax

; 78   : 	p->p_parent = pid;

	mov	DWORD PTR [esi+178], ebx

; 79   : 	p->nr_tty = proc_table[pid].nr_tty;

	mov	ecx, DWORD PTR ?proc_table@@3PAU_tagPROC@@A[edi+114]
	mov	DWORD PTR [esi+114], ecx

; 80   : 
; 81   : 	LDT_DESCRIPTOR* ppd = &proc_table[pid].ldts[0];	//code ldt
; 82   : 	//	base of code seg, in bytes
; 83   : 	int caller_t_base = ppd->baseHi << 24 | ppd->baseMid << 16 | ppd->baseLo;
; 84   : 	//	limit
; 85   : 	int caller_t_limit = (ppd->grand & 0x0f) << 16 | ppd->limit;

	mov	al, BYTE PTR ?proc_table@@3PAU_tagPROC@@A[edi+80]
	movzx	edx, WORD PTR ?proc_table@@3PAU_tagPROC@@A[edi+76]
	xor	ebx, ebx
	mov	bh, BYTE PTR ?proc_table@@3PAU_tagPROC@@A[edi+81]

; 86   : 
; 87   : 	int caller_t_size = (caller_t_limit + 1)*
; 88   : 		((ppd->grand & (DA_LIMIT_4K >> 8)) ? 4096 : 1);

	movzx	ecx, al
	and	ecx, 15					; 0000000fH
	shl	ecx, 16					; 00000010H
	and	al, 128					; 00000080H
	mov	bl, BYTE PTR ?proc_table@@3PAU_tagPROC@@A[edi+78]

; 89   : 
; 90   : 	//	data
; 91   : 	ppd = &proc_table[pid].ldts[1];
; 92   : 	int caller_d_s_base =  ppd->baseHi << 24 | ppd->baseMid << 16 | ppd->baseLo;
; 93   : 	int caller_d_s_limit = (ppd->grand & 0x0f) << 16 | ppd->limit;
; 94   : 	int caller_d_s_size = (caller_d_s_limit + 1)*
; 95   : 		((ppd->grand & (DA_LIMIT_4K >> 8)) ? 4096 : 1);
; 96   : 	//	base of child proc share the same space
; 97   : 	int child_base = (int)pmmgr_alloc_blocks(256);

	push	256					; 00000100H
	shl	ebx, 16					; 00000010H
	or	ebx, edx
	movzx	edx, WORD PTR ?proc_table@@3PAU_tagPROC@@A[edi+74]
	or	ecx, edx
	add	ecx, 1
	neg	al
	sbb	eax, eax
	and	eax, 4095				; 00000fffH
	add	eax, 1
	imul	ecx, eax
	mov	DWORD PTR _caller_t_size$[esp+84], ecx
	call	?pmmgr_alloc_blocks@@YAPAXI@Z		; pmmgr_alloc_blocks
	mov	edi, eax

; 98   : 	memcpy((void*)child_base,(void*)caller_t_base,caller_t_size);

	mov	eax, DWORD PTR _caller_t_size$[esp+84]
	push	eax
	push	ebx
	push	edi
	call	?memcpy@@YAPAXPAXPBXI@Z			; memcpy

; 99   : 
; 100  : 	//	child's ldt
; 101  : 	ldt_set_descriptor(&p->ldts[0],child_base,
; 102  : 		(PROC_IMAGE_SIZE_DEFAULT - 1) >> LIMIT_4K_SHIFT,
; 103  : 		DA_LIMIT_4K | DA_32 | DA_C | PRIVILEGE_USER << 5);

	push	49400					; 0000c0f8H
	push	255					; 000000ffH
	lea	ecx, DWORD PTR [esi+74]
	push	edi
	push	ecx
	call	?ldt_set_descriptor@@YAXPAU_tagLDT_DESCRIPTOR@@IIG@Z ; ldt_set_descriptor

; 104  : 	ldt_set_descriptor(&p->ldts[1],child_base,
; 105  : 		(PROC_IMAGE_SIZE_DEFAULT - 1) >> LIMIT_4K_SHIFT,
; 106  : 		DA_LIMIT_4K | DA_32 | DA_DRW | PRIVILEGE_USER << 5);

	push	49394					; 0000c0f2H
	push	255					; 000000ffH
	push	edi
	add	esi, 82					; 00000052H
	push	esi
	call	?ldt_set_descriptor@@YAXPAU_tagLDT_DESCRIPTOR@@IIG@Z ; ldt_set_descriptor

; 107  : 
; 108  : 	//	return
; 109  : 	msg->PID = child_pid;

	mov	edx, DWORD PTR _msg$[esp+124]

; 110  : 
; 111  : 	MESSAGE m;
; 112  : 	m.type = SYSCALL_RET;
; 113  : 	m.RETVAL = 0;

	xor	eax, eax
	mov	DWORD PTR _m$[esp+136], eax

; 114  : 	m.PID = 0;

	mov	DWORD PTR _m$[esp+140], eax

; 115  : 	send_recv(SEND,child_pid,&m);

	lea	eax, DWORD PTR _m$[esp+128]
	push	eax
	push	ebp
	push	1
	mov	DWORD PTR [edx+12], ebp
	mov	DWORD PTR _m$[esp+144], 2
	call	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z	; send_recv
	add	esp, 72					; 00000048H
	pop	edi
	pop	ebx
	pop	esi

; 116  : 
; 117  : 	return 0;

	xor	eax, eax
	pop	ebp

; 118  : }

	add	esp, 52					; 00000034H
	ret	0
?do_fork@@YAHPAU_tagMESSAGE@@@Z ENDP			; do_fork
_TEXT	ENDS
PUBLIC	?cleanup@@YAXPAU_tagPROC@@@Z			; cleanup
; Function compile flags: /Ogtpy
;	COMDAT ?cleanup@@YAXPAU_tagPROC@@@Z
_TEXT	SEGMENT
_p$ = 8							; size = 4
?cleanup@@YAXPAU_tagPROC@@@Z PROC			; cleanup, COMDAT

; 144  : 	p->p_flags = FREE_SLOT;

	mov	eax, DWORD PTR _p$[esp-4]
	mov	DWORD PTR [eax+118], 8

; 145  : }

	ret	0
?cleanup@@YAXPAU_tagPROC@@@Z ENDP			; cleanup
_TEXT	ENDS
PUBLIC	?do_excute@@YAHPAU_tagMESSAGE@@@Z		; do_excute
EXTRN	?strcpy@@YAPADPADPBD@Z:PROC			; strcpy
EXTRN	?close@@YAHH@Z:PROC				; close
EXTRN	?read@@YAHHPADH@Z:PROC				; read
EXTRN	?size@@YAHH@Z:PROC				; size
EXTRN	?open@@YAHPAD@Z:PROC				; open
EXTRN	?va2la@@YAPAXHPAX@Z:PROC			; va2la
; Function compile flags: /Ogtpy
;	COMDAT ?do_excute@@YAHPAU_tagMESSAGE@@@Z
_TEXT	SEGMENT
_i$ = -68						; size = 4
_pathname$ = -64					; size = 64
_msg$ = 8						; size = 4
?do_excute@@YAHPAU_tagMESSAGE@@@Z PROC			; do_excute, COMDAT

; 148  : {

	sub	esp, 68					; 00000044H
	push	esi

; 149  : 	PROCESS* p = proc_table;

	mov	esi, OFFSET ?proc_table@@3PAU_tagPROC@@A ; proc_table

; 150  : 	int i ;
; 151  : 	for(i = 0; i < NR_TASKS+NR_PROCS; i++,p++){

	xor	ecx, ecx
	mov	eax, 8
$LL6@do_excute:

; 152  : 		if(p->p_flags == FREE_SLOT)

	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN18@do_excute
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN12@do_excute
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN13@do_excute
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN14@do_excute
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN15@do_excute
	add	esi, 194				; 000000c2H
	cmp	DWORD PTR [esi+118], eax
	je	SHORT $LN16@do_excute
	add	ecx, 6
	add	esi, 194				; 000000c2H
	cmp	ecx, 36					; 00000024H
	jl	SHORT $LL6@do_excute
	jmp	SHORT $LN18@do_excute
$LN12@do_excute:
	add	ecx, 1
	jmp	SHORT $LN18@do_excute
$LN13@do_excute:
	add	ecx, 2
	jmp	SHORT $LN18@do_excute
$LN14@do_excute:
	add	ecx, 3
	jmp	SHORT $LN18@do_excute
$LN15@do_excute:
	add	ecx, 4
	jmp	SHORT $LN18@do_excute
$LN16@do_excute:
	add	ecx, 5
$LN18@do_excute:

; 153  : 			break;
; 154  : 	}
; 155  : 
; 156  : 	int child_pid = i;
; 157  : 	if(child_pid == NR_TASKS + NR_PROCS){

	cmp	ecx, 36					; 00000024H
	mov	DWORD PTR _i$[esp+72], ecx
	jne	SHORT $LN2@do_excute

; 158  : 		return -1;

	or	eax, -1
	pop	esi

; 222  : }

	add	esp, 68					; 00000044H
	ret	0
$LN2@do_excute:
	push	ebx

; 159  : 	}
; 160  : 
; 161  : 	//	duplicate the process table
; 162  : 	int pid = msg->source;

	mov	ebx, DWORD PTR _msg$[esp+72]
	push	ebp
	push	edi
	mov	edi, DWORD PTR [ebx]

; 163  : 	uint16_t child_ldt_sel = p->ldt_sel;
; 164  : 	//*p = proc_table[pid];
; 165  : 	//memcpy(p,&proc_table[pid],sizeof(PROCESS));
; 166  : 
; 167  : 	p->ldt_sel = child_ldt_sel;
; 168  : 	p->p_parent = pid;
; 169  : 	p->nr_tty = proc_table[pid].nr_tty;

	mov	eax, edi
	imul	eax, 194				; 000000c2H
	mov	DWORD PTR [esi+178], edi
	mov	ecx, DWORD PTR ?proc_table@@3PAU_tagPROC@@A[eax+114]
	mov	DWORD PTR [esi+114], ecx

; 170  : 	p->pid = proc2pid(p);

	mov	ecx, esi
	sub	ecx, OFFSET ?proc_table@@3PAU_tagPROC@@A ; proc_table
	mov	eax, 354224107				; 151d07ebH
	imul	ecx
	sar	edx, 4
	mov	eax, edx
	shr	eax, 31					; 0000001fH
	add	eax, edx

; 171  : 
; 172  : 	LDT_DESCRIPTOR* ppd = &proc_table[pid].ldts[0];	//code ldt
; 173  : 	int child_base = (int)pmmgr_alloc_blocks(256);

	push	256					; 00000100H
	mov	DWORD PTR [esi+90], eax
	call	?pmmgr_alloc_blocks@@YAPAXI@Z		; pmmgr_alloc_blocks

; 174  : 	//memcpy((void*)child_base,(void*)caller_t_base,caller_t_size);
; 175  : 	p->base = (void*)child_base;
; 176  : 	p->blocks = 256;
; 177  : 
; 178  : 	//	child's ldt
; 179  : 	ldt_set_descriptor(&p->ldts[0],child_base,
; 180  : 		(PROC_IMAGE_SIZE_DEFAULT - 1) >> LIMIT_4K_SHIFT,
; 181  : 		DA_LIMIT_4K | DA_32 | DA_C | PRIVILEGE_USER << 5);

	push	49400					; 0000c0f8H
	mov	ebp, eax
	push	255					; 000000ffH
	lea	ecx, DWORD PTR [esi+74]
	push	ebp
	push	ecx
	mov	DWORD PTR [esi+182], ebp
	mov	DWORD PTR [esi+186], 256		; 00000100H
	call	?ldt_set_descriptor@@YAXPAU_tagLDT_DESCRIPTOR@@IIG@Z ; ldt_set_descriptor

; 182  : 	ldt_set_descriptor(&p->ldts[1],child_base,
; 183  : 		(PROC_IMAGE_SIZE_DEFAULT - 1) >> LIMIT_4K_SHIFT,
; 184  : 		DA_LIMIT_4K | DA_32 | DA_DRW | PRIVILEGE_USER << 5);

	push	49394					; 0000c0f2H
	push	255					; 000000ffH
	lea	edx, DWORD PTR [esi+82]
	push	ebp
	push	edx
	call	?ldt_set_descriptor@@YAXPAU_tagLDT_DESCRIPTOR@@IIG@Z ; ldt_set_descriptor

; 185  : 	p->regs.cs = (8*0 & SA_RPL_MASK & SA_TI_MASK) | SA_TIL | RPL_USER;
; 186  : 	p->regs.ds = (8*1 & SA_RPL_MASK & SA_TI_MASK) | SA_TIL | RPL_USER;

	mov	eax, 15					; 0000000fH
	mov	DWORD PTR [esi+56], 7
	mov	DWORD PTR [esi+12], eax

; 187  : 	p->regs.es = (8*1 & SA_RPL_MASK & SA_TI_MASK) | SA_TIL | RPL_USER;

	mov	DWORD PTR [esi+8], eax

; 188  : 	p->regs.fs = (8*1 & SA_RPL_MASK & SA_TI_MASK) | SA_TIL | RPL_USER;

	mov	DWORD PTR [esi+4], eax

; 189  : 	p->regs.gs = (8*1 & SA_RPL_MASK & SA_TI_MASK) | SA_TIL | RPL_USER;

	mov	DWORD PTR [esi], eax

; 190  : 	p->regs.ss = (8*1 & SA_RPL_MASK & SA_TI_MASK) | SA_TIL | RPL_USER;

	mov	DWORD PTR [esi+68], eax

; 191  : 	p->regs.eflags = 0x202;

	mov	DWORD PTR [esi+60], 514			; 00000202H

; 192  : 
; 193  : 	int name_len = msg->NAME_LEN;

	mov	esi, DWORD PTR [ebx+12]

; 194  : 	char pathname[MAX_PATH];
; 195  : 	memcpy((void*)va2la(TASK_SYS,pathname),
; 196  : 		(void*)va2la(pid,msg->PATHNAME),
; 197  : 		name_len);

	mov	eax, DWORD PTR [ebx+40]
	add	esp, 36					; 00000024H
	push	esi
	push	eax
	push	edi
	call	?va2la@@YAPAXHPAX@Z			; va2la
	add	esp, 8
	push	eax
	lea	ecx, DWORD PTR _pathname$[esp+92]
	push	ecx
	push	1
	call	?va2la@@YAPAXHPAX@Z			; va2la
	add	esp, 8
	push	eax
	call	?memcpy@@YAPAXPAXPBXI@Z			; memcpy

; 198  : 	pathname[name_len] = 0;
; 199  : 
; 200  : 	int fd = open(pathname);

	lea	edx, DWORD PTR _pathname$[esp+96]
	push	edx
	mov	BYTE PTR _pathname$[esp+esi+100], 0
	call	?open@@YAHPAD@Z				; open
	mov	esi, eax
	add	esp, 16					; 00000010H

; 201  : 	if(fd == -1){

	cmp	esi, -1
	jne	SHORT $LN1@do_excute
	pop	edi
	pop	ebp
	pop	ebx

; 202  : 		return -1;

	or	eax, eax
	pop	esi

; 222  : }

	add	esp, 68					; 00000044H
	ret	0
$LN1@do_excute:

; 203  : 	}
; 204  : 	int file_size = size(fd);

	push	esi
	call	?size@@YAHH@Z				; size
	mov	edi, eax

; 205  : 
; 206  : 	void* sysbuf = pmmgr_alloc_blocks(file_size / PMMGR_BLOCK_SIZE + 1);

	cdq
	and	edx, 4095				; 00000fffH
	add	eax, edx
	sar	eax, 12					; 0000000cH
	add	eax, 1
	push	eax
	call	?pmmgr_alloc_blocks@@YAPAXI@Z		; pmmgr_alloc_blocks
	mov	ebx, eax

; 207  : 	read(fd,(char*)sysbuf,file_size);

	push	edi
	push	ebx
	push	esi
	call	?read@@YAHHPADH@Z			; read

; 208  : 	close(fd);

	push	esi
	call	?close@@YAHH@Z				; close
	add	esp, 24					; 00000018H

; 209  : 
; 210  : 	memcpy(va2la(child_pid, (void*)0x10000),
; 211  : 		va2la(TASK_SYS,sysbuf),
; 212  : 		file_size);

	push	edi
	push	ebx
	push	1
	call	?va2la@@YAPAXHPAX@Z			; va2la
	mov	edi, DWORD PTR _i$[esp+96]
	add	esp, 8
	push	eax
	push	65536					; 00010000H
	push	edi
	call	?va2la@@YAPAXHPAX@Z			; va2la
	add	esp, 8
	push	eax
	call	?memcpy@@YAPAXPAXPBXI@Z			; memcpy

; 213  : 
; 214  : 	proc_table[child_pid].regs.eip = 0x10000;

	mov	esi, edi
	imul	esi, 194				; 000000c2H

; 215  : 	proc_table[child_pid].regs.esp = 0x1000;
; 216  : 
; 217  : 	strcpy(proc_table[child_pid].p_name,pathname);

	lea	eax, DWORD PTR _pathname$[esp+96]
	push	eax
	lea	ecx, DWORD PTR ?proc_table@@3PAU_tagPROC@@A[esi+94]
	push	ecx
	mov	DWORD PTR ?proc_table@@3PAU_tagPROC@@A[esi+52], 65536 ; 00010000H
	mov	DWORD PTR ?proc_table@@3PAU_tagPROC@@A[esi+64], 4096 ; 00001000H
	call	?strcpy@@YAPADPADPBD@Z			; strcpy
	add	esp, 20					; 00000014H

; 218  : 
; 219  : 	proc_table[child_pid].p_flags = 0;
; 220  : 
; 221  : 	return child_pid;

	mov	eax, edi
	pop	edi
	pop	ebp
	pop	ebx
	mov	DWORD PTR ?proc_table@@3PAU_tagPROC@@A[esi+118], 0
	pop	esi

; 222  : }

	add	esp, 68					; 00000044H
	ret	0
?do_excute@@YAHPAU_tagMESSAGE@@@Z ENDP			; do_excute
_TEXT	ENDS
PUBLIC	?do_exit@@YAXPAU_tagMESSAGE@@H@Z		; do_exit
EXTRN	?pmmgr_free_blocks@@YAXPAXI@Z:PROC		; pmmgr_free_blocks
; Function compile flags: /Ogtpy
;	COMDAT ?do_exit@@YAXPAU_tagMESSAGE@@H@Z
_TEXT	SEGMENT
_msg$ = 8						; size = 4
_status$ = 12						; size = 4
?do_exit@@YAXPAU_tagMESSAGE@@H@Z PROC			; do_exit, COMDAT

; 122  : 	int i;
; 123  : 	int pid = msg->source;

	mov	eax, DWORD PTR _msg$[esp-4]
	push	esi
	push	edi
	mov	edi, DWORD PTR [eax]

; 124  : 	int parent_id = proc_table[pid].p_parent;
; 125  : 	PROCESS* p = &proc_table[pid];

	mov	esi, edi
	imul	esi, 194				; 000000c2H

; 126  : 
; 127  : 	if(p->base != 0 && p->blocks != 0){

	mov	ecx, DWORD PTR ?proc_table@@3PAU_tagPROC@@A[esi+182]
	test	ecx, ecx
	je	SHORT $LN5@do_exit
	mov	eax, DWORD PTR ?proc_table@@3PAU_tagPROC@@A[esi+186]
	test	eax, eax
	je	SHORT $LN5@do_exit

; 128  : 		pmmgr_free_blocks(p->base,p->blocks * 4096);

	shl	eax, 12					; 0000000cH
	push	eax
	push	ecx
	call	?pmmgr_free_blocks@@YAXPAXI@Z		; pmmgr_free_blocks
	add	esp, 8
$LN5@do_exit:

; 129  : 	}
; 130  : 
; 131  : 	p->exit_code = status;

	mov	ecx, DWORD PTR _status$[esp+4]
	mov	DWORD PTR ?proc_table@@3PAU_tagPROC@@A[esi+190], ecx

; 132  : 
; 133  : 	cleanup(&proc_table[pid]);

	mov	DWORD PTR ?proc_table@@3PAU_tagPROC@@A[esi+118], 8
	mov	eax, OFFSET ?proc_table@@3PAU_tagPROC@@A+178
	npad	6
$LL4@do_exit:

; 136  : 		if(proc_table[i].p_parent == pid){

	cmp	DWORD PTR [eax], edi
	jne	SHORT $LN3@do_exit

; 137  : 			proc_table[i].p_parent = INIT;

	mov	DWORD PTR [eax], 5
$LN3@do_exit:

; 134  : 
; 135  : 	for(i = 0;i < NR_TASKS+NR_PROCS; i++){

	add	eax, 194				; 000000c2H
	cmp	eax, OFFSET ?proc_table@@3PAU_tagPROC@@A+7162
	jl	SHORT $LL4@do_exit
	pop	edi
	pop	esi

; 138  : 		}
; 139  : 	}
; 140  : }

	ret	0
?do_exit@@YAXPAU_tagMESSAGE@@H@Z ENDP			; do_exit
_TEXT	ENDS
PUBLIC	?task_sys@@YAXXZ				; task_sys
EXTRN	?ticks@@3IA:DWORD				; ticks
; Function compile flags: /Ogtpy
;	COMDAT ?task_sys@@YAXXZ
_TEXT	SEGMENT
_msg$3193 = -48						; size = 48
?task_sys@@YAXXZ PROC					; task_sys, COMDAT

; 18   : {

	sub	esp, 48					; 00000030H
	push	esi
$LL9@task_sys:

; 19   : 	while(1){
; 20   : 		MESSAGE msg;
; 21   : 		while(1){
; 22   : 			send_recv(RECEIVE,ANY_TASK,&msg);

	lea	eax, DWORD PTR _msg$3193[esp+52]
	push	eax
	push	46					; 0000002eH
	push	2
	call	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z	; send_recv

; 23   : 			int src = msg.source;
; 24   : 
; 25   : 			switch(msg.type){

	mov	eax, DWORD PTR _msg$3193[esp+68]
	mov	esi, DWORD PTR _msg$3193[esp+64]
	add	esp, 12					; 0000000cH
	cmp	eax, 1013				; 000003f5H
	jg	SHORT $LN14@task_sys
	je	SHORT $LN3@task_sys
	cmp	eax, 3
	je	SHORT $LN5@task_sys
	cmp	eax, 1012				; 000003f4H
	jne	SHORT $LL9@task_sys

; 32   : 			case FORK:
; 33   : 				{
; 34   : 					msg.RETVAL = do_fork(&msg);

	lea	ecx, DWORD PTR _msg$3193[esp+52]
	push	ecx
	call	?do_fork@@YAHPAU_tagMESSAGE@@@Z		; do_fork

; 35   : 					msg.type = SYSCALL_RET;
; 36   : 					send_recv(SEND,src,&msg);

	lea	edx, DWORD PTR _msg$3193[esp+56]
	push	edx
	push	esi
	push	1
	mov	DWORD PTR _msg$3193[esp+76], eax
	mov	DWORD PTR _msg$3193[esp+72], 2
	call	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z	; send_recv
	add	esp, 16					; 00000010H

; 37   : 				}
; 38   : 				break;

	jmp	SHORT $LL9@task_sys
$LN5@task_sys:

; 26   : 			case GET_TICKS:
; 27   : 				{
; 28   : 					msg.RETVAL = ticks;

	mov	eax, DWORD PTR ?ticks@@3IA		; ticks

; 29   : 					send_recv(SEND,src,&msg);

	lea	ecx, DWORD PTR _msg$3193[esp+52]
	push	ecx
	push	esi
	push	1
	mov	DWORD PTR _msg$3193[esp+72], eax
	call	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z	; send_recv
	add	esp, 12					; 0000000cH

; 30   : 				}
; 31   : 				break;

	jmp	SHORT $LL9@task_sys
$LN3@task_sys:

; 39   : 			case EXIT:
; 40   : 				{
; 41   : 					do_exit(&msg,msg.STATUS);

	mov	edx, DWORD PTR _msg$3193[esp+60]
	push	edx
	lea	eax, DWORD PTR _msg$3193[esp+56]
	push	eax
	call	?do_exit@@YAXPAU_tagMESSAGE@@H@Z	; do_exit

; 42   : 					send_recv(SEND,src,&msg);

	lea	ecx, DWORD PTR _msg$3193[esp+60]
	push	ecx
	push	esi
	push	1
	call	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z	; send_recv
	add	esp, 20					; 00000014H

; 43   : 				}
; 44   : 				break;

	jmp	$LL9@task_sys
$LN14@task_sys:

; 23   : 			int src = msg.source;
; 24   : 
; 25   : 			switch(msg.type){

	cmp	eax, 1014				; 000003f6H

; 45   : 			case EXCUTE:
; 46   : 				{
; 47   : 					msg.RETVAL = do_excute(&msg);
; 48   : 					send_recv(SEND,src,&msg);
; 49   : 				}
; 50   : 				break;
; 51   : 			default:
; 52   : 				{}
; 53   : 				break;

	jne	$LL9@task_sys
	lea	edx, DWORD PTR _msg$3193[esp+52]
	push	edx
	call	?do_excute@@YAHPAU_tagMESSAGE@@@Z	; do_excute
	mov	DWORD PTR _msg$3193[esp+64], eax
	lea	eax, DWORD PTR _msg$3193[esp+56]
	push	eax
	push	esi
	push	1
	call	?send_recv@@YAHHHPAU_tagMESSAGE@@@Z	; send_recv
	add	esp, 16					; 00000010H

; 54   : 			}
; 55   : 		}

	jmp	$LL9@task_sys
?task_sys@@YAXXZ ENDP					; task_sys
_TEXT	ENDS
END
