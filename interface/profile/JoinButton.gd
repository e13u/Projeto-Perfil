extends Node

func _on_TextureButton_pressed() -> void:
	var name = $NameRect/RoomName.text
	get_parent().get_parent().toggleConfirmButton(false, name)

func _on_AvatarButton_pressed() -> void:
	get_child(0).pressed = true
	_on_TextureButton_pressed()
	#var name = $NameRect/RoomName.text
	#get_parent().get_parent().toggleConfirmButton(false, name)
