	j 	label1
	addiu 	$2,$0,0x18	#本句因延迟槽执行	
	addiu 	$1,$1,1		#本句被跳过，不执行
label1:	jr 	$2 
	addiu 	$1,$1,1		#本句因延迟槽执行
	addiu 	$1,$1,1		#本句被跳过，不执行
	jal 	label2
	addiu 	$3,$0,0x30	#本句因延迟槽执行
	addiu 	$1,$1,1		#本句被跳过，不执行
label2:	jalr 	$3
	addiu 	$1,$1,1		#本句因延迟槽执行
	addiu 	$1,$1,1		#本句被跳过，不执行
	beq	$0,$0,label3
	addiu 	$1,$1,1		#本句因延迟槽执行
	addiu 	$1,$1,1		#本句被跳过，不执行
label3:	bne	$1,$0,label4
	addiu 	$1,$1,1		#本句因延迟槽执行
	addiu 	$1,$1,1		#本句被跳过，不执行
label4:	bgez	$1,label5
	addiu 	$1,$1,1		#本句因延迟槽执行
	addiu 	$1,$1,1		#本句被跳过，不执行
label5:	sw 	$1,4($0)
	lw	$2,4($0)