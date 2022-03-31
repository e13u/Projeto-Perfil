extends Node

func imageIconAvatar(avatar):
	var tex
	match avatar:
		"Adao": 
			tex= load("res://Sprites/ADAO ICON.png")
		"Cida": 
			tex= load("res://Sprites/CIDA ICON.png")
		"Legis": 
			tex= load("res://Sprites/LEGIS ICON.png")
		"Vital": 
			tex= load("res://Sprites/VITAL ICON.png")
		"Xereta": 
			tex= load("res://Sprites/XERETA ICON.png")
		"Ze Plenarinho": 
			tex= load("res://Sprites/ZE ICON.png")
	return tex
