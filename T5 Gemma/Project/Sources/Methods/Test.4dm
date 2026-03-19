//%attributes = {"invisible":true}
var $OpenAI : cs:C1710.AIKit.OpenAI

var $customHeaders : Object
$customHeaders:={}

var $ChatCompletionsParameters : Object
$ChatCompletionsParameters:={}
$ChatCompletionsParameters.prompt:="translate English to French: The cat sat on the mat"

/*

over-ride AI Kit behaviour

*/

var $template : Object
$template:={apply: Formula:C1597("<start_of_turn>user\n"+$1+"<end_of_turn>\n<start_of_turn>model\n")}
$ChatCompletionsParameters.prompt:=$template.apply($ChatCompletionsParameters.prompt)

$ChatCompletionsParameters.body:=Formula from string:C1601("$0:={messages: Null; prompt: This.prompt}")

$OpenAI:=cs:C1710.AIKit.OpenAI.new({customHeaders: $customHeaders})
$OpenAI.baseURL:="http://127.0.0.1:8080/v1"
var $ChatCompletionsResult : cs:C1710.AIKit.OpenAIChatCompletionsResult
$ChatCompletionsResult:=$OpenAI.chat.completions.create(Null:C1517; $ChatCompletionsParameters)

var $results : Collection
$results:=$ChatCompletionsResult.request.response.body.results

If ($results#Null:C1517)
	var $text : Text
	$text:=$results.at(0).text
	$text:=Replace string:C233($text; "<end_of_turn>"; ""; *)
	ALERT:C41($text)
End if 
