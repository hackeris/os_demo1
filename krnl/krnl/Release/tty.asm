; Listing generated by Microsoft (R) Optimizing Compiler Version 14.00.50727.762 

	TITLE	i:\os\10\a\krnl\krnl\tty.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

PUBLIC	?nr_current_console@@3IA			; nr_current_console
PUBLIC	?tty_table@@3PAU_tagTTY@@A			; tty_table
PUBLIC	?console_table@@3PAU_tagCONSOLE@@A		; console_table
PUBLIC	?disp_pos@@3IA					; disp_pos
_BSS	SEGMENT
?nr_current_console@@3IA DD 01H DUP (?)			; nr_current_console
?tty_table@@3PAU_tagTTY@@A DB 0c30H DUP (?)		; tty_table
?console_table@@3PAU_tagCONSOLE@@A DB 030H DUP (?)	; console_table
?disp_pos@@3IA DD 01H DUP (?)				; disp_pos
_BSS	ENDS
PUBLIC	?is_current_console@@YAHPAU_tagCONSOLE@@@Z	; is_current_console
; Function compile flags: /Ogtpy
; File i:\os\10\a\krnl\krnl\tty.cpp
;	COMDAT ?is_current_console@@YAHPAU_tagCONSOLE@@@Z
_TEXT	SEGMENT
_p_con$ = 8						; size = 4
?is_current_console@@YAHPAU_tagCONSOLE@@@Z PROC		; is_current_console, COMDAT

; 93   : 	return (p_con == &console_table[nr_current_console]);

	mov	eax, DWORD PTR ?nr_current_console@@3IA	; nr_current_console
	shl	eax, 4
	add	eax, OFFSET ?console_table@@3PAU_tagCONSOLE@@A ; console_table
	xor	ecx, ecx
	cmp	DWORD PTR _p_con$[esp-4], eax
	sete	cl
	mov	eax, ecx

; 94   : }

	ret	0
?is_current_console@@YAHPAU_tagCONSOLE@@@Z ENDP		; is_current_console
_TEXT	ENDS
PUBLIC	?tty_do_read@@YAXPAU_tagTTY@@@Z			; tty_do_read
EXTRN	?keyboard_read@@YAXPAU_tagTTY@@@Z:PROC		; keyboard_read
; Function compile flags: /Ogtpy
;	COMDAT ?tty_do_read@@YAXPAU_tagTTY@@@Z
_TEXT	SEGMENT
_p_tty$ = 8						; size = 4
?tty_do_read@@YAXPAU_tagTTY@@@Z PROC			; tty_do_read, COMDAT

; 98   : 	if(is_current_console(p_tty->p_console)){

	mov	ecx, DWORD PTR ?nr_current_console@@3IA	; nr_current_console
	mov	eax, DWORD PTR _p_tty$[esp-4]
	shl	ecx, 4
	add	ecx, OFFSET ?console_table@@3PAU_tagCONSOLE@@A ; console_table
	cmp	DWORD PTR [eax+1036], ecx
	jne	SHORT $LN1@tty_do_rea

; 99   : 		keyboard_read(p_tty);

	mov	DWORD PTR _p_tty$[esp-4], eax
	jmp	?keyboard_read@@YAXPAU_tagTTY@@@Z	; keyboard_read
$LN1@tty_do_rea:

; 100  : 	}
; 101  : }

	ret	0
?tty_do_read@@YAXPAU_tagTTY@@@Z ENDP			; tty_do_read
_TEXT	ENDS
PUBLIC	?set_cursor@@YAXI@Z				; set_cursor
EXTRN	?enable_interrupt@@YAXXZ:PROC			; enable_interrupt
EXTRN	?out_byte@@YAXGE@Z:PROC				; out_byte
EXTRN	?disable_interrupt@@YAXXZ:PROC			; disable_interrupt
; Function compile flags: /Ogtpy
;	COMDAT ?set_cursor@@YAXI@Z
_TEXT	SEGMENT
_position$ = 8						; size = 4
?set_cursor@@YAXI@Z PROC				; set_cursor, COMDAT

