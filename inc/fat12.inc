
;*******************************************************
;
;	Fat12.inc
;		FAT12 filesystem for 3-1/2 floppies
;
;*******************************************************

%ifndef __FAT12_INC_67343546FDCC56AAB872_INCLUDED__
%define __FAT12_INC_67343546FDCC56AAB872_INCLUDED__

bits	16

bpbOEM			db "My OS   "
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	DB 2
bpbRootEntries: 	DW 224
bpbTotalSectors: 	DW 2880
bpbMedia: 		DB 0xf0  ;; 0xF1
bpbSectorsPerFAT: 	DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 		DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0xa0a1a2a3
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "

datasector  dw 0x0000
cluster     dw 0x0000

absoluteSector db 0x00
absoluteHead   db 0x00
absoluteTrack  db 0x00

;************************************************;
; Convert CHS to LBA
; LBA = (cluster - 2) * sectors per cluster
;************************************************;

ClusterLBA:
          sub     ax, 0x0002                          ; zero base cluster number
          xor     cx, cx
          mov     cl, BYTE [bpbSectorsPerCluster]     ; convert byte to word
          mul     cx
          add     ax, WORD [datasector]               ; base data sector
          ret

;************************************************;
; Convert LBA to CHS
; AX=>LBA Address to convert
;
; absolute sector = (logical sector / sectors per track) + 1
; absolute head   = (logical sector / sectors per track) MOD number of heads
; absolute track  = logical sector / (sectors per track * number of heads)
;
;************************************************;

LBACHS:
          xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [bpbSectorsPerTrack]           ; calculate
          inc     dl                                  ; adjust for sector 0
          mov     BYTE [absoluteSector], dl
          xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [bpbHeadsPerCylinder]          ; calculate
          mov     BYTE [absoluteHead], dl
          mov     BYTE [absoluteTrack], al
          ret


;************************************************;
; Reads a series of sectors
; CX=>Number of sectors to read
; AX=>Starting sector
; ES:EBX=>Buffer to read to
;************************************************;

ReadSectors:
     .MAIN:
          mov     di, 0x0005                          ; five retries for error
     .SECTORLOOP:
          push    ax
          push    bx
          push    cx
          call    LBACHS                              ; convert starting sector to CHS
          mov     ah, 0x02                            ; BIOS read sector
          mov     al, 0x01                            ; read one sector
          mov     ch, BYTE [absoluteTrack]            ; track
          mov     cl, BYTE [absoluteSector]           ; sector
          mov     dh, BYTE [absoluteHead]             ; head
          mov     dl, BYTE [bsDriveNumber]            ; drive
          int     0x13                                ; invoke BIOS
          jnc     .SUCCESS                            ; test for read error
          xor     ax, ax                              ; BIOS reset disk
          int     0x13                                ; invoke BIOS
          dec     di                                  ; decrement error counter
          pop     cx
          pop     bx
          pop     ax
          jnz     .SECTORLOOP                         ; attempt to read again
          int     0x18
     .SUCCESS:
          pop     cx
          pop     bx
          pop     ax
          add     bx, WORD [bpbBytesPerSector]        ; queue next buffer
          inc     ax                                  ; queue next sector
          loop    .MAIN                               ; read next sector
          ret


%define ROOT_OFFSET 0x2e00
%define FAT_SEG 0x2c0
%define ROOT_SEG 0x2e0

;*******************************************
; LoadRoot ()
;	- Load Root Directory Table to 0x7e00
;*******************************************



LoadRoot:

	pusha							; store registers
	push	es

     ; compute size of root directory and store in "cx"
     
	xor     cx, cx						; clear registers
 	xor     dx, dx
	mov     ax, 32					; 32 byte directory entry
	mul     WORD [bpbRootEntries]				; total size of directory
	div     WORD [bpbBytesPerSector]			; sectors used by directory
	xchg    ax, cx						; move into AX

     ; compute location of root directory and store in "ax"
     
	mov     al, BYTE [bpbNumberOfFATs]			; number of FATs
	mul     WORD [bpbSectorsPerFAT]				; sectors used by FATs
	add     ax, WORD [bpbReservedSectors]
	mov     WORD [datasector], ax				; base of root directory
	add     WORD [datasector], cx

     ; read root directory into 0x7e00
 
 	push	word ROOT_SEG
	pop		es
	mov     bx, 0								; copy root dir
	call    ReadSectors							; read in directory table
	pop		es
	popa										; restore registers and return
	ret

;*******************************************
; LoadFAT ()
;	- Loads FAT table to 0x7c00
;
;	Parm/ ES:DI => Root Directory Table
;*******************************************

