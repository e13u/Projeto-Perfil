extends Node

func _on_TextureButton2_toggled(button_pressed: bool) -> void:
	var name = $NameRect/RoomName.text
	get_parent().get_parent().toggleConfirmButton(false, name)
	if !button_pressed:
		get_child(0).visible = false
	else:
		get_child(0).visible = true
