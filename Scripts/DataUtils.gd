extends Node

func createRoomData():
	var roomData := {
		"players":{"arrayValue":{"values":[{"stringValue":"null"}]}},
		"avatars":{"arrayValue":{"values":[{"stringValue":"null"}]}},
		"cards":{"arrayValue":{"values":[{"integerValue":1000}]}},
		"state":{"stringValue": "null" },
		"mediator":{"stringValue": "null" },
		"activePlayer":{"stringValue": "null" },
		"score":{"arrayValue":{"values":[{"integerValue":0}]}},
		"usedTips":{"arrayValue":{"values":[{"integerValue":0}]}},
	} 
	return roomData
