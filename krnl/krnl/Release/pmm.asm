; Listing generated by Microsoft (R) Optimizing Compiler Version 14.00.50727.762 

	TITLE	i:\os\10\a\krnl\krnl\pmm.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB LIBCMT
INCLUDELIB OLDNAMES

_BSS	SEGMENT
__pmmgr_memory_size DD 01H DUP (?)
__pmmgr_used_blocks DD 01H DUP (?)
__pmmgr_max_blocks DD 01H DUP (?)
__pmmgr_memory_map DD 01H DUP (?)
_BSS	ENDS
PUBLIC	?mmap_set@@YAXH@Z				; mmap_set
; Function compile flags: /Ogtpy
; File i:\os\10\a\krnl\krnl\pmm.cpp
;	COMDAT ?mmap_set@@YAXH@Z
_TEXT	SEGMENT
_bit$ = 8						; size = 4
?mmap_set@@YAXH@Z PROC					; mmap_set, COMDAT

; 16   : 	_pmmgr_memory_map[bit / 32] |= (1 << (bit % 32));

	mov	ecx, DWORD PTR _bit$[esp-4]
	mov	eax, ecx
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	mov	edx, DWORD PTR __pmmgr_memory_map
	sar	eax, 5
	and	ecx, -2147483617			; 8000001fH
	lea	eax, DWORD PTR [edx+eax*4]
	jns	SHORT $LN3@mmap_set
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN3@mmap_set:
	mov	edx, 1
	shl	edx, cl
	or	DWORD PTR [eax], edx

; 17   : }

	ret	0
?mmap_set@@YAXH@Z ENDP					; mmap_set
_TEXT	ENDS
PUBLIC	?mmap_unset@@YAXH@Z				; mmap_unset
; Function compile flags: /Ogtpy
;	COMDAT ?mmap_unset@@YAXH@Z
_TEXT	SEGMENT
_bit$ = 8						; size = 4
?mmap_unset@@YAXH@Z PROC				; mmap_unset, COMDAT

; 21   : 	_pmmgr_memory_map[bit / 32] &= ~(1 << (bit % 32));

	mov	ecx, DWORD PTR _bit$[esp-4]
	mov	eax, ecx
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	mov	edx, DWORD PTR __pmmgr_memory_map
	sar	eax, 5
	and	ecx, -2147483617			; 8000001fH
	lea	eax, DWORD PTR [edx+eax*4]
	jns	SHORT $LN3@mmap_unset
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN3@mmap_unset:
	mov	edx, 1
	shl	edx, cl
	not	edx
	and	DWORD PTR [eax], edx

; 22   : }

	ret	0
?mmap_unset@@YAXH@Z ENDP				; mmap_unset
_TEXT	ENDS
PUBLIC	?mmap_test@@YA_NH@Z				; mmap_test
; Function compile flags: /Ogtpy
;	COMDAT ?mmap_test@@YA_NH@Z
_TEXT	SEGMENT
_bit$ = 8						; size = 4
?mmap_test@@YA_NH@Z PROC				; mmap_test, COMDAT

; 26   : 	return _pmmgr_memory_map[bit / 32] & (1 << (bit % 32));

	mov	eax, DWORD PTR _bit$[esp-4]
	mov	ecx, eax
	and	ecx, -2147483617			; 8000001fH
	push	esi
	jns	SHORT $LN3@mmap_test
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN3@mmap_test:
	cdq
	mov	esi, 1
	shl	esi, cl
	mov	ecx, DWORD PTR __pmmgr_memory_map
	and	edx, 31					; 0000001fH
	add	eax, edx
	sar	eax, 5
	test	esi, DWORD PTR [ecx+eax*4]
	pop	esi
	setne	al

; 27   : }

	ret	0
?mmap_test@@YA_NH@Z ENDP				; mmap_test
_TEXT	ENDS
PUBLIC	?pmmgr_init_region@@YAXII@Z			; pmmgr_init_region
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_init_region@@YAXII@Z
_TEXT	SEGMENT
_base$ = 8						; size = 4
_size$ = 12						; size = 4
?pmmgr_init_region@@YAXII@Z PROC			; pmmgr_init_region, COMDAT