; 154  : {

	push	esi

; 155  : 	disable_interrupt();

	call	?disable_interrupt@@YAXXZ		; disable_interrupt

; 156  : 	out_byte(CRTC_ADDR_REG,CURSOR_H);

	push	14					; 0000000eH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte

; 157  : 	out_byte(CRTC_DATA_REG,(position >> 8) & 0xff);

	mov	esi, DWORD PTR _position$[esp+8]
	mov	eax, esi
	shr	eax, 8
	push	eax
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte

; 158  : 	out_byte(CRTC_ADDR_REG,CURSOR_L);

	push	15					; 0000000fH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte

; 159  : 	out_byte(CRTC_DATA_REG,(position & 0xff));

	push	esi
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte
	add	esp, 32					; 00000020H
	pop	esi

; 160  : 	enable_interrupt();

	jmp	?enable_interrupt@@YAXXZ		; enable_interrupt
?set_cursor@@YAXI@Z ENDP				; set_cursor
_TEXT	ENDS
PUBLIC	?set_video_start_addr@@YAXI@Z			; set_video_start_addr
; Function compile flags: /Ogtpy
;	COMDAT ?set_video_start_addr@@YAXI@Z
_TEXT	SEGMENT
_addr$ = 8						; size = 4
?set_video_start_addr@@YAXI@Z PROC			; set_video_start_addr, COMDAT

; 197  : {

	push	esi

; 198  : 	disable_interrupt();

	call	?disable_interrupt@@YAXXZ		; disable_interrupt

; 199  : 	out_byte(CRTC_ADDR_REG,START_ADDR_H);

	push	12					; 0000000cH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte

; 200  : 	out_byte(CRTC_DATA_REG,(addr >> 8) & 0xff);

	mov	esi, DWORD PTR _addr$[esp+8]
	mov	eax, esi
	shr	eax, 8
	push	eax
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte

; 201  : 	out_byte(CRTC_ADDR_REG,START_ADDR_L);

	push	13					; 0000000dH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte

; 202  : 	out_byte(CRTC_DATA_REG,(addr) & 0xff);

	push	esi
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte
	add	esp, 32					; 00000020H
	pop	esi

; 203  : 	enable_interrupt();

	jmp	?enable_interrupt@@YAXXZ		; enable_interrupt
?set_video_start_addr@@YAXI@Z ENDP			; set_video_start_addr
_TEXT	ENDS
PUBLIC	?scroll_screen@@YAXPAU_tagCONSOLE@@H@Z		; scroll_screen
; Function compile flags: /Ogtpy
;	COMDAT ?scroll_screen@@YAXPAU_tagCONSOLE@@H@Z
_TEXT	SEGMENT
_p_con$ = 8						; size = 4
_direction$ = 12					; size = 4
?scroll_screen@@YAXPAU_tagCONSOLE@@H@Z PROC		; scroll_screen, COMDAT

; 208  : 	if(direction == SCR_UP){

	mov	eax, DWORD PTR _direction$[esp-4]
	cmp	eax, 1
	jne	SHORT $LN5@scroll_scr

; 209  : 		if(p_con->current_start_addr > p_con->original_addr){

	mov	eax, DWORD PTR _p_con$[esp-4]
	mov	ecx, DWORD PTR [eax]
	cmp	ecx, DWORD PTR [eax+4]
	jbe	SHORT $LN1@scroll_scr

; 210  : 			p_con->current_start_addr -= SCREEN_WIDTH;

	add	ecx, -80				; ffffffb0H

; 216  : 				p_con->current_start_addr += SCREEN_WIDTH;

	mov	DWORD PTR [eax], ecx

; 217  : 		}
; 218  : 	}
; 219  : 
; 220  : 	//set_video_start_addr(p_con->current_start_addr);
; 221  : 	//set_cursor(p_con->cursor);
; 222  : }

	ret	0
$LN5@scroll_scr:

; 211  : 		}
; 212  : 	}
; 213  : 	else if(direction ==SCR_DN){

	cmp	eax, -1
	jne	SHORT $LN1@scroll_scr

; 214  : 		if(p_con->current_start_addr + SCREEN_SIZE <
; 215  : 			p_con->original_addr + p_con->v_mem_limit){

	mov	eax, DWORD PTR _p_con$[esp-4]
	mov	edx, DWORD PTR [eax+8]
	mov	ecx, DWORD PTR [eax]
	add	edx, DWORD PTR [eax+4]
	push	esi
	lea	esi, DWORD PTR [ecx+2000]
	cmp	esi, edx
	pop	esi
	jae	SHORT $LN1@scroll_scr

; 216  : 				p_con->current_start_addr += SCREEN_WIDTH;

	add	ecx, 80					; 00000050H
	mov	DWORD PTR [eax], ecx
$LN1@scroll_scr:

; 217  : 		}
; 218  : 	}
; 219  : 
; 220  : 	//set_video_start_addr(p_con->current_start_addr);
; 221  : 	//set_cursor(p_con->cursor);
; 222  : }

	ret	0
?scroll_screen@@YAXPAU_tagCONSOLE@@H@Z ENDP		; scroll_screen
_TEXT	ENDS
PUBLIC	?put_key@@YAXPAU_tagTTY@@I@Z			; put_key
; Function compile flags: /Ogtpy
;	COMDAT ?put_key@@YAXPAU_tagTTY@@I@Z
_TEXT	SEGMENT
_p_tty$ = 8						; size = 4
_key$ = 12						; size = 4
?put_key@@YAXPAU_tagTTY@@I@Z PROC			; put_key, COMDAT

