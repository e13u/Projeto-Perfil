extends Node

var imagemPersonagem :ImageTexture
var nomePersonagem : String

# Called when the node enters the scene tree for the first time.
func _definirPersonagem(idPersonagem):
	print(idPersonagem)
	get_node("/root/MainScene").call("_telaSelecionarPersonagem",false)
	get_node("/root/MainScene/BackgroundMesa").call("definirImagemPlayer", idPersonagem)


func _on_TextureButton1_button_down() -> void:
	_definirPersonagem(1)


func _on_TextureButton2_button_down() -> void:
	_definirPersonagem(2)


func _on_TextureButton3_button_down() -> void:
	_definirPersonagem(3)


func _on_TextureButton4_button_down() -> void:
	_definirPersonagem(4)


func _on_TextureButton5_button_down() -> void:
	_definirPersonagem(5)


func _on_TextureButton6_button_down() -> void:
	_definirPersonagem(6)