; 92   : {

	push	esi

; 93   : 	int align = base / PMMGR_BLOCK_SIZE;

	mov	esi, DWORD PTR _base$[esp]
	push	edi

; 94   : 	int blocks = size / PMMGR_BLOCK_SIZE;

	mov	edi, DWORD PTR _size$[esp+4]
	shr	edi, 12					; 0000000cH
	shr	esi, 12					; 0000000cH

; 95   : 
; 96   : 	for(; blocks > 0; blocks --){

	test	edi, edi
	jle	SHORT $LN12@pmmgr_init
	push	ebx
	mov	ebx, DWORD PTR __pmmgr_memory_map
	npad	5
$LL3@pmmgr_init:

; 97   : 		mmap_unset(align ++);

	mov	eax, esi
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	sar	eax, 5
	mov	ecx, esi
	and	ecx, -2147483617			; 8000001fH
	lea	eax, DWORD PTR [ebx+eax*4]
	jns	SHORT $LN13@pmmgr_init
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN13@pmmgr_init:

; 98   : 		_pmmgr_used_blocks --;

	sub	DWORD PTR __pmmgr_used_blocks, 1
	mov	edx, 1
	shl	edx, cl
	sub	edi, 1
	add	esi, 1
	not	edx
	and	DWORD PTR [eax], edx
	test	edi, edi
	jg	SHORT $LL3@pmmgr_init

; 99   : 	}
; 100  : 
; 101  : 	mmap_set(0);

	or	DWORD PTR [ebx], 1
	pop	ebx
	pop	edi
	pop	esi

; 102  : }

	ret	0
$LN12@pmmgr_init:

; 99   : 	}
; 100  : 
; 101  : 	mmap_set(0);

	mov	eax, DWORD PTR __pmmgr_memory_map
	or	DWORD PTR [eax], 1
	pop	edi
	pop	esi

; 102  : }

	ret	0
?pmmgr_init_region@@YAXII@Z ENDP			; pmmgr_init_region
_TEXT	ENDS
PUBLIC	?pmmgr_deinit_region@@YAXII@Z			; pmmgr_deinit_region
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_deinit_region@@YAXII@Z
_TEXT	SEGMENT
_base$ = 8						; size = 4
_size$ = 12						; size = 4
?pmmgr_deinit_region@@YAXII@Z PROC			; pmmgr_deinit_region, COMDAT

; 105  : {

	push	esi

; 106  : 	int align = base / PMMGR_BLOCK_SIZE;

	mov	esi, DWORD PTR _base$[esp]
	push	edi

; 107  : 	int blocks = size / PMMGR_BLOCK_SIZE;

	mov	edi, DWORD PTR _size$[esp+4]
	shr	edi, 12					; 0000000cH
	shr	esi, 12					; 0000000cH

; 108  : 
; 109  : 	for(; blocks > 0 ; blocks --){

	test	edi, edi
	jle	SHORT $LN12@pmmgr_dein
	add	DWORD PTR __pmmgr_used_blocks, edi
	push	ebx
	mov	ebx, DWORD PTR __pmmgr_memory_map
$LL3@pmmgr_dein:

; 110  : 		mmap_set(align ++);

	mov	eax, esi
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	sar	eax, 5
	mov	ecx, esi
	and	ecx, -2147483617			; 8000001fH
	lea	eax, DWORD PTR [ebx+eax*4]
	jns	SHORT $LN13@pmmgr_dein
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN13@pmmgr_dein:
	mov	edx, 1
	shl	edx, cl
	sub	edi, 1
	add	esi, 1
	or	DWORD PTR [eax], edx
	test	edi, edi
	jg	SHORT $LL3@pmmgr_dein

; 111  : 		_pmmgr_used_blocks ++;
; 112  : 	}
; 113  : 	mmap_set (0);	//first block is always set. This insures allocs cant be 0

	or	DWORD PTR [ebx], 1
	pop	ebx
	pop	edi
	pop	esi

; 114  : }

	ret	0
$LN12@pmmgr_dein:

; 111  : 		_pmmgr_used_blocks ++;
; 112  : 	}
; 113  : 	mmap_set (0);	//first block is always set. This insures allocs cant be 0

	mov	eax, DWORD PTR __pmmgr_memory_map
	or	DWORD PTR [eax], 1
	pop	edi
	pop	esi

; 114  : }

	ret	0
?pmmgr_deinit_region@@YAXII@Z ENDP			; pmmgr_deinit_region
_TEXT	ENDS
PUBLIC	?pmmgr_free_block@@YAXPAX@Z			; pmmgr_free_block
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_free_block@@YAXPAX@Z
_TEXT	SEGMENT
_p$ = 8							; size = 4
?pmmgr_free_block@@YAXPAX@Z PROC			; pmmgr_free_block, COMDAT

