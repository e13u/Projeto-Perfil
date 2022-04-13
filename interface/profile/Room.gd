extends Node

onready var http : HTTPRequest = $HTTPRequest
onready var http2 : HTTPRequest = $HTTPRequest2
onready var http3 : HTTPRequest = $HTTPRequest3
onready var http4 : HTTPRequest = $HTTPRequest4
onready var http5 : HTTPRequest = $HTTPRequest5

onready var numberPlayersLabel : Label = $TextureRect3/numberPlayersLabel
onready var iniciarBtn : Button = $VBoxContainer2/ConfirmButton

var playersInRoom :int = 0
var id 
var roomData
var isUpdating

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	iniciarBtn.disabled = true
	if Firebase.isHost:
		Firebase.hostName = Firebase.user_email
		startRoom()
	else:
		enterInRoom()

func startRoom():
	roomData = Firebase.get_document("partidas/%s" % Firebase.hostName, http4)
	isUpdating = true
	
func enterInRoom():
	roomData = Firebase.get_document("partidas/%s" % Firebase.hostName, http2)
	isUpdating = true
	
func _on_CancelButton_pressed() -> void:
	var user_email = Firebase.user_email
	if Firebase.isHost:
		var data = DataUtils.createRoomData()
		print("Apagando partida de: "+user_email)
		data.state = { "stringValue": "canceled" }
		Firebase.update_document("partidas/%s" % user_email, data, http)
	else:
		#roomData.player_1 = { "stringValue": "null"}
		roomData.players.arrayValue.values.remove(id)
		roomData.avatars.arrayValue.values.remove(id)
		
		Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http)
				
func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(response_code)
	isUpdating = false
	get_tree().change_scene("res://PrimeiraCena.tscn")


func _on_HTTPRequest2_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	#print(response_code)
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	roomData = result_body.fields
	#print(roomData)
	id = verifyNumberOfPlayersInRoom()
	#print("Meu id:"+str(id))
	Firebase.playerId = id
	roomData.players.arrayValue.values.append({ "stringValue": Firebase.user_email})
	roomData.avatars.arrayValue.values.append({ "stringValue": Firebase.avatar})
	roomData.score.arrayValue.values.append({"integerValue":0})
	isUpdating = false
	Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http3)
	
func _on_HTTPRequest3_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	isUpdating = false
	refreshPlayerList()


func _on_Timer2_timeout() -> void:
	roomData = Firebase.get_document("partidas/%s" % Firebase.hostName, http4)
	isUpdating = true


func refreshPlayerList():
	var players = roomData.players.arrayValue.values
	for i in range(players.size()):
		if players[i].stringValue != "null":
			get_node("VBoxContainer2/Panel/VBoxContainer/Label_"+str(i)).text = players[i].stringValue
	numberPlayersLabel.text = "Jogadores("+str(players.size())+"/6)"
	
	if players.size() > 1 and Firebase.isHost:
		iniciarBtn.disabled = false
	else:
		iniciarBtn.disabled = true
	var roomState = roomData.state.stringValue
	if !Firebase.isHost and roomState == "start" and !isUpdating:
		_startGame()
	
func _on_HTTPRequest4_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	roomData = result_body.fields
	isUpdating = false
	refreshPlayerList()

#DANDO BUG AS VEZES // AINDA DANDO BUG ALEATORIAMENTE
#INVALID GET INDEX PLAYERS ON BASE NIL
func verifyNumberOfPlayersInRoom():
	if(roomData.players.arrayValue.values != null):
		return roomData.players.arrayValue.values.size()

func _on_ConfirmButton_pressed() -> void:
	var data = roomData
	if verifyNumberOfPlayersInRoom() > 1: 
		data.state = { "stringValue": "start" }
		Firebase.update_document("partidas/%s" % Firebase.hostName, data, http5)

func _on_HTTPRequest5_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	_startGame()

func _startGame():
	get_tree().change_scene("res://MainGame/MainGame.tscn")