; 226  : 	if(p_tty->inbuf_count < TTY_IN_BYTES){

	mov	ecx, DWORD PTR _p_tty$[esp-4]
	cmp	DWORD PTR [ecx+1032], 256		; 00000100H
	jge	SHORT $LN2@put_key

; 227  : 		*(p_tty->p_inbuf_head) = key;

	mov	edx, DWORD PTR [ecx+1024]
	lea	eax, DWORD PTR [ecx+1024]
	push	esi
	mov	esi, DWORD PTR _key$[esp]
	mov	DWORD PTR [edx], esi

; 228  : 		p_tty->p_inbuf_head ++;

	add	DWORD PTR [eax], 4

; 229  : 		if(p_tty->p_inbuf_head == p_tty->in_buf + TTY_IN_BYTES){

	cmp	DWORD PTR [eax], eax
	pop	esi
	jne	SHORT $LN1@put_key

; 230  : 			p_tty->p_inbuf_head = p_tty->in_buf;

	mov	DWORD PTR [eax], ecx
$LN1@put_key:

; 231  : 		}
; 232  : 		p_tty->inbuf_count ++;

	add	DWORD PTR [ecx+1032], 1
$LN2@put_key:

; 233  : 	}
; 234  : }

	ret	0
?put_key@@YAXPAU_tagTTY@@I@Z ENDP			; put_key
_TEXT	ENDS
PUBLIC	?flush@@YAXPAU_tagCONSOLE@@@Z			; flush
; Function compile flags: /Ogtpy
;	COMDAT ?flush@@YAXPAU_tagCONSOLE@@@Z
_TEXT	SEGMENT
_p_con$ = 8						; size = 4
?flush@@YAXPAU_tagCONSOLE@@@Z PROC			; flush, COMDAT

; 237  : {

	push	esi
	push	edi

; 238  : 	set_cursor(p_con->cursor);

	mov	edi, DWORD PTR _p_con$[esp+4]
	mov	esi, DWORD PTR [edi+12]
	call	?disable_interrupt@@YAXXZ		; disable_interrupt
	push	14					; 0000000eH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte
	mov	eax, esi
	shr	eax, 8
	push	eax
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte
	push	15					; 0000000fH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte
	push	esi
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte
	call	?enable_interrupt@@YAXXZ		; enable_interrupt

; 239  : 	set_video_start_addr(p_con->current_start_addr);

	mov	esi, DWORD PTR [edi]
	call	?disable_interrupt@@YAXXZ		; disable_interrupt
	push	12					; 0000000cH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte
	mov	ecx, esi
	shr	ecx, 8
	push	ecx
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte
	push	13					; 0000000dH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte
	push	esi
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte
	add	esp, 64					; 00000040H
	pop	edi
	pop	esi
	jmp	?enable_interrupt@@YAXXZ		; enable_interrupt
?flush@@YAXPAU_tagCONSOLE@@@Z ENDP			; flush
_TEXT	ENDS
PUBLIC	?out_char@@YAXPAU_tagCONSOLE@@D@Z		; out_char
; Function compile flags: /Ogtpy
;	COMDAT ?out_char@@YAXPAU_tagCONSOLE@@D@Z
_TEXT	SEGMENT
_p_con$ = 8						; size = 4
_ch$ = 12						; size = 1
?out_char@@YAXPAU_tagCONSOLE@@D@Z PROC			; out_char, COMDAT

; 119  : 	uint8_t*	p_vmem = (uint8_t*)(V_MEM_BASE + p_con->cursor * 2);

	mov	ecx, DWORD PTR _p_con$[esp-4]
	mov	edx, DWORD PTR [ecx+12]
	push	ebx

; 120  : 
; 121  : 	switch(ch){

	mov	bl, BYTE PTR _ch$[esp]
	movsx	eax, bl
	sub	eax, 8
	push	esi
	je	SHORT $LN7@out_char

; 133  : 		}
; 134  : 		break;
; 135  : 	default:
; 136  : 		{
; 137  : 			if(p_con->cursor < p_con->original_addr + p_con->v_mem_limit - 1){

	mov	esi, DWORD PTR [ecx+4]
	sub	eax, 2
	mov	eax, DWORD PTR [ecx+8]
	je	SHORT $LN9@out_char
	lea	eax, DWORD PTR [eax+esi-1]
	cmp	edx, eax
	jae	SHORT $LN6@out_char

; 138  : 				*p_vmem++ = ch;

	mov	BYTE PTR [edx*2+753664], bl

; 139  : 				*p_vmem++ = DEFAULT_CHAR_COLOR;

	mov	BYTE PTR [edx*2+753665], 7

; 140  : 				p_con->cursor++;

	add	DWORD PTR [ecx+12], 1

; 141  : 			}
; 142  : 		}
; 143  : 		break;

	jmp	SHORT $LN6@out_char
$LN9@out_char:

; 122  : 	case '\n':
; 123  : 		if(p_con->cursor < p_con->original_addr + p_con->v_mem_limit - SCREEN_WIDTH){

	lea	eax, DWORD PTR [eax+esi-80]
	cmp	edx, eax
	jae	SHORT $LN6@out_char

; 124  : 			p_con->cursor = p_con->original_addr + SCREEN_WIDTH * 
; 125  : 				((p_con->cursor - p_con->original_addr) / SCREEN_WIDTH + 1);

	sub	edx, esi
	mov	eax, -858993459				; cccccccdH
	mul	edx
	shr	edx, 6
	add	edx, 1
	lea	edx, DWORD PTR [edx+edx*4]
	shl	edx, 4
	add	edx, esi
	mov	DWORD PTR [ecx+12], edx

; 126  : 		}
; 127  : 		break;

	jmp	SHORT $LN6@out_char
$LN7@out_char:

; 128  : 	case '\b':
; 129  : 		if(p_con->cursor > p_con->original_addr){

	cmp	edx, DWORD PTR [ecx+4]
	jbe	SHORT $LN6@out_char

; 130  : 			p_con->cursor --;

	lea	eax, DWORD PTR [edx-1]
	mov	DWORD PTR [ecx+12], eax

; 131  : 			*(p_vmem - 2) = ' ';

	mov	BYTE PTR [edx*2+753662], 32		; 00000020H

; 132  : 			*(p_vmem - 1) = DEFAULT_CHAR_COLOR;

	mov	BYTE PTR [edx*2+753663], 7
$LN6@out_char:

; 144  : 	}
; 145  : 	while(p_con->cursor >= p_con->current_start_addr + SCREEN_SIZE ){

	mov	edx, DWORD PTR [ecx]
	add	edx, 2000				; 000007d0H
	cmp	DWORD PTR [ecx+12], edx
	jb	SHORT $LN2@out_char

; 146  : 		scroll_screen(p_con,SCR_DN);

	mov	eax, DWORD PTR [ecx+8]
	mov	edx, DWORD PTR [ecx+4]
	add	edx, eax
$LL3@out_char:
	mov	eax, DWORD PTR [ecx]
	lea	esi, DWORD PTR [eax+2000]
	cmp	esi, edx
	jae	SHORT $LN14@out_char
	add	eax, 80					; 00000050H
	mov	DWORD PTR [ecx], eax
$LN14@out_char:
	mov	eax, DWORD PTR [ecx]
	add	eax, 2000				; 000007d0H
	cmp	DWORD PTR [ecx+12], eax
	jae	SHORT $LL3@out_char
$LN2@out_char:

; 147  : 	}
; 148  : 	if(nr_current_console == p_con - console_table){

	mov	edx, ecx
	sub	edx, OFFSET ?console_table@@3PAU_tagCONSOLE@@A ; console_table
	sar	edx, 4
	cmp	DWORD PTR ?nr_current_console@@3IA, edx	; nr_current_console
	pop	esi
	pop	ebx
	jne	SHORT $LN1@out_char

; 149  : 		flush(p_con);

	push	ecx
	call	?flush@@YAXPAU_tagCONSOLE@@@Z		; flush
	pop	ecx
$LN1@out_char:

; 150  : 	}
; 151  : }

	ret	0