; 137  : 	physical_addr addr = (physical_addr)p;
; 138  : 	int frame = addr / PMMGR_BLOCK_SIZE;

	mov	ecx, DWORD PTR _p$[esp-4]
	shr	ecx, 12					; 0000000cH

; 139  : 
; 140  : 	mmap_unset(frame);

	mov	eax, ecx
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	mov	edx, DWORD PTR __pmmgr_memory_map
	sar	eax, 5
	and	ecx, -2147483617			; 8000001fH
	lea	eax, DWORD PTR [edx+eax*4]
	jns	SHORT $LN5@pmmgr_free
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN5@pmmgr_free:

; 141  : 
; 142  : 	_pmmgr_used_blocks --;

	sub	DWORD PTR __pmmgr_used_blocks, 1
	mov	edx, 1
	shl	edx, cl
	not	edx
	and	DWORD PTR [eax], edx

; 143  : }

	ret	0
?pmmgr_free_block@@YAXPAX@Z ENDP			; pmmgr_free_block
_TEXT	ENDS
PUBLIC	?pmmgr_free_blocks@@YAXPAXI@Z			; pmmgr_free_blocks
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_free_blocks@@YAXPAXI@Z
_TEXT	SEGMENT
_p$ = 8							; size = 4
_size$ = 12						; size = 4
?pmmgr_free_blocks@@YAXPAXI@Z PROC			; pmmgr_free_blocks, COMDAT

; 165  : {

	push	ebp

; 166  : 	physical_addr addr = (physical_addr)p;
; 167  : 	int frame = addr / PMMGR_BLOCK_SIZE;
; 168  : 
; 169  : 	for (uint32_t i=0; i<size; i++)

	mov	ebp, DWORD PTR _size$[esp]
	push	esi
	mov	esi, DWORD PTR _p$[esp+4]
	shr	esi, 12					; 0000000cH
	test	ebp, ebp
	jbe	SHORT $LN10@pmmgr_free@2
	push	ebx
	mov	ebx, DWORD PTR __pmmgr_memory_map
	push	edi
	mov	edi, ebp
	npad	5
$LL3@pmmgr_free@2:

; 170  : 		mmap_unset (frame+i);

	mov	eax, esi
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	sar	eax, 5
	mov	ecx, esi
	and	ecx, -2147483617			; 8000001fH
	lea	eax, DWORD PTR [ebx+eax*4]
	jns	SHORT $LN11@pmmgr_free@2
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN11@pmmgr_free@2:
	mov	edx, 1
	shl	edx, cl
	add	esi, 1
	not	edx
	and	DWORD PTR [eax], edx
	sub	edi, 1
	jne	SHORT $LL3@pmmgr_free@2
	pop	edi
	pop	ebx
$LN10@pmmgr_free@2:

; 171  : 
; 172  : 	_pmmgr_used_blocks-=size;

	sub	DWORD PTR __pmmgr_used_blocks, ebp
	pop	esi
	pop	ebp

; 173  : }

	ret	0
?pmmgr_free_blocks@@YAXPAXI@Z ENDP			; pmmgr_free_blocks
_TEXT	ENDS
PUBLIC	?pmmgr_get_memory_size@@YAIXZ			; pmmgr_get_memory_size
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_get_memory_size@@YAIXZ
_TEXT	SEGMENT
?pmmgr_get_memory_size@@YAIXZ PROC			; pmmgr_get_memory_size, COMDAT

; 177  : 	return _pmmgr_memory_size;

	mov	eax, DWORD PTR __pmmgr_memory_size

; 178  : }

	ret	0
?pmmgr_get_memory_size@@YAIXZ ENDP			; pmmgr_get_memory_size
_TEXT	ENDS
PUBLIC	?pmmgr_get_block_count@@YAIXZ			; pmmgr_get_block_count
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_get_block_count@@YAIXZ
_TEXT	SEGMENT
?pmmgr_get_block_count@@YAIXZ PROC			; pmmgr_get_block_count, COMDAT

; 182  : 	return _pmmgr_max_blocks;

	mov	eax, DWORD PTR __pmmgr_max_blocks

; 183  : }

	ret	0
