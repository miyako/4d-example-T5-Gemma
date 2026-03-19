var $event : Object
$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		var $homeFolder : 4D:C1709.Folder
		$homeFolder:=Folder:C1567(fk home folder:K87:24).folder(".CTranslate2")
		
		var $LLM : cs:C1710.LLM
		$LLM:=cs:C1710.LLM.new(\
			$homeFolder.folder("t5gemma-l-l-ul2-it"); \
			"t5gemma-l-l-ul2-it-ct2-int8"; \
			"keisuke-miyako/t5gemma-l-l-ul2-it-ct2-int8"; $homeFolder; \
			Current form window:C827; Formula:C1597(OnLLM))
		
		var $files : Collection
		$files:=Folder:C1567(fk resources folder:K87:11).files(fk ignore invisible:K87:22 | fk recursive:K87:7).query("extension == :1"; ".txt").orderBy("name")
		
		var $prompts : Object
		$prompts:={values: []; currentValue: Null:C1517; files: $files}
		$prompts.values:=$files.extract("fullName")
		$prompts.index:=$prompts.values.length#0 ? 0 : -1
		Form:C1466.prompts:=$prompts
		
		If ($prompts.index#-1)
			Form:C1466.prompt:=$prompts.files[$prompts.index].getText()
		End if 
		
		OBJECT SET VISIBLE:C603(*; "progress"; Not:C34($LLM.available))
		OBJECT SET VISIBLE:C603(*; "btn.@"; $LLM.available)
		
End case 