extends Node

onready var http :HTTPRequest = $HTTPRequest
onready var http3 :HTTPRequest = $HTTPRequest3
onready var http4 :HTTPRequest = $HTTPRequest4
onready var http5 :HTTPRequest = $HTTPRequest5
onready var http6 :HTTPRequest = $HTTPRequest6
onready var turnTimer: Timer = $TimerTurn
var tabuleiro
var playersNames =[]
var avatarsNames =[]
var roomData
var turnState = 0
var mediator
var activePlayer
var canStart = false
var playerTurnUI

func _initGame() -> void:
	turnState = 0
	http = get_node("HTTPRequest")
	http3 = get_node("HTTPRequest3")
	http4 = get_node("HTTPRequest4")
	http5 = get_node("HTTPRequest5")
	http6 = get_node("HTTPRequest6")
	playerTurnUI = get_node("/root/MainScene/Background/")
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
		print("INDEX: ",index)
		if index == playersNames.size():
			index = 0
		activePlayer = playersNames[index]
		print("ACTIVE PLAYER: ",activePlayer, " INDEX: ",index)
		roomData.activePlayer.stringValue = activePlayer
		Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http4)

func _on_Timer_timeout() -> void:
	_initGame()

func playersIcon():
	var iconPrefab = preload("res://Prefabs/iconPlayer.tscn")
	for i in avatarsNames.size():
		var icon = iconPrefab.instance()
		#get_node("Background/PlayerContainer/player_image_"+str(i)).texture = UiManager.imageIconAvatar(avatarsNames[i])
		get_node("/root/MainScene/Background/PlayerContainer/").add_child(icon)
		icon.texture = UiManager.imageIconAvatar(avatarsNames[i])
	playersPins()	
		
func playersPins():	
	var pinPrefab = preload("res://Prefabs/player_pin_.tscn")
	for i in avatarsNames.size(): 
		var pin = pinPrefab.instance()
		get_node("/root/MainScene/Background/PinsPanel").add_child(pin)
		pin.texture = UiManager.imageIconAvatar(avatarsNames[i])
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
	_popClientCard()

func _on_HTTPRequest3_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	roomData = result_body.fields 
	#print(roomData.cards.arrayValue.values)
	if roomData.cards.arrayValue.values.size() >1:
		print("RECEBI OS DADOS!")
		canStart = true

func _popClientCard():
	var card : Carta
	var ran = $Tabuleiro.baralho.pilhaCartas.size()
	
	for i in range(ran):
		if $Tabuleiro.baralho.pilhaCartas[i].idCarta == int(roomData.cards.arrayValue.values[0].integerValue):
			card = $Tabuleiro.baralho.pilhaCartas[i]
	$Tabuleiro._popCCard(card)
			
func verifyWhoPlays():
	#print(roomData.activePlayer.stringValue)
	if roomData.activePlayer.stringValue == Firebase.user_email:
		print("MINHA VEZ")
		playerTurnUI.turnTipsButtons(true)
		playerTurnUI.revealTimer(true)
		turnTimer.stop()
		playerTurnUI.startClock()
	else:
		playerTurnUI.turnTipsButtons(false)
		turnTimer.start()
	
func revealTip(number):
	var tipText = $Tabuleiro.cartaDestaque.dicas[number]
	print($Tabuleiro.cartaDestaque.dicas[number])
	roomData.usedTips.arrayValue.values.append({"integerValue": number})
	#Revela UI do jogador da vez
	playerTurnUI.revealTip(tipText)
	playerTurnUI.turnTipsButtons(false)
	playerTurnUI.revealTextBoxAnswer(true)
	playerTurnUI.revealTimer(true)
	
func verifyAnswer(answer):
	if answer in $Tabuleiro.cartaDestaque.possiveisRespostas:
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
	verifyWhoPlays()
	
func updateScore():
	var score = 10 #AJUSTAR PARA QUANTIDADE DE DICAS UTILIZADAS
	var index = playersNames.find(activePlayer)
	roomData.score.arrayValue.values[index] = { "integerValue": score}
	roomData.cards.arrayValue.values.remove(0)
	print(roomData.cards.arrayValue.values[0])
	Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http6)

func _on_HTTPRequest6_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	print("HTTP6 ",response_code)
	nextPlayerTurn()
	
func rightAnswer():
	print("ACERTOU")
	playerTurnUI.turnTipsButtons(false)
	playerTurnUI.revealTextBoxAnswer(false)
	playerTurnUI.revealTimer(false)
	updateScore()
	
func wrongAnswer():
	print("ERROU")
	print($Tabuleiro.cartaDestaque.nomeCarta)
	playerTurnUI.turnTipsButtons(false)
	playerTurnUI.revealTextBoxAnswer(false)
	playerTurnUI.revealTimer(false)
	nextPlayerTurn()
