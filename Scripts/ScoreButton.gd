extends Node

func _on_ScoreButton_pressed():
	get_node("/root/MainScene/AudioStreamPlayer2").play()
	get_node("/root/MainScene/Background").scoresPanelReveal(true)
