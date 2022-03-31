extends Control


func _on_RegisterButton_pressed() -> void:
	get_tree().change_scene("res://interface/register/Register.tscn")


func _on_LoginButton_pressed() -> void:
	get_tree().change_scene("res://interface/Login.tscn")


func _on_CreateUserButton_pressed() -> void:
	get_tree().change_scene("res://interface/Register.tscn")
