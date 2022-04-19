extends Node

func _ready() -> void:
	pass # Replace with function body.

func _on_TipButton_pressed() -> void:
	get_node("/root/MainScene/").revealTip(int(get_child(0).text))
	print("Apertei")
