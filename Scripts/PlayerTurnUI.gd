extends Node

signal sliderUpdate(character, score)

var container
var tipText
var answerTextBox
var timerRadial
var timerRadialWaiting
var bgWaiting
var tipsWaiting
var activePlayerName
var sendButton
var rightAnswerPanel
var wrongAnswerPanel
var timeOverPanel
var timer = 0
var totalTimer = 60
var answerBox
var answerPanel
var revealedTipsPanel
var revealedTipsContainer
var usedTipsNumberText
var avatarInClock
var scorePanel
var timerOn
var tabuleiro
var usedTips3: PoolIntArray
var usedTipsNumber = 0
var feedbackAnswerTime = 4
var players_sorted = []
var avatars_sorted = []
var scores_sorted = []
var player_score = {}
var previousPlayer = 'nulo'
var placeholderLineEdit = "Digite a resposta aqui"
var activePlayer
var reset = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	container = get_node("/root/MainScene/Background/HintsPanel/GridContainer")
	tipText = get_node("/root/MainScene/Background/AnswerTipPanel/TipTextBox/Label")
	answerTextBox = get_node("/root/MainScene/Background/AnswerTipPanel/AnswerPanel/Answer")
	timerRadial = get_node("/root/MainScene/Background/ClockShadow/TextureProgress")
	timerRadialWaiting = get_node("/root/MainScene/Background/ClockPlayerWaiting")
	bgWaiting = get_node("/root/MainScene/Background/BgPlayerWaiting")
	tipsWaiting = get_node("/root/MainScene/Background/TipsForWaitingPlayer")
	activePlayerName = get_node("/root/MainScene/Background/ClockPlayerWaiting/BoxName/NameLabel")
	sendButton= get_node("/root/MainScene/Background/AnswerTipPanel/SendButton")
	answerBox = get_node("/root/MainScene/Background/AnswerTipPanel/AnswerPanel/Answer")
	answerPanel = get_node("/root/MainScene/Background/AnswerTipPanel")
	rightAnswerPanel = get_node("/root/MainScene/RightAnswerPanel")
	wrongAnswerPanel = get_node("/root/MainScene/WrongAnswerPanel")
	timeOverPanel = get_node("/root/MainScene/TimeOverPanel")
	revealedTipsPanel = get_node("/root/MainScene/Background/RevealedTipsPanel")
	revealedTipsContainer = get_node("/root/MainScene/Background/RevealedTipsPanel/ScrollContainer/VBoxContainer")
	tabuleiro = get_node("/root/MainScene/Tabuleiro")
	usedTipsNumberText = get_node("/root/MainScene/Background/UsedTipsBox/Label")
	usedTipsNumberText.text = ''
	avatarInClock = get_node("/root/MainScene/Background/ClockPlayerWaiting/ActivePlayerWait")
	scorePanel = get_node("/root/MainScene/Background/ScoresPanel")

func revealTextBoxAnswer(on):
	answerPanel.visible = on
	container.visible = !on
	#answerTextBox.visible = on
	#sendButton.visible = on
	
func revealWaitingUI(on):
	bgWaiting.visible = on
	timerRadialWaiting.visible = on
	tipsWaiting.visible = on
	if on:
		activePlayer = get_node("/root/MainScene/").roomData.activePlayer.stringValue
		var index = get_node("/root/MainScene/").playersNames.find(activePlayer)
		var avatar = get_node("/root/MainScene/").avatarsNames[index]
		var tipNumber= get_node("/root/MainScene/").roomData.activeTip.integerValue
		var tipText = get_node("/root/MainScene/Tabuleiro").cartaDestaque.dicas[int(tipNumber)]
		#print(get_node("/root/MainScene/Tabuleiro").cartaDestaque.dicas[0])
		
		if int(tipNumber) != -1:
			tipsWaiting.get_child(0).text = tipText
			
		if previousPlayer != activePlayer:
			reset = true #VERIFICAR DE OUTRA FORMA PARA 2 PLAYERS
			
		if reset:
			previousPlayer = activePlayer
			timerRadialWaiting.get_child(0).value = 0
			tipsWaiting.get_child(0).text = ''
			reset = false
			
		activePlayerName.text = activePlayer
		avatarInClock.texture = UiManager.littleImageIcon(avatar)
		timerRadialWaiting.get_child(0).value += 2
	else:
		reset = true
	
func revealTimer(on):
	timerRadial.visible = on
	timerRadial.value = 0
	timerRadial.get_parent().visible = on
	timerOn = on
	#if !on:
	#var activePlayer = get_node("/root/MainScene/").roomData.activePlayer.stringValue
	#var index = get_node("/root/MainScene/").playersNames.find(activePlayer)
	#var avatar = get_node("/root/MainScene/").avatarsNames[index]
	#if activePlayer == Firebase.user_email:
		#avatarInClock.texture = UiManager.littleImageIcon("Active_Player")
	#else:
		#avatarInClock.texture = UiManager.littleImageIcon(avatar)
	#else:
	#avatarInClock.texture = UiManager.littleImageIcon("Active_Player")
	
