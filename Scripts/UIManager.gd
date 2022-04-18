extends Node

func imageIconAvatar(avatar):
	var tex
	match avatar:
		"Adao": 
			tex= load("res://interface/rooms/Adao_button.png")
		"Cida": 
			tex= load("res://interface/rooms/Cida_button.png")
		"Legis": 
			tex= load("res://interface/rooms/Legis_button.png")
		"Vital": 
			tex= load("res://interface/rooms/Vital_button.png")
		"Xereta": 
			tex= load("res://interface/rooms/Xereta_button.png")
		"Ze Plenarinho": 
			tex= load("res://interface/rooms/Ze_button.png")
	return tex
