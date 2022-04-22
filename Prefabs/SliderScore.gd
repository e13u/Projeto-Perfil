extends TextureRect

func updatePlayerScore(character, score):
	var slider :Slider
	match character:
		"Adao": 
			slider = $SliderAdao
		"Cida": 
			slider = $SliderCida
		"Legis": 
			slider = $SliderLegis
		"Vital": 
			slider = $SliderVital
		"Xereta": 
			slider = $SliderXereta
		"Ze Plenarinho": 
			slider = $SliderZe
	slider.visible = true
	slider.value = score
