extends Control

var count = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"1".visible = true
	$"2".visible = false
	$"3".visible = false
	$"4".visible = false
	$"5".visible = false
	$"6".visible = false
	$"7".visible = false
	$"8".visible = false

func _on_ScreenButton_pressed() -> void:
	count = count+1
	$"1".visible = true
	$"2".visible = false
	$"3".visible = false
	$"4".visible = false
	$"5".visible = false
	$"6".visible = false
	$"7".visible = false
	$"8".visible = false
	if count == 1:
		$"2".visible = true
	elif count == 2:
		$"3".visible = true
		$JumpToGameButton1.visible = false
		$JumpToGameButton2.visible = true
	elif count == 3:
		$"4".visible = true
		$JumpToGameButton1.visible = true
		$JumpToGameButton2.visible = false
	elif count == 4:
		$"5".visible = true
		$JumpToGameButton1.visible = false
		$JumpToGameButton2.visible = true
	elif count == 5:
		$"6".visible = true
	elif count == 6:
		$"7".visible = true
	elif count == 7:
		$"8".visible = true
		$ScreenButton.visible = false
		$JumpToGameButton1.visible = false
		$JumpToGameButton2.visible = false
		$JumpToGameButton3.visible = true
	else:
		LoadMainScreen()

func _on_JumpToGameButton_pressed() -> void:
	 LoadMainScreen()

func LoadMainScreen():
	get_tree().change_scene("res://MainGame/MainMenu.tscn")