?pmmgr_get_block_count@@YAIXZ ENDP			; pmmgr_get_block_count
_TEXT	ENDS
PUBLIC	?pmmgr_get_use_block_count@@YAIXZ		; pmmgr_get_use_block_count
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_get_use_block_count@@YAIXZ
_TEXT	SEGMENT
?pmmgr_get_use_block_count@@YAIXZ PROC			; pmmgr_get_use_block_count, COMDAT

; 187  : 	return _pmmgr_used_blocks;

	mov	eax, DWORD PTR __pmmgr_used_blocks

; 188  : }

	ret	0
?pmmgr_get_use_block_count@@YAIXZ ENDP			; pmmgr_get_use_block_count
_TEXT	ENDS
PUBLIC	?pmmgr_get_free_block_count@@YAIXZ		; pmmgr_get_free_block_count
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_get_free_block_count@@YAIXZ
_TEXT	SEGMENT
?pmmgr_get_free_block_count@@YAIXZ PROC			; pmmgr_get_free_block_count, COMDAT

; 192  : 	return _pmmgr_max_blocks - _pmmgr_used_blocks;

	mov	eax, DWORD PTR __pmmgr_max_blocks
	sub	eax, DWORD PTR __pmmgr_used_blocks

; 193  : }

	ret	0
?pmmgr_get_free_block_count@@YAIXZ ENDP			; pmmgr_get_free_block_count
_TEXT	ENDS
PUBLIC	?pmmgr_get_block_size@@YAIXZ			; pmmgr_get_block_size
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_get_block_size@@YAIXZ
_TEXT	SEGMENT
?pmmgr_get_block_size@@YAIXZ PROC			; pmmgr_get_block_size, COMDAT

; 197  : 	return PMMGR_BLOCK_SIZE;

	mov	eax, 4096				; 00001000H

; 198  : }

	ret	0
?pmmgr_get_block_size@@YAIXZ ENDP			; pmmgr_get_block_size
_TEXT	ENDS
PUBLIC	?pmmgr_paging_enable@@YAX_N@Z			; pmmgr_paging_enable
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_paging_enable@@YAX_N@Z
_TEXT	SEGMENT
_b$ = 8							; size = 1
?pmmgr_paging_enable@@YAX_N@Z PROC			; pmmgr_paging_enable, COMDAT

; 201  : {

	push	ebp
	mov	ebp, esp

; 202  : 	_asm {
; 203  : 		mov	eax, cr0

	mov	eax, cr0

; 204  : 		cmp [b], 1

	cmp	BYTE PTR _b$[ebp], 1

; 205  : 		je	enable

	je	SHORT $enable$2732

; 206  : 		jmp disable

	jmp	SHORT $disable$2733
$enable$2732:

; 207  : enable:
; 208  : 		or eax, 0x80000000		//set bit 31

	or	eax, -2147483648			; 80000000H

; 209  : 		mov	cr0, eax

	mov	cr0, eax

; 210  : 		jmp done

	jmp	SHORT $done$2734
$disable$2733:

; 211  : disable:
; 212  : 		and eax, 0x7FFFFFFF		//clear bit 31

	and	eax, 2147483647				; 7fffffffH

; 213  : 		mov	cr0, eax

	mov	cr0, eax
$done$2734:

; 214  : done:
; 215  : 	}
; 216  : }

	pop	ebp
	ret	0
?pmmgr_paging_enable@@YAX_N@Z ENDP			; pmmgr_paging_enable
_TEXT	ENDS
PUBLIC	?pmmgr_is_paging@@YA_NXZ			; pmmgr_is_paging
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_is_paging@@YA_NXZ
_TEXT	SEGMENT
_res$ = -4						; size = 4
?pmmgr_is_paging@@YA_NXZ PROC				; pmmgr_is_paging, COMDAT

; 219  : {

	push	ecx

; 220  : 	uint32_t res=0;

	mov	DWORD PTR _res$[esp+4], 0

; 221  : 	_asm{
; 222  : 		mov	eax, cr0

	mov	eax, cr0

; 223  : 		mov	[res], eax

	mov	DWORD PTR _res$[esp+4], eax

; 224  : 	}
; 225  : 	return (res & 0x80000000) ? false : true;

	mov	eax, DWORD PTR _res$[esp+4]
	shr	eax, 31					; 0000001fH
	not	al
	and	al, 1

; 226  : }

	pop	ecx
	ret	0
