extends Node

onready var http :HTTPRequest = $HTTPRequest
onready var http2 :HTTPRequest = $HTTPRequest2
onready var http3 :HTTPRequest = $HTTPRequest3
onready var http4 :HTTPRequest = $HTTPRequest4
onready var http5 :HTTPRequest = $HTTPRequest5
onready var http6 :HTTPRequest = $HTTPRequest6
onready var http7 :HTTPRequest = $HTTPRequest7
onready var http8 :HTTPRequest = $HTTPRequest8
onready var turnTimer: Timer = $TimerTurn
onready var playerProfileImage = $Background/PlayerProfile
onready var scoreText= $Background/PlayerProfile/ScoreButton/Label
onready var playerNameText= $Background/PlayerProfile/NameBox/Label

var tabuleiro
var playersNames =[]
var avatarsNames =[]
var roomData
var turnState = 0
var mediator
var activePlayer
var canStart = false
var playerTurnUI
var gameEnded = false
var pointsForWinning = 100

func _initGame() -> void:
	turnState = 0
	http = get_node("HTTPRequest")
	http2 = get_node("HTTPRequest2")
	http3 = get_node("HTTPRequest3")
	http4 = get_node("HTTPRequest4")
	http5 = get_node("HTTPRequest5")
	http6 = get_node("HTTPRequest6")
	playerTurnUI = get_node("/root/MainScene/Background/")
	playerProfileImage.visible = false
	if http == null:
		print("DEU RUIM")
	Firebase.get_document("partidas/%s" % Firebase.hostName, http)

func _telaSelecionarPersonagem(ligar):
	get_node("/root/MainScene/EscolherPersonagemPanel").visible = ligar

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	roomData = result_body.fields
	if turnState == 0 :
		for i in roomData.players.arrayValue.values.size():
			playersNames.append(roomData.players.arrayValue.values[i].stringValue)
			avatarsNames.append(roomData.avatars.arrayValue.values[i].stringValue)
		playersIcon()
	if turnState == 1:
		mediator = roomData.mediator.stringValue
		activePlayer = roomData.activePlayer.stringValue
		roomData.usedTips.arrayValue.values.remove(0)
	if turnState == 2:
		print("Active Player: ",activePlayer)
		var index = playersNames.find(activePlayer)+1 #3 ->4
		#print("INDEX: ",index)
		if index == playersNames.size():
			index = 0
		activePlayer = playersNames[index]
		#print("ACTIVE PLAYER: ",activePlayer, " INDEX: ",index)
		roomData.activePlayer.stringValue = activePlayer
		Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http4)

func _on_Timer_timeout() -> void:
	_initGame()

func playersIcon():
	var index = _getPlayerIndex(Firebase.user_email)
	playerProfileImage.texture = UiManager.imageIconAvatar(avatarsNames[index])
	playerProfileImage.visible = true
	scoreText.text = '0'
	playerNameText.text = Firebase.user_email
#	var iconPrefab = preload("res://Prefabs/iconPlayer.tscn")
#	for i in avatarsNames.size():
#		var icon = iconPrefab.instance()
#		#get_node("Background/PlayerContainer/player_image_"+str(i)).texture = UiManager.imageIconAvatar(avatarsNames[i])
#		get_node("/root/MainScene/Background/PlayerContainer/").add_child(icon)
#		icon.texture = UiManager.imageIconAvatar(avatarsNames[i])
	playersPins()	
		
func playersPins():	
#	var pinPrefab = preload("res://Prefabs/player_pin_.tscn")
#	for i in avatarsNames.size(): 
#		var pin = pinPrefab.instance()
#		get_node("/root/MainScene/Background/PinsPanel").add_child(pin)
#		pin.texture = UiManager.imageIconAvatar(avatarsNames[i])
	updareScoreInSlider()
	if Firebase.isHost:
		defineRoles()
	else:
		$Tabuleiro.inicializarBaralho()
		waitGameInfo()

func defineRoles():
	turnState = 1
	mediator = playersNames[-1]
	activePlayer = playersNames[-2]
	print("Mediador:"+mediator)
	print("Active Player:"+activePlayer)
	roomData.mediator.stringValue = mediator
	roomData.activePlayer.stringValue = activePlayer
	sortDeck()
	#Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http)

func sortDeck():
	$Tabuleiro.inicializarBaralho()
	
