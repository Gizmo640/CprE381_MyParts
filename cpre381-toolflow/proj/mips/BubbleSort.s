


bubbleSort:
        addiu  	$sp,$sp,-48
        sw      $fp,40($sp) #changed 
        add    	$fp,$sp, $zero #check
        sw      $4,16($fp)  # changed 
        add    	$2,$5,$zero # check
        sll     $2,$2,0
        sw      $2,24($fp)
        sw      $0,0($fp)
        b       .L2 	#changed 
        add 	$0, $0, $0 #nop #change 

.L6:
        sw      $0,4($fp)
        b       .L3 #change 
       	add 	$0, $0, $0		 #nop #change

.L5:
        lw      $2,4($fp)
        sll    	$2,$2,2
        lw      $3,16($fp) #changed 
        addu   	$2,$3,$2
        lw      $3,0($2)
        lw      $2,4($fp)
        addiu  	$2,$2,1
        sll    	$2,$2,2
        lw      $4,16($fp) #changed 
        addu   	$2,$4,$2
        lw      $2,0($2)
        slt     $2,$2,$3
        beq     $2,$0,.L4
        add 	$0, $0, $0#nop #change 

        lw      $2,4($fp)
        sll    	$2,$2,2
        lw      $3,16($fp)#changed 
        addu  	$2,$3,$2
        lw      $2,0($2)
        sw      $2,8($fp)
        lw      $2,4($fp)
        addiu  	$2,$2,1
        sll    	$2,$2,2
        lw      $3,16($fp)#changed 
        addu   	$3,$3,$2
        lw      $2,4($fp)
        sll    	$2,$2,2
        lw      $4,16($fp)#changed 
        addu  	 $2,$4,$2
        lw      $3,0($3)
        sw      $3,0($2)
        lw      $2,4($fp)
        addiu  	$2,$2,1
        sll    	$2,$2,2
        lw      $3,16($fp)#changed 
        addu   	$2,$3,$2
        lw      $3,8($fp)
        sw      $3,0($2)
.L4:
        lw      $2,4($fp)
        addiu   $2,$2,1
        sw      $2,4($fp)
.L3:
        lw      $3,24($fp)
        lw      $2,0($fp)
        subu    $2,$3,$2
       	addiu   $2,$2,-1
        lw      $3,4($fp)
        slt     $2,$3,$2
        bne     $2,$0,.L5
        add 	$0, $0, $0	#nop #change 

        lw      $2,0($fp)
        addiu   $2,$2,1
        sw      $2,0($fp)
.L2:
        lw      $2,24($fp)
        addiu   $2,$2,-1
        lw      $3,0($fp)
        slt     $2,$3,$2
        bne     $2,$0,.L6 
        add 	$0, $0, $0	#nop #change 

        add 	$0, $0, $0	#nop#change 
        add 	$0, $0, $0	#nop #change 
        add    $sp,$fp, $zero	#change 
        lw      $fp,40($sp)	#change 
        addiu  $sp,$sp,48
        jr      $31
        add 	$0, $0, $0	#nop #change 
        