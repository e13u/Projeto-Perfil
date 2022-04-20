extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var http2 : HTTPRequest = $HTTPRequest2
onready var username : LineEdit = $BG/TextureRect2/LineEditUserName
#onready var notification : Label = $Container/Notification
var standardPassword = "123456"
# 1=CREATE, 0= JOIN
var create = 0 

func _on_RegisterButton_pressed() -> void:
	#if password.text != confirm.text or username.text.empty() or password.text.empty():
		#notification.text = "Invalid password or username"
		#return
	Firebase.register(username.text, standardPassword, http)
	#Firebase.register(username.text, password.text, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	#SE EXISTIR USUÁRIO APENAS LOGAR
	if response_code != 200:
		#notification.text = response_body.result.error.message.capitalize()
		print(response_body.result.error.message)
		if response_body.result.error.message == "EMAIL_EXISTS":
			print("Conta já existente")
			yield(get_tree().create_timer(2.0), "timeout")
			login()
	#SE USUÁRIO NÃO EXISTIR CRIAR CONTA
	else:
		print("Conta nova criada")
		yield(get_tree().create_timer(2.0), "timeout")
		login()
	#get_tree().change_scene("res://interface/login/Login.tscn")

func _on_JoinButton_pressed() -> void:
	create = 0 
	Firebase.register(username.text, standardPassword, http)

func _on_CreateButton_pressed() -> void:
	create = 1 
	Firebase.register(username.text, standardPassword, http)
	
func login():
	Firebase.login(username.text, standardPassword, http2)

func _on_HTTPRequest2_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	print("ESTOU LOGADO")
	if create == 0:
		Firebase.isHost = false
		get_tree().change_scene("res://interface/profile/SearchRoom.tscn")
	else:
		Firebase.isHost = true
		get_tree().change_scene("res://interface/profile/UserProfile.tscn")