?out_char@@YAXPAU_tagCONSOLE@@D@Z ENDP			; out_char
_TEXT	ENDS
PUBLIC	?init_screen@@YAXPAU_tagTTY@@@Z			; init_screen
; Function compile flags: /Ogtpy
;	COMDAT ?init_screen@@YAXPAU_tagTTY@@@Z
_TEXT	SEGMENT
_p_tty$ = 8						; size = 4
?init_screen@@YAXPAU_tagTTY@@@Z PROC			; init_screen, COMDAT

; 164  : {

	push	esi

; 165  : 	int nr_tty = p_tty - tty_table;

	mov	esi, DWORD PTR _p_tty$[esp]
	mov	ecx, esi
	sub	ecx, OFFSET ?tty_table@@3PAU_tagTTY@@A	; tty_table
	mov	eax, 2114445439				; 7e07e07fH
	imul	ecx
	sar	edx, 9
	mov	eax, edx
	shr	eax, 31					; 0000001fH
	add	eax, edx

; 166  : 	p_tty->p_console = &console_table[nr_tty];
; 167  : 
; 168  : 	int v_mem_size = V_MEM_SIZE >> 1;
; 169  : 
; 170  : 	int con_v_mem_size = v_mem_size / NR_CONSOLES;
; 171  : 	p_tty->p_console->original_addr	= nr_tty * con_v_mem_size;

	mov	edx, eax
	imul	edx, 5461				; 00001555H
	mov	ecx, eax
	shl	ecx, 4

; 172  : 	p_tty->p_console->v_mem_limit	= con_v_mem_size;
; 173  : 	p_tty->p_console->current_start_addr = p_tty->p_console->original_addr;
; 174  : 	p_tty->p_console->cursor		= p_tty->p_console->original_addr;
; 175  : 
; 176  : 	if(nr_tty == 0){

	test	eax, eax
	lea	ecx, DWORD PTR ?console_table@@3PAU_tagCONSOLE@@A[ecx]
	mov	DWORD PTR [esi+1036], ecx
	mov	DWORD PTR [ecx+4], edx
	mov	ecx, DWORD PTR [esi+1036]
	mov	DWORD PTR [ecx+8], 5461			; 00001555H
	mov	ecx, DWORD PTR [esi+1036]
	mov	edx, DWORD PTR [ecx+4]
	mov	DWORD PTR [ecx], edx
	mov	ecx, DWORD PTR [esi+1036]
	mov	edx, DWORD PTR [ecx+4]
	mov	DWORD PTR [ecx+12], edx
	jne	SHORT $LN2@init_scree

; 177  : 		p_tty->p_console->cursor = disp_pos / 2;

	mov	eax, DWORD PTR ?disp_pos@@3IA		; disp_pos
	mov	ecx, DWORD PTR [esi+1036]
	shr	eax, 1
	mov	DWORD PTR [ecx+12], eax

; 178  : 		disp_pos = 0;

	mov	DWORD PTR ?disp_pos@@3IA, 0		; disp_pos

; 179  : 	}
; 180  : 	else{

	jmp	SHORT $LN1@init_scree
$LN2@init_scree:

; 181  : 		out_char(p_tty->p_console,nr_tty + '0');

	mov	edx, DWORD PTR [esi+1036]
	add	al, 48					; 00000030H
	push	eax
	push	edx
	call	?out_char@@YAXPAU_tagCONSOLE@@D@Z	; out_char

; 182  : 		out_char(p_tty->p_console,'#');

	mov	eax, DWORD PTR [esi+1036]
	push	35					; 00000023H
	push	eax
	call	?out_char@@YAXPAU_tagCONSOLE@@D@Z	; out_char
	add	esp, 16					; 00000010H
$LN1@init_scree:

; 183  : 	}
; 184  : 	set_cursor(p_tty->p_console->cursor);

	mov	ecx, DWORD PTR [esi+1036]
	mov	esi, DWORD PTR [ecx+12]
	call	?disable_interrupt@@YAXXZ		; disable_interrupt
	push	14					; 0000000eH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte
	mov	edx, esi
	shr	edx, 8
	push	edx
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte
	push	15					; 0000000fH
	push	980					; 000003d4H
	call	?out_byte@@YAXGE@Z			; out_byte
	push	esi
	push	981					; 000003d5H
	call	?out_byte@@YAXGE@Z			; out_byte
	add	esp, 32					; 00000020H
	pop	esi
	jmp	?enable_interrupt@@YAXXZ		; enable_interrupt
?init_screen@@YAXPAU_tagTTY@@@Z ENDP			; init_screen
_TEXT	ENDS
PUBLIC	?select_console@@YAXH@Z				; select_console
; Function compile flags: /Ogtpy
;	COMDAT ?select_console@@YAXH@Z
_TEXT	SEGMENT
_nr_console$ = 8					; size = 4
?select_console@@YAXH@Z PROC				; select_console, COMDAT

; 189  : 	if(nr_console < 0 || nr_console >= NR_CONSOLES){

	mov	eax, DWORD PTR _nr_console$[esp-4]
	cmp	eax, 2
	ja	SHORT $LN1@select_con

; 190  : 		return;
; 191  : 	}
; 192  : 	nr_current_console = nr_console ;

	mov	DWORD PTR ?nr_current_console@@3IA, eax	; nr_current_console

; 193  : 	flush(&console_table[nr_console]);

	shl	eax, 4
	add	eax, OFFSET ?console_table@@3PAU_tagCONSOLE@@A ; console_table
	mov	DWORD PTR _nr_console$[esp-4], eax
	jmp	?flush@@YAXPAU_tagCONSOLE@@@Z		; flush
$LN1@select_con:

; 194  : }

	ret	0
