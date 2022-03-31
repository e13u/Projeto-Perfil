extends Resource
class_name Baralho

export(int) var qtCartasTotais
export(int) var qtCartasAtual
export(Array, Resource)var pilhaCartas

func criarBaralho():
	var cartas_diretorio = Directory.new()
	cartas_diretorio .open("res://CartasResources/")
	cartas_diretorio.list_dir_begin(true)

	var carta = cartas_diretorio.get_next()
	while carta != "":
		pilhaCartas.append(load("res://CartasResources/" + carta))
		carta = cartas_diretorio.get_next()
		
	#pilhaCartas.append(load("res://CartasResources/carta1.tres"))
	qtCartasTotais = pilhaCartas.size()

func _getBaralho():
	return pilhaCartas
	
func _embaralhar():
	var shuffled = pilhaCartas.duplicate()
	randomize()
	shuffled.shuffle()
	var sampled = []
	for i in range(pilhaCartas.size()):
		sampled.append(shuffled.pop_front() )
		pilhaCartas = sampled

func _revelarCarta():
	pass

func _descartar():
	pass

#func _process(delta):
#	pass
