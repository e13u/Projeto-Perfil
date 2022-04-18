extends Node

func _on_TextureButton_pressed() -> void:
	var name = $NameRect/RoomName.text
	get_parent().get_parent().toggleConfirmButton(false, name)
