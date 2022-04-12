extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var http2 : HTTPRequest = $HTTPRequest2
#onready var notification : Label = $Container/Notification

var new_room := false
var information_sent := false
var player_Avatar

func _ready() -> void:
	player_Avatar = "null"
	print(Firebase.user_email)
	Firebase.get_document("partidas/%s" % Firebase.user_email, http2)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(response_code)
	match response_code:
		404:
			print("Please, enter your information")
			new_room = true
			return
		200:
			if information_sent:
				print("Information saved successfully")
				information_sent = false
			#self.profile = result_body.fields
			get_tree().change_scene("res://interface/profile/Room.tscn")

func _on_ConfirmButton_pressed() -> void:
	if player_Avatar == "null":
		return
	
	var host_name = Firebase.user_email
	var profile = DataUtils.createRoomData()
	#host_name.erase(host_name.length() - Firebase.email_domain.length(), host_name.length() - 1)
	#notification.text = "Please, enter your nickname and class"
	profile.players = {"arrayValue":{"values":[{"stringValue":host_name}]}}
	#profile.players = { "stringValue": host_name}
	#profile.avatars[0] = { "stringValue": player_Avatar }
	profile.avatars = {"arrayValue":{"values":[{"stringValue":player_Avatar}]}}
	profile.state = { "stringValue": "open" }
	print(profile)
	
	match new_room:
		true:
			print("save_document")
			Firebase.save_document("partidas?documentId=%s" % host_name, profile, http)
		false:
			print("update_document")
			Firebase.update_document("partidas/%s" % host_name, profile, http)
	information_sent = true

func _on_AdaoBtn_pressed() -> void:
	player_Avatar = "Adao"


func _on_CidaBtn_pressed() -> void:
	player_Avatar = "Cida"


func _on_ZeBtn_pressed() -> void:
	player_Avatar = "Ze Plenarinho"


func _on_legisBtn_pressed() -> void:
	player_Avatar = "Legis"


func _on_VitalBtn_pressed() -> void:
	player_Avatar = "Vital"


func _on_XeretaBtn_pressed() -> void:
	player_Avatar = "Xereta"


func _on_HTTPRequest2_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(response_code)
	match response_code:
		404:
			print("Não ha sala com esse nome")
			new_room = true
			return
		200:
			new_room = false
