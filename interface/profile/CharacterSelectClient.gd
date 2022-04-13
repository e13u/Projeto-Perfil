extends Node

onready var http : HTTPRequest = $HTTPRequest
onready var AdaoBtn: TextureButton = $VBoxContainer2/GridContainer/AdaoBtn
onready var CidaBtn: TextureButton = $VBoxContainer2/GridContainer/CidaBtn
onready var ZeBtn: TextureButton = $VBoxContainer2/GridContainer/ZeBtn
onready var LegisBtn: TextureButton = $VBoxContainer2/GridContainer/LegisBtn
onready var VitalBtn: TextureButton = $VBoxContainer2/GridContainer/VitalBtn
onready var XeretaBtn: TextureButton = $VBoxContainer2/GridContainer/XeretaBtn
onready var confirmBtn: Button = $ConfirmButton

var roomData
var usedChars = []
var selectedChar

func _ready() -> void:
	selectedChar = "null"
	confirmBtn.disabled = true
	Firebase.get_document("partidas/%s" % Firebase.hostName, http)
	
func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	print(response_code)
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	roomData = result_body.fields
	getUsedAvatars()

func getUsedAvatars():
	var avatars = roomData.avatars.arrayValue.values
	for i in range(avatars.size()):
		if avatars[i].stringValue != "null":
			usedChars.append(roomData.avatars.arrayValue.values[i].stringValue)
	blockAvatarOptions()
	
func blockAvatarOptions():
	if usedChars.has("Adao"):
		AdaoBtn.disabled = true
		AdaoBtn.modulate.a = 0.5
	if usedChars.has("Cida"):
		CidaBtn.disabled = true
		CidaBtn.modulate.a = 0.5
	if usedChars.has("Ze Plenarinho"):
		ZeBtn.disabled = true
		ZeBtn.modulate.a = 0.5
	if usedChars.has("Legis"):
		LegisBtn.disabled = true
		LegisBtn.modulate.a = 0.5
	if usedChars.has("Vital"):
		VitalBtn.disabled = true
		VitalBtn.modulate.a = 0.5
	if usedChars.has("Xereta"):
		XeretaBtn.modulate.a = 0.5


func _on_AdaoBtn_pressed() -> void:
	selectedChar = "Adao"
	confirmBtn.disabled = false


func _on_CidaBtn_pressed() -> void:
	selectedChar = "Cida"
	confirmBtn.disabled = false


func _on_ZeBtn_pressed() -> void:
	selectedChar = "Ze Plenarinho"
	confirmBtn.disabled = false


func _on_LegisBtn_pressed() -> void:
	selectedChar = "Legis"
	confirmBtn.disabled = false


func _on_VitalBtn_pressed() -> void:
	selectedChar = "Vital"
	confirmBtn.disabled = false


func _on_XeretaBtn_pressed() -> void:
	selectedChar = "Xereta"
	confirmBtn.disabled = false


func _on_ConfirmButton_pressed() -> void:
	if selectedChar != "null":
		Firebase.avatar = selectedChar
		get_tree().change_scene("res://interface/profile/Room.tscn")
