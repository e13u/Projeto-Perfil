extends Node

onready var http : HTTPRequest = $HTTPRequest
#onready var http2 : HTTPRequest = $HTTPRequest2
onready var iniciarBtn : TextureButton = $ConfirmButton
onready var roomsContainer = $VBoxContainer
var hostName : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#iniciarBtn.disabled = true
	hostName = ""
	#Firebase.connect("roomCreated",self,"on_room_Created")
	_getActiveRooms()
	
func toggleConfirmButton(disabled, name):
	iniciarBtn.disabled = disabled
	hostName = name
	_on_ConfirmButton_pressed()
	
func _getActiveRooms():
	print("Verificando Salas")
	Firebase.get_document("partidas", http)

func _on_CancelButton_pressed() -> void:
	get_tree().change_scene("res://interface/profile/Lobby.tscn")

func _resetRooms():
	for child in roomsContainer.get_children():
		child.queue_free()
	
func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var hostNames = []
	var avatarIconsNames = []
	var playersInRoomNames = []
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	_resetRooms()
	
	for i in range(result_body.values()[0].size()):
		#print(result_body.values()[0][i].fields.player_0.stringValue)
		if result_body.values()[0][i].fields.state.stringValue == "open":
			hostNames.append(result_body.values()[0][i].fields.players.arrayValue.values[0].stringValue)
			avatarIconsNames.append(result_body.values()[0][i].fields.avatars.arrayValue.values[0].stringValue)
			playersInRoomNames.append(result_body.values()[0][i].fields.players.arrayValue.values)

	for j in (hostNames.size()):
		var hostButtonPrefab = preload("res://Prefabs/RoomPrefab.tscn")
		var hostButton = hostButtonPrefab.instance()
		roomsContainer.add_child(hostButton)
		hostButton.get_child(2).get_child(0).text = hostNames[j]
		hostButton.get_child(1).texture = UiManager.imageIconAvatar(avatarIconsNames[j])
		#print(playersInRoomNames[j])
		#hostButton.get_child(3).text = playersInRoomNames[j].stringValue

func _on_Timer_timeout() -> void:
	_getActiveRooms()


func _on_ConfirmButton_pressed() -> void:
	Firebase.hostName = hostName
	Firebase.isHost = false
	#get_tree().change_scene("res://interface/profile/Room.tscn")
	get_tree().change_scene("res://interface/profile/CharacterSelectClient.tscn")
