extends Node

var casasTotais = 100
var baralho = null
var cartaDestaque = null
export(Array, Texture) var charactersAvatarImages
var http2 : HTTPRequest
var data

func inicializarBaralho():
	baralho = load("res://Prefabs/Baralho.tres")
	baralho.criarBaralho()
	print(baralho.qtCartasTotais)
	baralho._embaralhar()
	if Firebase.isHost:
		saveDeckInfo()

func saveDeckInfo():
	http2 = get_node("/root/MainScene/HTTPRequest2")
	data = get_node("/root/MainScene/").roomData
	data.cards.arrayValue.values.remove(0)
	for i in baralho.pilhaCartas:
		data.cards.arrayValue.values.append({ "integerValue": i.idCarta})
	Firebase.update_document("partidas/%s" % Firebase.hostName, data, http2)

func _on_HTTPRequest2_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	print(response_code)
	_popCard()
	
func _popCard():
	cartaDestaque = baralho.pilhaCartas[0]	
	showTips()
	
func _popCard2():
	data = get_node("/root/MainScene/").roomData
	baralho.pilhaCartas.remove(0)
	cartaDestaque = baralho.pilhaCartas[0]
	
func _popCCard(card):
	cartaDestaque = card
	#get_node("/root/MainScene/").verifyWhoPlays()
	showTips()
	
func _popCCard2(card):	
	cartaDestaque = card
	print(cartaDestaque.nomeCarta)
	
func showTips():
	var tipPrefab = preload("res://Prefabs/Tip.tscn")
	var size = cartaDestaque.dicas.size()
	#data = get_node("/root/MainScene/").roomData
	for i in range(size):
		var tip = tipPrefab.instance()
		get_node("/root/MainScene/Background/HintsPanel/GridContainer").add_child(tip)
		tip.text = str(i+1)
		tip.disabled = true
	get_node("/root/MainScene/").verifyWhoPlays()
