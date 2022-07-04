extends Node

var http_request_ping
var roomData
var playersPing
var stateRequest = 0
var timer = 3
var activePlayers = []

func _ready():
	yield(get_tree().create_timer(timer), "timeout")
	http_request_ping = HTTPRequest.new()
	add_child(http_request_ping)  
	print("Starting")  
	http_request_ping.connect("request_completed", self, "_http_request_completed")
	if Firebase.isHost:
		verifyPlayers()
	else:
		getInfo()
		
func getInfo():
	if Firebase.user_email != null and Firebase.hostName != null:
		stateRequest = 0
		Firebase.get_document("partidas/%s" % Firebase.hostName, http_request_ping)
	else:
		print("Not Started")
		yield(get_tree().create_timer(timer), "timeout")
		getInfo()
		
# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	print("Request")
	if stateRequest == 0:
		print("Getting info")
		var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
		roomData = result_body.fields
		roomData.playersPing.arrayValue.values.append({"stringValue": Firebase.user_email})
		sendPing()
	elif stateRequest == 1:
		print("Sending info")
		yield(get_tree().create_timer(timer), "timeout")
		getInfo()
	elif stateRequest == 2:
		for i in roomData.playersPing.arrayValue.values.size():
			activePlayers.append(roomData.playersPing.arrayValue.values[i].stringValue)

func sendPing():
	stateRequest = 1
	Firebase.update_document("partidas/%s" % Firebase.hostName, roomData, http_request_ping)

func verifyPlayers():
	if Firebase.user_email != null and Firebase.hostName != null:
		stateRequest = 2
		Firebase.get_document("partidas/%s" % Firebase.hostName, http_request_ping)
