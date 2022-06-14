extends Control

var count = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"1".visible = true
	$"2".visible = false
	$"3".visible = false

func _on_ScreenButton_pressed() -> void:
	count = count+1
	$"1".visible = false
	$"2".visible = false
	$"3".visible = false
	if count == 1:
		$"2".visible = true
	elif count == 2:
		$"3".visible = true
	else:
		LoadMainScreen()

func _on_JumpToGameButton_pressed() -> void:
	 LoadMainScreen()

func LoadMainScreen():
	get_tree().change_scene("res://MainGame/MainMenu.tscn")
