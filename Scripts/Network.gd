extends Node

onready var http : HTTPRequest = $HTTPRequest
var ip_address = null
var net = null

const SERVER_PORT = 6969
const MAX_PLAYERS = 2

var profile := {
	"player_1": {},
	"player_2": {},
	"player_3": {},
}

func _ready() -> void:
	profile.player_1 = { "stringValue": "Ze" }
	profile.player_2 = { "stringValue": "Xereta" }
	profile.player_3 = { "integerValue": "Vital"}
	Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
	
"""
func _ready():
	get_tree().connect("network_peer_connected", 
	self, "_player_connected")

func _on_HostButton_pressed() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(net)
	print("hosting")


func _on_JoinButton_pressed() -> void:
	var net = NetworkedMultiplayerENet.new()
	net.create_client("127.0.0.1", SERVER_PORT)
	get_tree().set_network_peer(net)
	print("joining")

func _player_connected():
	print("Connected in Game")
	#var game = preload("res://Scenes/MainSceneCanvas.tscn").instance()
	#get_tree().get_root().add_child(game)
	#get_node("/root/MenuInicial/").visible = false
"""


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(response_code)