?select_console@@YAXH@Z ENDP				; select_console
_TEXT	ENDS
PUBLIC	?tty_write@@YAXPAU_tagTTY@@PADH@Z		; tty_write
; Function compile flags: /Ogtpy
;	COMDAT ?tty_write@@YAXPAU_tagTTY@@PADH@Z
_TEXT	SEGMENT
_p_tty$ = 8						; size = 4
_buf$ = 12						; size = 4
_len$ = 16						; size = 4
?tty_write@@YAXPAU_tagTTY@@PADH@Z PROC			; tty_write, COMDAT

; 243  : {

	push	esi

; 244  : 	char* p = buf;

	mov	esi, DWORD PTR _buf$[esp]
	push	edi

; 245  : 	int i = len;

	mov	edi, DWORD PTR _len$[esp+4]

; 246  : 	while(i){

	test	edi, edi
	je	SHORT $LN1@tty_write
	push	ebx
	mov	ebx, DWORD PTR _p_tty$[esp+8]
$LL2@tty_write:

; 247  : 		out_char(p_tty->p_console,*p++);

	movzx	eax, BYTE PTR [esi]
	push	eax
	mov	eax, DWORD PTR [ebx+1036]
	push	eax
	call	?out_char@@YAXPAU_tagCONSOLE@@D@Z	; out_char
	add	esp, 8
	add	esi, 1

; 248  : 		i--;

	sub	edi, 1
	jne	SHORT $LL2@tty_write
	pop	ebx
$LN1@tty_write:
	pop	edi
	pop	esi

; 249  : 	}
; 250  : }

	ret	0
