extends Node

func _on_TextureButton_pressed() -> void:
	pass
	#var name = $NameRect/RoomName.text
	#get_parent().get_parent().toggleConfirmButton(false, name)

func _on_AvatarButton_pressed() -> void:
	pass
	#get_child(0).pressed = true
	#_on_TextureButton_pressed()
	#var name = $NameRect/RoomName.text
	#get_parent().get_parent().toggleConfirmButton(false, name)

#func _on_TextureButton2_pressed() -> void:
	#var name = $NameRect/RoomName.text
	#get_child(0).visible = true
	#get_parent().get_parent().toggleConfirmButton(false, name)

func _on_TextureButton2_toggled(button_pressed: bool) -> void:
	var name = $NameRect/RoomName.text
	get_parent().get_parent().toggleConfirmButton(false, name)
	if !button_pressed:
		get_child(0).visible = false
	else:
		get_child(0).visible = true