?pmmgr_is_paging@@YA_NXZ ENDP				; pmmgr_is_paging
_TEXT	ENDS
PUBLIC	?pmmgr_load_PDBR@@YAXI@Z			; pmmgr_load_PDBR
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_load_PDBR@@YAXI@Z
_TEXT	SEGMENT
_addr$ = 8						; size = 4
?pmmgr_load_PDBR@@YAXI@Z PROC				; pmmgr_load_PDBR, COMDAT

; 230  : 	_asm {
; 231  : 		mov	eax, [addr]

	mov	eax, DWORD PTR _addr$[esp-4]

; 232  : 		mov	cr3, eax		// PDBR is cr3 register in i86

	mov	cr3, eax

; 233  : 	}
; 234  : }

	ret	0
?pmmgr_load_PDBR@@YAXI@Z ENDP				; pmmgr_load_PDBR
_TEXT	ENDS
PUBLIC	?pmmgr_get_PDBR@@YAIXZ				; pmmgr_get_PDBR
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_get_PDBR@@YAIXZ
_TEXT	SEGMENT
?pmmgr_get_PDBR@@YAIXZ PROC				; pmmgr_get_PDBR, COMDAT

; 238  : 	_asm{
; 239  : 		mov	eax, cr3

	mov	eax, cr3

; 240  : 		ret

	ret	0

; 241  : 	}
; 242  : }

	ret	0
?pmmgr_get_PDBR@@YAIXZ ENDP				; pmmgr_get_PDBR
_TEXT	ENDS
PUBLIC	?mmap_first_free@@YAHXZ				; mmap_first_free
; Function compile flags: /Ogtpy
;	COMDAT ?mmap_first_free@@YAHXZ
_TEXT	SEGMENT
?mmap_first_free@@YAHXZ PROC				; mmap_first_free, COMDAT

; 30   : {

	push	ebx
	push	esi
	push	edi

; 31   : 	//DbgPrintf("block count: %d.\n",pmmgr_get_block_count());
; 32   : 	//	find the first free bit
; 33   : 	for(uint32_t i = 0; i < pmmgr_get_block_count(); i ++ ){

	mov	edi, DWORD PTR __pmmgr_max_blocks
	xor	eax, eax
	test	edi, edi
	jbe	SHORT $LN6@mmap_first
	mov	esi, DWORD PTR __pmmgr_memory_map
$LL8@mmap_first:

; 34   : 		if(_pmmgr_memory_map[i] != 0xffffffff){

	mov	edx, DWORD PTR [esi+eax*4]
	cmp	edx, -1
	je	SHORT $LN7@mmap_first

; 35   : 			for(int j = 0; j<32 ; j++){

	xor	ecx, ecx
	npad	1
$LL4@mmap_first:

; 36   : 				int bit = i << j;

	mov	ebx, eax
	shl	ebx, cl

; 37   : 				if(!(_pmmgr_memory_map[i] & bit)){

	test	ebx, edx
	je	SHORT $LN15@mmap_first
	add	ecx, 1
	cmp	ecx, 32					; 00000020H
	jl	SHORT $LL4@mmap_first
$LN7@mmap_first:

; 31   : 	//DbgPrintf("block count: %d.\n",pmmgr_get_block_count());
; 32   : 	//	find the first free bit
; 33   : 	for(uint32_t i = 0; i < pmmgr_get_block_count(); i ++ ){

	add	eax, 1
	cmp	eax, edi
	jb	SHORT $LL8@mmap_first
$LN6@mmap_first:
	pop	edi
	pop	esi

; 39   : 				}
; 40   : 			}
; 41   : 		}
; 42   : 	}
; 43   : 	return -1;

	or	eax, -1
	pop	ebx

; 44   : }

	ret	0
$LN15@mmap_first:
	pop	edi

; 38   : 					return i*4*8 + j;

	shl	eax, 5
	pop	esi
	add	eax, ecx
	pop	ebx

; 44   : }

	ret	0
?mmap_first_free@@YAHXZ ENDP				; mmap_first_free
_TEXT	ENDS
PUBLIC	?mmap_first_free_s@@YAHI@Z			; mmap_first_free_s
; Function compile flags: /Ogtpy
;	COMDAT ?mmap_first_free_s@@YAHI@Z
_TEXT	SEGMENT
_i$2641 = -16						; size = 4
_j$2646 = -12						; size = 4
tv249 = -8						; size = 4
tv167 = -4						; size = 4
tv243 = 8						; size = 4
_size$ = 8						; size = 4
?mmap_first_free_s@@YAHI@Z PROC				; mmap_first_free_s, COMDAT