?tty_write@@YAXPAU_tagTTY@@PADH@Z ENDP			; tty_write
_TEXT	ENDS
PUBLIC	?init_tty@@YAXPAU_tagTTY@@@Z			; init_tty
; Function compile flags: /Ogtpy
;	COMDAT ?init_tty@@YAXPAU_tagTTY@@@Z
_TEXT	SEGMENT
_p_tty$ = 8						; size = 4
?init_tty@@YAXPAU_tagTTY@@@Z PROC			; init_tty, COMDAT

; 33   : 	p_tty->inbuf_count = 0;

	mov	eax, DWORD PTR _p_tty$[esp-4]
	mov	DWORD PTR [eax+1032], 0

; 34   : 	p_tty->p_inbuf_head = p_tty->p_inbuf_tial = p_tty->in_buf;

	mov	DWORD PTR [eax+1028], eax
	mov	DWORD PTR [eax+1024], eax

; 35   : 
; 36   : 	init_screen(p_tty);

	mov	DWORD PTR _p_tty$[esp-4], eax
	jmp	?init_screen@@YAXPAU_tagTTY@@@Z		; init_screen
?init_tty@@YAXPAU_tagTTY@@@Z ENDP			; init_tty
_TEXT	ENDS
PUBLIC	?in_process@@YAXPAU_tagTTY@@I@Z			; in_process
; Function compile flags: /Ogtpy
;	COMDAT ?in_process@@YAXPAU_tagTTY@@I@Z
_TEXT	SEGMENT
_p_tty$ = 8						; size = 4
_key$ = 12						; size = 4
?in_process@@YAXPAU_tagTTY@@I@Z PROC			; in_process, COMDAT

; 41   : 	if(!(key & FLAG_EXT)){

	mov	ecx, DWORD PTR _key$[esp-4]
	test	ecx, 256				; 00000100H
	push	esi
	jne	SHORT $LN17@in_process

; 42   : 		if(p_tty->inbuf_count < TTY_IN_BYTES){

	mov	edx, DWORD PTR _p_tty$[esp]
	cmp	DWORD PTR [edx+1032], 256		; 00000100H
	jge	$LN2@in_process

; 43   : 			*(p_tty->p_inbuf_head) = key;

	mov	esi, DWORD PTR [edx+1024]
	lea	eax, DWORD PTR [edx+1024]
	mov	DWORD PTR [esi], ecx

; 44   : 			p_tty->p_inbuf_head ++;

	add	DWORD PTR [eax], 4

; 45   : 			if(p_tty->p_inbuf_head == p_tty->in_buf + TTY_IN_BYTES){

	cmp	DWORD PTR [eax], eax
	jne	SHORT $LN15@in_process

; 46   : 				p_tty->p_inbuf_head = p_tty->in_buf;

	mov	DWORD PTR [eax], edx
$LN15@in_process:

; 47   : 			}
; 48   : 			p_tty->inbuf_count ++;

	add	DWORD PTR [edx+1032], 1
	pop	esi

; 84   : 			}
; 85   : 		default:
; 86   : 			break;
; 87   : 		}
; 88   : 	}
; 89   : }

	ret	0
$LN17@in_process:

; 49   : 		}
; 50   : 	}
; 51   : 	else{
; 52   : 		int raw_code = key & MASK_RAW;

	mov	eax, ecx
	and	eax, 511				; 000001ffH

; 53   : 		switch(raw_code){

	lea	edx, DWORD PTR [eax-259]
	cmp	edx, 35					; 00000023H
	ja	$LN2@in_process
	movzx	edx, BYTE PTR $LN34@in_process[edx]
	jmp	DWORD PTR $LN37@in_process[edx*4]
$LN11@in_process:

; 54   : 		case UP:
; 55   : 			if((key & FLAG_SHIFT_L) || (key & FLAG_SHIFT_R)){

	test	ecx, 1536				; 00000600H
	je	SHORT $LN2@in_process

; 56   : 				scroll_screen(p_tty->p_console,SCR_DN);

	mov	eax, DWORD PTR _p_tty$[esp]
	mov	eax, DWORD PTR [eax+1036]
	mov	edx, DWORD PTR [eax+8]
	mov	ecx, DWORD PTR [eax]
	add	edx, DWORD PTR [eax+4]
	lea	esi, DWORD PTR [ecx+2000]
	cmp	esi, edx
	jae	SHORT $LN2@in_process
	add	ecx, 80					; 00000050H
	mov	DWORD PTR [eax], ecx
	pop	esi

; 84   : 			}
; 85   : 		default:
; 86   : 			break;
; 87   : 		}
; 88   : 	}
; 89   : }

	ret	0