func waitGameInfo():
	while !canStart:
		Firebase.get_document("partidas/%s" % Firebase.hostName, http3)
		#Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http3)
		yield(get_tree().create_timer(0.5), "timeout")
	print("POSSO COMEÇAR")
	_popClientCard(1)

func _on_HTTPRequest3_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	roomData = result_body.fields 
	#print(roomData.cards.arrayValue.values)
	if roomData.cards.arrayValue.values.size() >1:
		print("RECEBI OS DADOS!")
		canStart = true

func _popClientCard(code):
	var card : Carta
	var ran = $Tabuleiro.baralho.pilhaCartas.size()
	
	for i in range(ran):
		if $Tabuleiro.baralho.pilhaCartas[i].idCarta == int(roomData.cards.arrayValue.values[0].integerValue):
			card = $Tabuleiro.baralho.pilhaCartas[i]
	if code == 1:
		$Tabuleiro._popCCard(card)
	elif code ==2:
		#roomData.activeTip.integerValue = int(-1)
		$Tabuleiro._popCCard2(card)
		

func verifyWhoPlays():
	#print(roomData.activePlayer.stringValue)
	if roomData.activePlayer.stringValue == Firebase.user_email:
		print("MINHA VEZ")
		_popClientCard(2)
		playerTurnUI.turnTipsButtons(true)
		playerTurnUI.revealTimer(true)
		playerTurnUI.revealWaitingUI(false)
		turnTimer.stop()
		playerTurnUI.startClock()
		get_node("Background/PlayerProfile/ActivePlayer").visible = true
		updareScoreInSlider()
		$AudioStreamPlayer.play()
	else:
		playerTurnUI.turnTipsButtons(false)
		playerTurnUI.revealTimer(false)
		playerTurnUI.revealWaitingUI(true)
		playerTurnUI.blockTipsUsed()
		playerTurnUI.usedTipsNumberText()
		get_node("Background/PlayerProfile/ActivePlayer").visible = false
		_popClientCard(2)
		turnTimer.start()
	
#AS VEZES DANDO ERRO QUANDO SELECIONA DICA NUMERO 15
func revealTip(number):
	var tipText = $Tabuleiro.cartaDestaque.dicas[number-1] #CORREÇÃO DE INDEX COMEÇANDO COM 0
	#print($Tabuleiro.cartaDestaque.dicas[number-1])
	#print($Tabuleiro.cartaDestaque.nomeCarta)
	roomData.usedTips.arrayValue.values.append({"integerValue": number})
	roomData.activeTip.integerValue = int(number-1)
	#Revela UI do jogador da vez
	#REVELAR PAINEL DE RESPOSTA
	playerTurnUI.revealTip(tipText)
	playerTurnUI.turnTipsButtons(false)
	playerTurnUI.revealTextBoxAnswer(true)
	playerTurnUI.revealTimer(true)
	Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http7)

func revealAnswerPanelWithNoTips():
	playerTurnUI.revealTip('')
	playerTurnUI.turnTipsButtons(false)
	playerTurnUI.revealTextBoxAnswer(true)
	playerTurnUI.revealTimer(true)
	Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http7)
	
#TRATAMENTO DAS STRINGS
func verifyAnswer(answer):
	var answer1 = stringProcessing(answer)
	var possible = $Tabuleiro.cartaDestaque.possiveisRespostas
	var possible2 = []
	
	for s in possible:
		s = stringProcessing(s)
		possible2.append(s)
	
	if answer1 in possible2:
		rightAnswer()
	else:
		wrongAnswer()

func nextPlayerTurn():
	turnState = 2
	activePlayer = roomData.activePlayer.stringValue
	Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http)
	#Firebase.get_document("partidas/%s" % Firebase.hostName, http)

func _on_TimerTurn_timeout() -> void:
	Firebase.get_document("partidas/%s" % Firebase.hostName, http5)
	
func _on_HTTPRequest4_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	verifyWhoPlays()

func _on_HTTPRequest5_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	roomData = result_body.fields
	if roomData.state.stringValue == "ended":
		endGame()
	elif roomData.state.stringValue == "answered":
		playerTurnUI.waitingFeedback(roomData)
	else:
		verifyWhoPlays()
	