; 47   : {

	sub	esp, 16					; 00000010H
	push	ebp

; 48   : 	if (size==0)

	mov	ebp, DWORD PTR _size$[esp+16]
	xor	eax, eax
	cmp	ebp, eax
	jne	SHORT $LN15@mmap_first@2

; 49   : 		return -1;

	or	eax, -1
	pop	ebp

; 76   : }

	add	esp, 16					; 00000010H
	ret	0
$LN15@mmap_first@2:

; 50   : 
; 51   : 	if (size==1)

	cmp	ebp, 1
	jne	SHORT $LN14@mmap_first@2
	pop	ebp

; 76   : }

	add	esp, 16					; 00000010H

; 52   : 		return mmap_first_free ();

	jmp	?mmap_first_free@@YAHXZ			; mmap_first_free
$LN14@mmap_first@2:

; 53   : 
; 54   : 	for (uint32_t i=0; i<pmmgr_get_block_count(); i++)

	cmp	DWORD PTR __pmmgr_max_blocks, eax
	push	ebx
	push	esi
	push	edi
	mov	DWORD PTR _i$2641[esp+32], eax
	jbe	$LN31@mmap_first@2
	mov	DWORD PTR tv243[esp+28], eax
	npad	5
$LL33@mmap_first@2:

; 55   : 		if (_pmmgr_memory_map[i] != 0xffffffff)

	mov	ecx, DWORD PTR __pmmgr_memory_map
	mov	edx, DWORD PTR [ecx+eax*4]
	cmp	edx, -1
	mov	DWORD PTR tv167[esp+32], edx
	je	$LN12@mmap_first@2

; 56   : 			for (int j=0; j<32; j++) {	// test each bit in the dword

	xor	ecx, ecx
	mov	DWORD PTR _j$2646[esp+32], ecx
	npad	4
$LL32@mmap_first@2:

; 57   : 
; 58   : 				int bit = 1<<j;

	mov	eax, 1
	shl	eax, cl

; 59   : 				if (! (_pmmgr_memory_map[i] & bit) ) {

	test	edx, eax
	jne	SHORT $LN8@mmap_first@2
	mov	edx, DWORD PTR tv243[esp+28]

; 60   : 
; 61   : 					int startingBit = i*32;
; 62   : 					startingBit+=bit;		//get the free bit in the dword at index i
; 63   : 
; 64   : 					uint32_t free=0; //loop through each bit to see if its enough space

	xor	ebx, ebx
	lea	esi, DWORD PTR [edx+eax]

; 65   : 					for (uint32_t count=0; count<=size;count++) {

	xor	edi, edi
$LL29@mmap_first@2:

; 66   : 
; 67   : 						if (! mmap_test (startingBit+count) )

	mov	ecx, esi
	and	ecx, -2147483617			; 8000001fH
	jns	SHORT $LN38@mmap_first@2
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN38@mmap_first@2:
	mov	eax, 1
	shl	eax, cl
	mov	ecx, DWORD PTR __pmmgr_memory_map
	mov	DWORD PTR tv249[esp+32], eax
	mov	eax, esi
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	mov	edx, DWORD PTR tv249[esp+32]
	sar	eax, 5
	test	edx, DWORD PTR [ecx+eax*4]
	jne	SHORT $LN30@mmap_first@2

; 68   : 							free++;	// this bit is clear (free frame)

	add	ebx, 1
$LN30@mmap_first@2:

; 69   : 
; 70   : 						if (free==size)

	cmp	ebx, ebp
	je	SHORT $LN25@mmap_first@2
	add	edi, 1
	add	esi, 1
	cmp	edi, ebp
	jbe	SHORT $LL29@mmap_first@2
	mov	ecx, DWORD PTR _j$2646[esp+32]
	mov	edx, DWORD PTR tv167[esp+32]
$LN8@mmap_first@2:
	add	ecx, 1
	cmp	ecx, 32					; 00000020H
	mov	DWORD PTR _j$2646[esp+32], ecx
	jl	SHORT $LL32@mmap_first@2

; 56   : 			for (int j=0; j<32; j++) {	// test each bit in the dword

	mov	eax, DWORD PTR _i$2641[esp+32]
$LN12@mmap_first@2:

; 53   : 
; 54   : 	for (uint32_t i=0; i<pmmgr_get_block_count(); i++)

	add	DWORD PTR tv243[esp+28], 32		; 00000020H
	add	eax, 1
	cmp	eax, DWORD PTR __pmmgr_max_blocks
	mov	DWORD PTR _i$2641[esp+32], eax
	jb	$LL33@mmap_first@2
$LN31@mmap_first@2:
	pop	edi
	pop	esi
	pop	ebx

; 72   : 					}
; 73   : 				}
; 74   : 			}
; 75   : 	return -1;

	or	eax, -1
	pop	ebp

; 76   : }

	add	esp, 16					; 00000010H
	ret	0