$LN8@in_process:

; 57   : 			}
; 58   : 			break;
; 59   : 		case DOWN:
; 60   : 			if((key & FLAG_SHIFT_L) || (key & FLAG_SHIFT_R)){

	test	ecx, 1536				; 00000600H
	je	SHORT $LN2@in_process

; 61   : 				scroll_screen(p_tty->p_console,SCR_UP);

	mov	eax, DWORD PTR _p_tty$[esp]
	mov	eax, DWORD PTR [eax+1036]
	mov	ecx, DWORD PTR [eax]
	cmp	ecx, DWORD PTR [eax+4]
	jbe	SHORT $LN2@in_process
	add	ecx, -80				; ffffffb0H
	mov	DWORD PTR [eax], ecx
	pop	esi

; 84   : 			}
; 85   : 		default:
; 86   : 			break;
; 87   : 		}
; 88   : 	}
; 89   : }

	ret	0
$LN5@in_process:
	pop	esi

; 62   : 			}
; 63   : 			break;
; 64   : 		case ENTER:
; 65   : 			put_key(p_tty,'\n');

	mov	DWORD PTR _key$[esp-4], 10		; 0000000aH
	jmp	?put_key@@YAXPAU_tagTTY@@I@Z		; put_key
$LN4@in_process:
	pop	esi

; 66   : 			break;
; 67   : 		case BACKSPACE:
; 68   : 			put_key(p_tty,'\b');

	mov	DWORD PTR _key$[esp-4], 8
	jmp	?put_key@@YAXPAU_tagTTY@@I@Z		; put_key
$LN3@in_process:

; 69   : 			break;
; 70   : 		case F1:
; 71   : 		case F2:
; 72   : 		case F3:
; 73   : 		case F4:
; 74   : 		case F5:
; 75   : 		case F6:
; 76   : 		case F7:
; 77   : 		case F8:
; 78   : 		case F9:
; 79   : 		case F10:
; 80   : 		case F11:
; 81   : 		case F12:
; 82   : 			if(key & FLAG_ALT_L){

	test	ecx, 8192				; 00002000H
	je	SHORT $LN2@in_process

; 83   : 				select_console(raw_code - F1);

	add	eax, -273				; fffffeefH
	push	eax
	call	?select_console@@YAXH@Z			; select_console
	add	esp, 4
$LN2@in_process:
	pop	esi

; 84   : 			}
; 85   : 		default:
; 86   : 			break;
; 87   : 		}
; 88   : 	}
; 89   : }

	ret	0
$LN37@in_process:
	DD	$LN5@in_process
	DD	$LN4@in_process
	DD	$LN3@in_process
	DD	$LN11@in_process
	DD	$LN8@in_process
	DD	$LN2@in_process
$LN34@in_process:
	DB	0
	DB	1
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	2
	DB	2
	DB	2
	DB	2
	DB	2
	DB	2
	DB	2
	DB	2
	DB	2
	DB	2
	DB	2
	DB	2
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	5
	DB	3
	DB	4
?in_process@@YAXPAU_tagTTY@@I@Z ENDP			; in_process
_TEXT	ENDS
PUBLIC	?tty_do_write@@YAXPAU_tagTTY@@@Z		; tty_do_write
; Function compile flags: /Ogtpy
;	COMDAT ?tty_do_write@@YAXPAU_tagTTY@@@Z
_TEXT	SEGMENT
_ch$2698 = 8						; size = 1
_p_tty$ = 8						; size = 4
?tty_do_write@@YAXPAU_tagTTY@@@Z PROC			; tty_do_write, COMDAT

; 105  : 	if(p_tty->inbuf_count){

	mov	eax, DWORD PTR _p_tty$[esp-4]
	push	esi
	mov	esi, DWORD PTR [eax+1032]
	test	esi, esi
	je	SHORT $LN2@tty_do_wri

; 106  : 		char ch = *(p_tty->p_inbuf_tial);

	mov	ecx, DWORD PTR [eax+1028]
	mov	dl, BYTE PTR [ecx]
	mov	BYTE PTR _ch$2698[esp], dl

; 107  : 		p_tty->p_inbuf_tial ++;

	add	ecx, 4

; 108  : 		if(p_tty->p_inbuf_tial == p_tty->in_buf+TTY_IN_BYTES){

	lea	edx, DWORD PTR [eax+1024]
	cmp	ecx, edx
	mov	DWORD PTR [eax+1028], ecx
	jne	SHORT $LN1@tty_do_wri

; 109  : 			p_tty->p_inbuf_tial = p_tty->in_buf;

	mov	DWORD PTR [eax+1028], eax
$LN1@tty_do_wri:

; 110  : 		}
; 111  : 		p_tty->inbuf_count --;
; 112  : 
; 113  : 		out_char(p_tty->p_console,ch);

	mov	ecx, DWORD PTR _ch$2698[esp]
	mov	edx, DWORD PTR [eax+1036]
	push	ecx
	add	esi, -1
	push	edx
	mov	DWORD PTR [eax+1032], esi
	call	?out_char@@YAXPAU_tagCONSOLE@@D@Z	; out_char
	add	esp, 8
$LN2@tty_do_wri:
	pop	esi

; 114  : 	}
; 115  : }

	ret	0
