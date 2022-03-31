extends Node
var container
var tipText
var answerTextBox
var timerRadial
var sendButton
var timer = 0
var totalTimer = 60
var answerBox
var timerOn
var usedTips3 = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	container = get_node("/root/MainScene/Background/HintsPanel/GridContainer")
	tipText = get_node("/root/MainScene/Background/TipText")
	answerTextBox = get_node("/root/MainScene/Background/AnswerPanel")
	timerRadial = get_node("/root/MainScene/Background/TextureProgress")
	sendButton= get_node("/root/MainScene/Background/Button")
	answerBox = get_node("/root/MainScene/Background/AnswerPanel/Answer")
	
func revealTextBoxAnswer(on):
	answerTextBox.visible = on
	sendButton.visible = on

func revealTimer(on):
	timerRadial.visible = on
	timerRadial.value = 0
	timerOn = on
	
#"usedTips":{"arrayValue":{"values":[{"integerValue":0}]}},	

func turnTipsButtons(on):
	#BUSCAR DICAS JÁ UTILIZADAS
	var usedTips = get_node("/root/MainScene/").roomData.usedTips.arrayValue.values
	#print('usedTips ',usedTips)
	var usedTips2 = usedTips
	#print('usedTips2 ',usedTips2,' size ', usedTips2.size())
	usedTips3.clear()
	if usedTips2.size() > 0:
		for i in range(usedTips2.size()):
			usedTips3.append(usedTips2[i].integerValue)
			
	#print('usedTips3 ',usedTips3)
	
	for c in container.get_children():
		c.disabled = !on
	
	#var childs = container.get_children()
	for c in container.get_children():
		var number = int(c.text)
		if number in usedTips3:
			#TA FUNCIONANDO PQ NAO DESATIVA?
			print("DESATIVOU")
			c.disabled = true

func revealTip(tip):
	tipText.text = tip
	
func startClock():
	if timerOn:
		#print(timer)
		yield(get_tree().create_timer(1.0), "timeout")
		timer = timer+1
		timerRadial.value = timer
		if timer <= totalTimer:
			startClock()
		else:
			print("ACABOU O TEMPO")
			get_node("/root/MainScene/").wrongAnswer()
	
func _on_Button_Send_pressed() -> void:
	revealTextBoxAnswer(false)
	revealTimer(false)
	turnTipsButtons(false)
	timerOn = false
	timer = 0
	var answer = answerBox.text
	answerBox.text = ""
	get_node("/root/MainScene/").verifyAnswer(answer)