func updateScore():
	var scoreBase = $Tabuleiro.cartaDestaque.pontosDica #AJUSTAR PARA QUANTIDADE DE DICAS UTILIZADAS
	var notUsedTips = $Tabuleiro.cartaDestaque.dicas.size()-playerTurnUI.usedTipsNumber
	var score = scoreBase*notUsedTips
	var scoreInt = int(round(score))
	
	#print("scoreBase: ",scoreBase," notUsedTips: ",notUsedTips)
	#print("ScoreTotal: ",scoreInt)
	var index = playersNames.find(Firebase.user_email)
	scoreInt += int(roomData.score.arrayValue.values[index].integerValue)
	roomData.score.arrayValue.values[index] = { "integerValue": scoreInt}
	roomData.cards.arrayValue.values.remove(0)
	roomData.usedTips.arrayValue.values = [{"integerValue":0}]
	#print("CARTA ACERTADA: ",roomData.cards.arrayValue.values[0].nomeCarta)
	scoreText.text = str(scoreInt)
	#$RightAnswerPanel/Box/SliderBackg.updatePlayerScore(avatarsNames[index],scoreInt)
	updareScoreInSlider()
	if scoreInt >= pointsForWinning:
		endGame()
	Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http6)

func _on_HTTPRequest6_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	$Tabuleiro._popCard2()
	nextPlayerTurn()
	
func rightAnswer():
	print("ACERTOU")
	playerTurnUI.rightAnswerPanel()
	playerTurnUI.turnTipsButtons(false)
	playerTurnUI.revealTextBoxAnswer(false)
	playerTurnUI.revealTimer(false)
	roomData.answerState = {"stringValue": "right"}
	sendAnswerResult()
	#updateScore()
	
func wrongAnswer():
	print("ERROU")
	updareScoreInSlider()
	playerTurnUI.wrongAnswerPanel()
	playerTurnUI.turnTipsButtons(false)
	playerTurnUI.revealTextBoxAnswer(false)
	playerTurnUI.revealTimer(false)
	roomData.answerState = {"stringValue": "wrong"}
	sendAnswerResult()
	#nextPlayerTurn()
	
func timeOver():
	updareScoreInSlider()
	playerTurnUI.timeOverPanel()
	playerTurnUI.turnTipsButtons(false)
	playerTurnUI.revealTextBoxAnswer(false)
	playerTurnUI.revealTimer(false)
	roomData.answerState = {"stringValue": "timeover"}
	sendAnswerResult()
	#nextPlayerTurn()

func sendAnswerResult():
	roomData.state = {"stringValue": "answered"}
	Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http8)
	
func endGame():
	gameEnded = true
	roomData.state = { "stringValue": "ended" }
	playerTurnUI.showResults(roomData)

func _getPlayerIndex(name):
	return playersNames.find(name)

func updareScoreInSlider():
	for i in avatarsNames.size():
			$RightAnswerPanel/Box/SliderBackg.updatePlayerScore(avatarsNames[i],int(roomData.score.arrayValue.values[i].integerValue))
			$WrongAnswerPanel/Box/SliderBackg.updatePlayerScore(avatarsNames[i],int(roomData.score.arrayValue.values[i].integerValue))
			$TimeOverPanel/Box/SliderBackg.updatePlayerScore(avatarsNames[i],int(roomData.score.arrayValue.values[i].integerValue))
			
func stringProcessing(text):
	var t_final = text.to_upper()
	t_final = t_final.replace('Á',"A")
	t_final = t_final.replace('À',"A")
	t_final = t_final.replace('Ã',"A")
	t_final = t_final.replace('Â',"A")
	
	t_final = t_final.replace('É',"E")
	t_final = t_final.replace('È',"E")
	t_final = t_final.replace('Ê',"E")
	
	t_final = t_final.replace('Í',"I")
	t_final = t_final.replace('Ì',"I")
	t_final = t_final.replace('Î',"I")

	t_final = t_final.replace('Ó',"O")
	t_final = t_final.replace('Ò',"O")
	t_final = t_final.replace('Ô',"O")
	t_final = t_final.replace('Õ',"O")
	
	t_final = t_final.replace('Ú',"U")
	t_final = t_final.replace('Ù',"U")
	t_final = t_final.replace('Û',"U")
	
	t_final = t_final.replace('Ç',"C")
	
	return t_final

func _on_FinishButton_pressed() -> void:
	get_tree().change_scene("res://MainGame/MainMenu.tscn")

func _on_HTTPRequest7_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	roomData = result_body.fields
	print(roomData.activeTip.integerValue)

func _on_HTTPRequest8_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	pass # Replace with function body.
