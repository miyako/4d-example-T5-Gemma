property text : Text
property reasoning_content : Text
property tool_calls : Collection

Class constructor
	
Function response($ChatCompletionsResult : cs:C1710.AIKit.OpenAIChatCompletionsResult)
	
	If (Form:C1466=Null:C1517)
		return 
	End if 
	
	If ($ChatCompletionsResult.errors#Null:C1517) && ($ChatCompletionsResult.errors.length#0)
		Form:C1466.error:=$ChatCompletionsResult.errors.extract("message").join("\r")
		return 
	End if 
	
	If ($ChatCompletionsResult.success)
		OBJECT SET ENABLED:C1123(*; "btn.@"; False:C215)
		If ($ChatCompletionsResult.terminated)
			//complete
			OBJECT SET ENABLED:C1123(*; "btn.@"; True:C214)
		Else 
			//stream
			var $results : Collection
			$results:=$ChatCompletionsResult["data"].results
			If ($results#Null:C1517)
				var $result : Object
				var $text : Text
				For each ($result; $results)
					$text:=Replace string:C233($result.delta; "<end_of_turn>"; ""; *)
					Form:C1466.text+=$text
				End for each 
			End if 
		End if 
	End if 
	
Function demo($instruction : Text)
	
	Form:C1466.error:=""
	
	var $OpenAI : cs:C1710.AIKit.OpenAI
	
	var $customHeaders : Object
	$customHeaders:={}
	
	var $ChatCompletionsParameters : Object
	$ChatCompletionsParameters:={}
	$ChatCompletionsParameters.prompt:=$instruction+Form:C1466.prompt
	$ChatCompletionsParameters.formula:=Form:C1466.response
	$ChatCompletionsParameters.stream:=True:C214
	$ChatCompletionsParameters.max_decoding_length:=32000
	
/*
	
over-ride AI Kit behaviour
	
*/
	
	var $template : Object
	$template:={apply: Formula:C1597("<start_of_turn>user\n"+$1+"<end_of_turn>\n<start_of_turn>model\n")}
	$ChatCompletionsParameters.prompt:=$template.apply($ChatCompletionsParameters.prompt)
	
	$ChatCompletionsParameters.body:=Formula:C1597(body)
	
	Form:C1466.text:=""
	
	$OpenAI:=cs:C1710.AIKit.OpenAI.new({customHeaders: $customHeaders})
	$OpenAI.baseURL:="http://127.0.0.1:8080/v1"
	$OpenAI.chat.completions.create(Null:C1517; $ChatCompletionsParameters)