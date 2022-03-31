extends Control

onready var http2 : HTTPRequest = $HTTPRequest2
onready var username : LineEdit = $Container/VBoxContainer2/Username/LineEdit
onready var password : LineEdit = $Container/VBoxContainer2/Password/LineEdit
onready var notification : Label = $Container/Notification


func _on_LoginButton_pressed() -> void:
	pass
	#if username.text.empty() or password.text.empty():
		#notification.text = "Please, enter your username and password"
		#return
	#Firebase.login(username.text, password.text, http)
	#Firebase.login(username.text, "123456", http)
	#Firebase.login("xaxa", "123456", http)
	
func login(user):
	Firebase.login(user, "123456", http2)
"""
func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
		print(notification.text)
	else:
		notification.text = "Sign in sucessful!"
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://interface/profile/Lobby.tscn")
"""

func _on_HTTPRequest2_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
		print(notification.text)
	else:
		notification.text = "Sign in sucessful!"
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://interface/profile/Lobby.tscn")