?tty_do_write@@YAXPAU_tagTTY@@@Z ENDP			; tty_do_write
_TEXT	ENDS
PUBLIC	?task_tty@@YAXXZ				; task_tty
EXTRN	?initial_keyboard@@YAXXZ:PROC			; initial_keyboard
; Function compile flags: /Ogtpy
;	COMDAT ?task_tty@@YAXXZ
_TEXT	SEGMENT
_ch$2899 = -4						; size = 1
?task_tty@@YAXXZ PROC					; task_tty, COMDAT

; 15   : {

	push	ecx
	push	esi

; 16   : 	TTY*	p_tty;
; 17   : 
; 18   : 	initial_keyboard();

	call	?initial_keyboard@@YAXXZ		; initial_keyboard

; 19   : 
; 20   : 	for(p_tty = TTY_FIRST;p_tty < TTY_END;p_tty ++){

	mov	esi, OFFSET ?tty_table@@3PAU_tagTTY@@A	; tty_table
	npad	4
$LL5@task_tty:

; 21   : 		init_tty(p_tty);

	push	esi
	mov	DWORD PTR [esi+1032], 0
	mov	DWORD PTR [esi+1028], esi
	mov	DWORD PTR [esi+1024], esi
	call	?init_screen@@YAXPAU_tagTTY@@@Z		; init_screen
	add	esi, 1040				; 00000410H
	add	esp, 4
	cmp	esi, OFFSET ?tty_table@@3PAU_tagTTY@@A+3120
	jb	SHORT $LL5@task_tty

; 22   : 	}
; 23   : 	p_tty = tty_table;
; 24   : 	select_console(0);

	push	OFFSET ?console_table@@3PAU_tagCONSOLE@@A ; console_table
	mov	DWORD PTR ?nr_current_console@@3IA, 0	; nr_current_console
	call	?flush@@YAXPAU_tagCONSOLE@@@Z		; flush
	add	esp, 4
$LN26@task_tty:
	mov	ecx, DWORD PTR ?nr_current_console@@3IA	; nr_current_console
	npad	6
$LL2@task_tty:

; 25   : 	while(1){
; 26   : 		tty_do_read(&tty_table[nr_current_console]);

	mov	eax, ecx
	imul	eax, 1040				; 00000410H
	mov	edx, ecx
	shl	edx, 4
	add	eax, OFFSET ?tty_table@@3PAU_tagTTY@@A	; tty_table
	add	edx, OFFSET ?console_table@@3PAU_tagCONSOLE@@A ; console_table
	cmp	DWORD PTR [eax+1036], edx
	jne	SHORT $LN14@task_tty
	push	eax
	call	?keyboard_read@@YAXPAU_tagTTY@@@Z	; keyboard_read
	mov	ecx, DWORD PTR ?nr_current_console@@3IA	; nr_current_console
	add	esp, 4
$LN14@task_tty:

; 27   : 		tty_do_write(&tty_table[nr_current_console]);

	mov	eax, ecx
	imul	eax, 1040				; 00000410H
	add	eax, OFFSET ?tty_table@@3PAU_tagTTY@@A	; tty_table
	mov	edx, DWORD PTR [eax+1032]
	test	edx, edx
	je	SHORT $LL2@task_tty
	mov	esi, DWORD PTR [eax+1028]
	mov	cl, BYTE PTR [esi]
	mov	BYTE PTR _ch$2899[esp+8], cl
	lea	ecx, DWORD PTR [esi+4]
	lea	esi, DWORD PTR [eax+1024]
	cmp	ecx, esi
	mov	DWORD PTR [eax+1028], ecx
	jne	SHORT $LN19@task_tty
	mov	DWORD PTR [eax+1028], eax
$LN19@task_tty:
	add	edx, -1
	mov	DWORD PTR [eax+1032], edx
	mov	edx, DWORD PTR _ch$2899[esp+8]
	mov	eax, DWORD PTR [eax+1036]
	push	edx
	push	eax
	call	?out_char@@YAXPAU_tagCONSOLE@@D@Z	; out_char
	add	esp, 8
	jmp	$LN26@task_tty
?task_tty@@YAXXZ ENDP					; task_tty
_TEXT	ENDS
END
