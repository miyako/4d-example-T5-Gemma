If (FORM Event:C1606.code=On Data Change:K2:15)
	
	var $prompts : Object
	$prompts:=Form:C1466.prompts
	Form:C1466.prompt:=$prompts.files[$prompts.index].getText()
	
End if 