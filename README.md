# 4d-example-T5-Gemma
T5 Gemma in CT2

```4d
var $OpenAI : cs.AIKit.OpenAI

var $customHeaders : Object
$customHeaders:={}

var $ChatCompletionsParameters : Object
$ChatCompletionsParameters:={}
$ChatCompletionsParameters.prompt:="translate English to French: The cat sat on the mat"

/*
	
	over-ride AI Kit behaviour
	
*/

var $template : Object
$template:={apply: Formula("<start_of_turn>user\n"+$1+"<end_of_turn>\n<start_of_turn>model\n")}
$ChatCompletionsParameters.prompt:=$template.apply($ChatCompletionsParameters.prompt)

$ChatCompletionsParameters.body:=Formula from string("$0:={messages: Null; prompt: This.prompt}")

$OpenAI:=cs.AIKit.OpenAI.new({customHeaders: $customHeaders})
$OpenAI.baseURL:="http://127.0.0.1:8080/v1"
var $ChatCompletionsResult : cs.AIKit.OpenAIChatCompletionsResult
$ChatCompletionsResult:=$OpenAI.chat.completions.create(Null; $ChatCompletionsParameters)

var $results : Collection
$results:=$ChatCompletionsResult.request.response.body.results

If ($results#Null)
	var $text : Text
	$text:=$results.at(0).text
	$text:=Replace string($text; "<end_of_turn>"; ""; *)
	ALERT($text)
End if 
```

<img width="480" height="175" alt="Screenshot 2026-03-19 at 11 47 44" src="https://github.com/user-attachments/assets/202ead67-9fbe-4c0f-ab15-1e7ba056bbf0" />