$LN25@mmap_first@2:

; 71   : 							return i*4*8+j; //free count==size needed; return index

	mov	eax, DWORD PTR _i$2641[esp+32]
	pop	edi
	pop	esi
	shl	eax, 5
	add	eax, DWORD PTR _j$2646[esp+24]
	pop	ebx
	pop	ebp

; 76   : }

	add	esp, 16					; 00000010H
	ret	0
?mmap_first_free_s@@YAHI@Z ENDP				; mmap_first_free_s
_TEXT	ENDS
PUBLIC	?pmmgr_init@@YAXII@Z				; pmmgr_init
EXTRN	?memset@@YAPAXPAXDI@Z:PROC			; memset
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_init@@YAXII@Z
_TEXT	SEGMENT
_mem_size$ = 8						; size = 4
_bitmap$ = 12						; size = 4
?pmmgr_init@@YAXII@Z PROC				; pmmgr_init, COMDAT

; 81   : 	_pmmgr_memory_size	= mem_size;

	mov	eax, DWORD PTR _mem_size$[esp-4]

; 82   : 	_pmmgr_memory_map	= (uint32_t*) bitmap;

	mov	ecx, DWORD PTR _bitmap$[esp-4]
	mov	DWORD PTR __pmmgr_memory_size, eax

; 83   : 	_pmmgr_max_blocks	= (pmmgr_get_memory_size() * 1024) / PMMGR_BLOCK_SIZE;

	shl	eax, 10					; 0000000aH
	shr	eax, 12					; 0000000cH
	mov	DWORD PTR __pmmgr_max_blocks, eax

; 84   : 	//DbgPrintf("init mem size %d block count: %d.\n",_pmmgr_memory_size,_pmmgr_max_blocks);
; 85   : 	_pmmgr_used_blocks	= pmmgr_get_block_count();

	mov	DWORD PTR __pmmgr_used_blocks, eax

; 86   : 
; 87   : 	//	by default, all of memory is in use
; 88   : 	memset(_pmmgr_memory_map, 0xf,pmmgr_get_block_count() / PMMGR_BLOCKS_PER_BYTE);

	shr	eax, 3
	push	eax
	push	15					; 0000000fH
	push	ecx
	mov	DWORD PTR __pmmgr_memory_map, ecx
	call	?memset@@YAPAXPAXDI@Z			; memset
	add	esp, 12					; 0000000cH

; 89   : }

	ret	0
?pmmgr_init@@YAXII@Z ENDP				; pmmgr_init
_TEXT	ENDS
PUBLIC	?pmmgr_alloc_block@@YAPAXXZ			; pmmgr_alloc_block
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_alloc_block@@YAPAXXZ
_TEXT	SEGMENT
?pmmgr_alloc_block@@YAPAXXZ PROC			; pmmgr_alloc_block, COMDAT

; 118  : 	if(pmmgr_get_free_block_count() <= 0){

	mov	eax, DWORD PTR __pmmgr_max_blocks
	sub	eax, DWORD PTR __pmmgr_used_blocks
	jne	SHORT $LN2@pmmgr_allo

; 131  : 
; 132  : 	return (void*)addr;
; 133  : }

	ret	0
$LN2@pmmgr_allo:
	push	esi

; 119  : 		return 0;			//	out of memory
; 120  : 	}
; 121  : 	int frame = mmap_first_free();

	call	?mmap_first_free@@YAHXZ			; mmap_first_free
	mov	esi, eax

; 122  : 
; 123  : 	if(frame == -1){

	cmp	esi, -1
	jne	SHORT $LN1@pmmgr_allo

; 124  : 		return 0;			//	out of memory

	xor	eax, eax
	pop	esi

; 131  : 
; 132  : 	return (void*)addr;
; 133  : }

	ret	0
$LN1@pmmgr_allo:

