extends Node

var firebase

func _ready():
	firebase = Engine.has_singleton("FireBase")
	print(firebase)
	#firebase.initWithFile("res//godot-firebase-config.json", get_instance_id())
