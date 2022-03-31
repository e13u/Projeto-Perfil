extends Node

func _on_HostButton_pressed() -> void:
	get_parent().get_parent().get_parent().get_parent().toggleConfirmButton(false, self.text)