; 125  : 	}
; 126  : 
; 127  : 	mmap_set(frame);

	mov	ecx, DWORD PTR __pmmgr_memory_map
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	sar	eax, 5
	lea	eax, DWORD PTR [ecx+eax*4]
	mov	ecx, esi
	and	ecx, -2147483617			; 8000001fH
	jns	SHORT $LN10@pmmgr_allo
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN10@pmmgr_allo:

; 128  : 
; 129  : 	physical_addr addr = frame * PMMGR_BLOCK_SIZE;
; 130  : 	_pmmgr_used_blocks ++;

	add	DWORD PTR __pmmgr_used_blocks, 1
	mov	edx, 1
	shl	edx, cl
	or	DWORD PTR [eax], edx
	mov	eax, esi
	shl	eax, 12					; 0000000cH
	pop	esi

; 131  : 
; 132  : 	return (void*)addr;
; 133  : }

	ret	0
?pmmgr_alloc_block@@YAPAXXZ ENDP			; pmmgr_alloc_block
_TEXT	ENDS
PUBLIC	?pmmgr_alloc_blocks@@YAPAXI@Z			; pmmgr_alloc_blocks
; Function compile flags: /Ogtpy
;	COMDAT ?pmmgr_alloc_blocks@@YAPAXI@Z
_TEXT	SEGMENT
_frame$ = 8						; size = 4
_size$ = 8						; size = 4
?pmmgr_alloc_blocks@@YAPAXI@Z PROC			; pmmgr_alloc_blocks, COMDAT

; 147  : 	if (pmmgr_get_free_block_count() <= size)

	mov	eax, DWORD PTR __pmmgr_max_blocks
	sub	eax, DWORD PTR __pmmgr_used_blocks
	push	ebp
	mov	ebp, DWORD PTR _size$[esp]
	cmp	eax, ebp
	ja	SHORT $LN5@pmmgr_allo@2
$LN15@pmmgr_allo@2:

; 148  : 		return 0;	//not enough space

	xor	eax, eax
	pop	ebp

; 160  : 
; 161  : 	return (void*)addr;
; 162  : }

	ret	0
$LN5@pmmgr_allo@2:

; 149  : 
; 150  : 	int frame = mmap_first_free_s (size);

	push	ebp
	call	?mmap_first_free_s@@YAHI@Z		; mmap_first_free_s
	add	esp, 4

; 151  : 
; 152  : 	if (frame == -1)

	cmp	eax, -1
	mov	DWORD PTR _frame$[esp], eax

; 153  : 		return 0;	//not enough space

	je	SHORT $LN15@pmmgr_allo@2

; 154  : 
; 155  : 	for (uint32_t i=0; i<size; i++)

	test	ebp, ebp
	jbe	SHORT $LN1@pmmgr_allo@2
	push	ebx
	mov	ebx, DWORD PTR __pmmgr_memory_map
	push	esi
	push	edi
	mov	esi, eax
	mov	edi, ebp
	npad	5
$LL3@pmmgr_allo@2:

; 156  : 		mmap_set(frame+i);

	mov	eax, esi
	cdq
	and	edx, 31					; 0000001fH
	add	eax, edx
	sar	eax, 5
	mov	ecx, esi
	and	ecx, -2147483617			; 8000001fH
	lea	eax, DWORD PTR [ebx+eax*4]
	jns	SHORT $LN14@pmmgr_allo@2
	dec	ecx
	or	ecx, -32				; ffffffe0H
	inc	ecx
$LN14@pmmgr_allo@2:
	mov	edx, 1
	shl	edx, cl
	add	esi, 1
	or	DWORD PTR [eax], edx
	sub	edi, 1
	jne	SHORT $LL3@pmmgr_allo@2
	mov	eax, DWORD PTR _frame$[esp+12]
	pop	edi
	pop	esi
	pop	ebx
$LN1@pmmgr_allo@2:

; 157  : 
; 158  : 	physical_addr addr = frame * PMMGR_BLOCK_SIZE;
; 159  : 	_pmmgr_used_blocks+=size;

	add	DWORD PTR __pmmgr_used_blocks, ebp
	shl	eax, 12					; 0000000cH
	pop	ebp

; 160  : 
; 161  : 	return (void*)addr;
; 162  : }

	ret	0
?pmmgr_alloc_blocks@@YAPAXI@Z ENDP			; pmmgr_alloc_blocks
_TEXT	ENDS
END