LoadFAT:

	pusha							; store registers
	push	es

     ; compute size of FAT and store in "cx"
     
	xor     ax, ax
	mov     al, BYTE [bpbNumberOfFATs]			; number of FATs
	mul     WORD [bpbSectorsPerFAT]				; sectors used by FATs
	mov     cx, ax

     ; compute location of FAT and store in "ax"

	mov     ax, WORD [bpbReservedSectors]

     ; read FAT into memory (Overwrite our bootloader at 0x7c00)

	push	word FAT_SEG
	pop		es
	xor		bx, bx
	call    ReadSectors
	pop		es
	popa							; restore registers and return
	ret
	
;*******************************************
; FindFile ()
;	- Search for filename in root table
;
; parm/ DS:SI => File name
; ret/ AX => File index number in directory table. -1 if error
;*******************************************

FindFile:

	push	cx						; store registers
	push	dx
	push	bx
	mov	bx, si						; copy filename for later

     ; browse root directory for binary image

	mov     cx, WORD [bpbRootEntries]			; load loop counter
	mov     di, ROOT_OFFSET						; locate first root entry at 1 MB mark
	cld							; clear direction flag

.LOOP:
	push    cx
	mov     cx, 11					; eleven character name. Image name is in SI
	mov	si, bx						; image name is in BX
 	push    di
     rep  cmpsb							; test for entry match
	pop     di
	je      .Found
	pop     cx
	add     di, 32					; queue next directory entry
	loop    .LOOP

.NotFound:
	pop	bx						; restore registers and return
	pop	dx
	pop	cx
	mov	ax, -1						; set error code
	ret

.Found:
	pop	ax						; return value into AX contains entry of file
	pop	bx						; restore registers and return
	pop	dx
	pop	cx
	ret

;*******************************************
; LoadFile ()
;	- Load file
; parm/ ES:SI => File to load
; parm/ EBX:BP => Buffer to load file to
; ret/ AX => -1 on error, 0 on success
; ret/ CX => number of sectors read
;*******************************************

LoadFile:

	xor	ecx, ecx		; size of file in sectors
	push	ecx

.FIND_FILE:

	push	bx			; BX=>BP points to buffer to write to; store it for later
	push	bp
	call	FindFile		; find our file. ES:SI contains our filename
	cmp	ax, -1
	jne	.LOAD_IMAGE_PRE
	pop	bp
	pop	bx
	pop	ecx
	mov	ax, -1
	ret

.LOAD_IMAGE_PRE:

	sub	edi, ROOT_OFFSET
	sub	eax, ROOT_OFFSET

	; get starting cluster

	push	word ROOT_SEG		;root segment loc
	pop	es
	mov	dx, WORD [es:di + 0x001A]; DI points to file entry in root directory table. Refrence the table...
	mov	WORD [cluster], dx	; file's first cluster
	pop	bx			; get location to write to so we dont screw up the stack
	pop	es
	push    bx			; store location for later again
	push	es
	call	LoadFAT

.LOAD_IMAGE:

	; load the cluster

	mov	ax, WORD [cluster]	; cluster to read
	pop	es			; bx:bp=es:bx
	pop	bx
	call	ClusterLBA
	xor	cx, cx
	mov     cl, BYTE [bpbSectorsPerCluster]
	call	ReadSectors
	pop	ecx
	inc	ecx			; add one more sector to counter
	push	ecx
	push	bx
	push	es
	mov	ax, FAT_SEG		;start reading from fat
	mov	es, ax
	xor	bx, bx

	; get next cluster

	mov     ax, WORD [cluster]	; identify current cluster
	mov     cx, ax			; copy current cluster
	mov     dx, ax
	shr     dx, 0x0001		; divide by two
	add     cx, dx			; sum for (3/2)

	mov	bx, 0			;location of fat in memory
	add	bx, cx
	mov	dx, WORD [es:bx]
	test	ax, 0x0001		; test for odd or even cluster
	jnz	.ODD_CLUSTER

.EVEN_CLUSTER:

	and	dx, 0000111111111111b	; take low 12 bits
	jmp	.DONE

.ODD_CLUSTER:

	shr	dx, 0x0004		; take high 12 bits

.DONE:

	mov	WORD [cluster], dx
	cmp	dx, 0x0ff0		; test for end of file marker
	jb	.LOAD_IMAGE

.SUCCESS:
	pop	es
	pop	bx
	pop	ecx
	xor	ax, ax
	ret

%endif		;__FAT12_INC_67343546FDCC56AAB872_INCLUDED__
