extends Node

func _ready() -> void:
	pass # Replace with function body.

func _on_LinkButton_pressed() -> void:
	get_node("/root/MainScene/").revealTip(int(self.text))
	print("Apertei")
