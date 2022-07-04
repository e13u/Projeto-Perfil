extends Node

func _ready() -> void:
	pass # Replace with function body.

func _on_MainMenuButton_pressed() -> void:
	get_tree().change_scene("res://MainGame/MainMenu.tscn")

func _on_TutorialButton_pressed() -> void:
	get_tree().change_scene("res://MainGame/Tutorial.tscn")