#"usedTips":{"arrayValue":{"values":[{"integerValue":0}]}},	

func usedTipsNumberText():
	usedTipsNumberText.text = str(usedTipsNumber)+"/"+str(tabuleiro.cartaDestaque.dicas.size())
	if usedTipsNumber == 0:
		tipsWaiting.get_child(0).text = ''
	#elif usedTipsNumber > tabuleiro.cartaDestaque.dicas.size():
		#NÂO MOSTRAR MAIS BOTOES DE DICAS E APENAS ESPERAR A RESPOSTA+
		#print("Acabaram as dicas!")
		#get_node("/root/MainScene/").revealAnswerPanelWithNoTips()
	
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
			addTipInContainer(tabuleiro.cartaDestaque.dicas[number-1])
	
	if usedTipsNumber >= tabuleiro.cartaDestaque.dicas.size():
		if Firebase.user_email != activePlayer:
			#NÂO MOSTRAR MAIS BOTOES DE DICAS E APENAS ESPERAR A RESPOSTA+
			print("Acabaram as dicas!")
			get_node("/root/MainScene/").revealAnswerPanelWithNoTips()
		
	usedTipsNumberText()
	
func turnTipsButtons(on):
	for c in container.get_children():
		c.disabled = !on
	container.visible = on
	if on:
		blockTipsUsed()

func revealTip(tip):
	tipText.text = tip
	addTipInContainer(tip)
	usedTipsNumber+=1
	usedTipsNumberText()

func addTipInContainer(tiptext):
	if tiptext != '':
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
		#print("TIMER: ",timer)
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
	get_node("/root/MainScene/").timeOver()

func _on_SendButton_pressed() -> void:
	revealTextBoxAnswer(false)
	revealTimer(false)
	turnTipsButtons(false)
	timerOn = false
	timer = 0
	var answer = answerBox.text
	answerBox.text = ""
	get_node("/root/MainScene/").verifyAnswer(answer)

func rightAnswerPanel(avatar, score):
	get_node("/root/MainScene/RightAnswerPanel/Box/AvatarImage").texture = UiManager.imageIconAvatar(avatar)
	get_node("/root/MainScene/RightAnswerPanel/Box/ScoreBox/Label").text = str(score)
	rightAnswerPanel.visible = true
	yield(get_tree().create_timer(feedbackAnswerTime), "timeout")
	rightAnswerPanel.visible = false
		
func wrongAnswerPanel():
	wrongAnswerPanel.visible = true
	yield(get_tree().create_timer(feedbackAnswerTime), "timeout")
	wrongAnswerPanel.visible = false

func timeOverPanel():
	timeOverPanel.visible = true
	yield(get_tree().create_timer(feedbackAnswerTime), "timeout")
	timeOverPanel.visible = false

func _on_RevealedTipsButton_pressed() -> void:
	revealedTipsPanel.visible = true

func _on_CloseButton_pressed() -> void:
	revealedTipsPanel.visible = false
	
#Revificar se Enter foi pressionado
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		_on_SendButton_pressed()

func scoresPanelReveal(on):
	scorePanel.visible = on
	if on:
		scorePanelInfo()
	
func showResults(data):
	get_node("/root/MainScene/ResultsScreen").visible = true
	var players =[]
	var avatars =[]
	var scores =[]
	
	for i in range(data.players.arrayValue.values.size()):
		players.append(data.players.arrayValue.values[i].stringValue)
		avatars.append(data.avatars.arrayValue.values[i].stringValue)
		scores.append(data.score.arrayValue.values[i].integerValue)
	
	players_sorted = []
	avatars_sorted = []
	scores_sorted = []
	player_score = {}
	
	if players.size() == scores.size():
		var i = 0
		for element in players:
			player_score[element] = int(scores[i])
			i += 1
			
	print("DICTIONARY; ", player_score)
	
	for j in range(players.size()):
		var maxV = player_score.values().max()
		scores_sorted.append(maxV)
		print("maxV; ", maxV)
		for key in player_score:
			var value = player_score[key]
			if value == maxV:
				players_sorted.append(key)
				player_score.erase(key)
				pass
	
	for j in range(players_sorted.size()):
		var player_sorted = players_sorted[j]
		var index = players.find(player_sorted)
		avatars_sorted.append(avatars[index])
	

	print("PLAYERS; ", players_sorted)
	print("AVATARS; ", avatars_sorted)
	print("SCORES; ", scores_sorted)
	
	#NOMES
	get_node("/root/MainScene/ResultsScreen/Backg1/PlayerProfile/NameBox/Label").text = players_sorted[0]
	get_node("/root/MainScene/ResultsScreen/Backg2/SecondPlaceSlot/NameSlot/Name").text = players_sorted[1]

	#IMAGENS DE AVATAR
	get_node("/root/MainScene/ResultsScreen/Backg1/PlayerProfile").texture = UiManager.imageIconAvatar(avatars_sorted[0])
	get_node("/root/MainScene/ResultsScreen/Backg2/SecondPlaceSlot/PlayerIcon").texture = UiManager.imageIconAvatar(avatars_sorted[1])

	#SCORES
	get_node("/root/MainScene/ResultsScreen/Backg1/PlayerProfile/ScoreBox/Label").text = str(scores_sorted[0])
	get_node("/root/MainScene/ResultsScreen/Backg2/SecondPlaceSlot/ScoreBox/Label").text = str(scores_sorted[1])

	if players.size() > 2:
		get_node("/root/MainScene/ResultsScreen/Backg2/ThirddPlaceSlot/NameSlot/Name").text = players_sorted[2]
		get_node("/root/MainScene/ResultsScreen/Backg2/ThirddPlaceSlot/PlayerIcon").texture = UiManager.imageIconAvatar(avatars_sorted[2])
		get_node("/root/MainScene/ResultsScreen/Backg2/ThirddPlaceSlot/ScoreBox/Label").text = str(scores_sorted[2])
	else:
		get_node("/root/MainScene/ResultsScreen/Backg2/ThirddPlaceSlot").visible = false

