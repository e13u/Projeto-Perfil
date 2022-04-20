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
	
func dificultyImage(dif):
	var difi
	var tex
	print('dif: ',dif)

	if dif == 1:
		difi = 'easy'
	elif dif == 1.5:
		difi = 'medium'
	elif dif == 1.8:
		difi = 'hard'
		
	print('difi: ',difi)
	match difi:
		'easy':
			tex = load("res://interface/mainscreen/Jogo_AdivinhaQuemE_Tela5/dificuldade_icone1.png")
		'medium':
			tex = load("res://interface/mainscreen/Jogo_AdivinhaQuemE_Tela5/dificuldade_icone2.png")
		'hard':
			tex = load("res://interface/mainscreen/Jogo_AdivinhaQuemE_Tela5/dificuldade_icone3.png")
	return tex
