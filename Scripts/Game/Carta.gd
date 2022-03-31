extends Resource
class_name Carta

export(int) var idCarta
export(String) var nomeCarta
export(Categoria.Categori) var categoriaCarta:int
export(TipoCarta.TC) var tipoCarta:int
export(PoolStringArray) var dicas
export(PoolStringArray) var instrucoes
export(int) var qtDicas
export(float) var qtPontosTotais
export(float) var pontosDica
export(PoolStringArray) var possiveisRespostas
export(bool) var cartaBonus

func _revelarDica():
	pass

func _verificarResposta():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
