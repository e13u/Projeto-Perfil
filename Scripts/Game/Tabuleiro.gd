extends Node

var cardTypeBox
var cardDificultyImage 
var casasTotais = 100
var baralho = null
var cartaDestaque = null
export(Array, Texture) var charactersAvatarImages
var http2 : HTTPRequest
var data

func inicializarBaralho():
	baralho = load("res://Prefabs/Baralho.tres")
	cardTypeBox = get_node("/root/MainScene/Background/CardTypeBox/Label")
	cardDificultyImage = get_node("/root/MainScene/Background/DificultyBox/DificultyBox2/TextureRect")
	baralho.criarBaralho()
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
	#print(response_code)
	_popCard()
	
func _popCard():
	cartaDestaque = baralho.pilhaCartas[0]	
	showTips()
	
func _popCard2 ():
	data = get_node("/root/MainScene/").roomData
	baralho.pilhaCartas.remove(0)
	cartaDestaque = baralho.pilhaCartas[0]
	
func _popCCard(card):
	cartaDestaque = card
	#get_node("/root/MainScene/").verifyWhoPlays()
	showTips()
	
func _popCCard2(card):	
	cartaDestaque = card
	#print(cartaDestaque.nomeCarta)
	
func showTips():
	var tipPrefab = preload("res://Prefabs/TipButton.tscn")
	var size = cartaDestaque.dicas.size()
	#data = get_node("/root/MainScene/").roomData
	_cardData()
	for i in range(size):
		var tip = tipPrefab.instance()
		get_node("/root/MainScene/Background/HintsPanel/GridContainer").add_child(tip)
		tip.get_child(0).text = str(i+1)
		#tip.tipNumber = str(i+1)
		tip.disabled = true
	get_node("/root/MainScene/").verifyWhoPlays()
	
func _cardData():
	var allTheEnumKeys = Categoria.Categori.keys()
	var key_value = allTheEnumKeys[cartaDestaque.categoriaCarta]
	print("CAT: ", key_value )
	cardTypeBox.text = key_value
	print("DIFI: ",cartaDestaque.pontosDica)
	cardDificultyImage.texture = UiManager.dificultyImage(cartaDestaque.pontosDica)