func _on_CloseScoresButton_pressed() -> void:
	scoresPanelReveal(false)

func getPlayersPositions():
	var data = get_node("/root/MainScene/").roomData
	var players =[]
	var avatars =[]
	var scores =[]
	
	for i in range(data.players.arrayValue.values.size()):
		players.append(data.players.arrayValue.values[i].stringValue)
		avatars.append(data.avatars.arrayValue.values[i].stringValue)
		scores.append(data.score.arrayValue.values[i].integerValue)
	
	players_sorted = []
	avatars_sorted = []
	scores_sorted = []
	player_score = {}
	
	if players.size() == scores.size():
		var i = 0
		for element in players:
			player_score[element] = int(scores[i])
			i += 1
			
	print("DICTIONARY; ", player_score)
	
	for j in range(players.size()):
		var maxV = player_score.values().max()
		scores_sorted.append(maxV)
		print("maxV; ", maxV)
		for key in player_score:
			var value = player_score[key]
			if value == maxV:
				players_sorted.append(key)
				player_score.erase(key)
				pass
	
	for j in range(players_sorted.size()):
		var player_sorted = players_sorted[j]
		var index = players.find(player_sorted)
		avatars_sorted.append(avatars[index])
	

	print("PLAYERS; ", players_sorted)
	print("AVATARS; ", avatars_sorted)
	print("SCORES; ", scores_sorted)

func scorePanelInfo():
	getPlayersPositions()
	var scorePlayerPrefab = preload("res://Prefabs/PlayerScorePrefab.tscn")
	var container = get_node('/root/MainScene/Background/ScoresPanel/VBoxContainer')
	#Limpar container
	
	for n in container.get_children():
		container.remove_child(n)
		n.queue_free()
	
	for i in range(players_sorted.size()):
		var sc = scorePlayerPrefab.instance()
		container.add_child(sc)
		#avatar image
		#sc.get_child(0).texture = UiManager.imageIconAvatar(avatars_sorted[i])
		sc.get_child(0).texture = UiManager.littleImageIcon(avatars_sorted[i])
		#name
		sc.get_child(1).get_child(0).text = players_sorted[i]
		#score
		sc.get_child(2).get_child(0).text = str(scores_sorted[i])
	
	emit_signal("sliderUpdate",avatars_sorted,scores_sorted)


func _on_Answer_focus_entered() -> void:
	get_node("/root/MainScene/Background/AnswerTipPanel/AnswerPanel/Answer").set_placeholder("")

func _on_Answer_focus_exited() -> void:
	get_node("/root/MainScene/Background/AnswerTipPanel/AnswerPanel/Answer").set_placeholder(placeholderLineEdit)

func waitingFeedback(data):
	if data.answerState.stringValue == "right":
		get_node("/root/MainScene/Background/TipsForWaitingPlayer/ResultFeedbackCorrect").visible = true
		tipsWaiting.get_child(0).text = get_node("/root/MainScene/Tabuleiro").cartaDestaque.nomeCarta
	elif data.answerState.stringValue == "wrong":
		get_node("/root/MainScene/Background/TipsForWaitingPlayer/ResultFeedbackIncorrect").visible = true
	elif data.answerState.stringValue == "timeover":
		get_node("/root/MainScene/Background/TipsForWaitingPlayer/ResultFeedbackTimeOver").visible = true
	yield(get_tree().create_timer(2), "timeout")
	get_node("/root/MainScene/Background/TipsForWaitingPlayer/ResultFeedbackCorrect").visible = false
	get_node("/root/MainScene/Background/TipsForWaitingPlayer/ResultFeedbackIncorrect").visible = false
	get_node("/root/MainScene/Background/TipsForWaitingPlayer/ResultFeedbackTimeOver").visible = false
	tipsWaiting.get_child(0).text = ''
	#get_node("/root/MainScene/").endWaitingFeedback()
