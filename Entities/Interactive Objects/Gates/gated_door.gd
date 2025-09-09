extends StaticBody3D

@export var requirement_type : String = "key"
@export var requirement_value : String = ""

func interact():
	match requirement_type:
		"key":
			if player.has_key(requirement_value):
				open_gate()
			else:
				deny_gate()
		"heart":
			if player.heart_level >= int(requirement_value):
				open_gate()
			else:
				deny_gate()

func open_gate():
	pass
	
func deny_gate():
	pass				
