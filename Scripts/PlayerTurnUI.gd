extends Node
var container
var tipText
var answerTextBox
var timerRadial
var sendButton
var rightAnswerPanel
var wrongAnswerPanel
var timer = 0
var totalTimer = 60
var answerBox
var answerPanel
var revealedTipsPanel
var revealedTipsContainer
var usedTipsNumberText
var timerOn
var tabuleiro
var usedTips3: PoolIntArray
var usedTipsNumber = 0
var feedbackAnswerTime = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	container = get_node("/root/MainScene/Background/HintsPanel/GridContainer")
	tipText = get_node("/root/MainScene/Background/AnswerTipPanel/TipTextBox/Label")
	answerTextBox = get_node("/root/MainScene/Background/AnswerTipPanel/AnswerPanel/Answer")
	timerRadial = get_node("/root/MainScene/Background/ClockShadow/TextureProgress")
	sendButton= get_node("/root/MainScene/Background/AnswerTipPanel/SendButton")
	answerBox = get_node("/root/MainScene/Background/AnswerTipPanel/AnswerPanel/Answer")
	answerPanel = get_node("/root/MainScene/Background/AnswerTipPanel")
	rightAnswerPanel = get_node("/root/MainScene/RightAnswerPanel")
	wrongAnswerPanel = get_node("/root/MainScene/WrongAnswerPanel")
	revealedTipsPanel = get_node("/root/MainScene/Background/RevealedTipsPanel")
	revealedTipsContainer = get_node("/root/MainScene/Background/RevealedTipsPanel/ScrollContainer/VBoxContainer")
	tabuleiro = get_node("/root/MainScene/Tabuleiro")
	usedTipsNumberText = get_node("/root/MainScene/Background/UsedTipsBox/Label")
	usedTipsNumberText.text = ''
	
func revealTextBoxAnswer(on):
	answerPanel.visible = on
	container.visible = !on
	#answerTextBox.visible = on
	#sendButton.visible = on

func revealTimer(on):
	timerRadial.visible = on
	timerRadial.value = 0
	timerOn = on
	
#"usedTips":{"arrayValue":{"values":[{"integerValue":0}]}},	

func usedTipsNumberText():
	usedTipsNumberText.text = str(usedTipsNumber)+"/"+str(tabuleiro.cartaDestaque.dicas.size())
	
func blockTipsUsed():
	#BUSCAR DICAS JÁ UTILIZADAS
	usedTipsNumber = 0
	var usedTips = get_node("/root/MainScene/").roomData.usedTips.arrayValue.values
	var usedTips2 = usedTips
	usedTips3.resize(0)
	if usedTips2.size() > 0:
		for i in range(usedTips2.size()):
			usedTips3.append(usedTips2[i].integerValue)
			
	clearContainer()
	
	for c in container.get_children():
		var number = int(c.get_child(0).text)
		if number in usedTips3:
			c.disabled = true
			usedTipsNumber +=1
			addTipInContainer(tabuleiro.cartaDestaque.dicas[number])
	usedTipsNumberText()
	
func turnTipsButtons(on):
	for c in container.get_children():
		c.disabled = !on
	if on:
		blockTipsUsed()

func revealTip(tip):
	tipText.text = tip
	addTipInContainer(tip)
	usedTipsNumber+=1
	usedTipsNumberText()

func addTipInContainer(tiptext):
	var prefab = preload("res://Prefabs/RevealedTipPrefab.tscn")
	var tip = prefab.instance()
	revealedTipsContainer.add_child(tip)
	tip.get_child(0).text = tiptext
	
func clearContainer():
	for n in revealedTipsContainer.get_children():
		revealedTipsContainer.remove_child(n)
		n.queue_free()

func startClock():
	if timerOn:
		yield(get_tree().create_timer(1.0), "timeout")
		timer = timer+1
		print("TIMER: ",timer)
		timerRadial.value = timer
		if timer <= totalTimer:
			startClock()
		else:
			timeOver()

func timeOver():
	revealTextBoxAnswer(false)
	revealTimer(false)
	turnTipsButtons(false)
	timerOn = false
	timer = 0
	var answer = answerBox.text
	answerBox.text = ""
	print("ACABOU O TEMPO")
	get_node("/root/MainScene/").wrongAnswer()

func _on_SendButton_pressed() -> void:
	revealTextBoxAnswer(false)
	revealTimer(false)
	turnTipsButtons(false)
	timerOn = false
	timer = 0
	var answer = answerBox.text
	answerBox.text = ""
	get_node("/root/MainScene/").verifyAnswer(answer)

func rightAnswerPanel():
	rightAnswerPanel.visible = true
	yield(get_tree().create_timer(feedbackAnswerTime), "timeout")
	rightAnswerPanel.visible = false
		
func wrongAnswerPanel():
	wrongAnswerPanel.visible = true
	yield(get_tree().create_timer(feedbackAnswerTime), "timeout")
	wrongAnswerPanel.visible = false

func _on_RevealedTipsButton_pressed() -> void:
	revealedTipsPanel.visible = true

func _on_CloseButton_pressed() -> void:
	revealedTipsPanel.visible = false
