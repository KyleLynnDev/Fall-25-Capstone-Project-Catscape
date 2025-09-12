extends StaticBody3D

@export var requirement_type : String = "key"
@export var requirement_value : String = ""

var player = Global.playerNode; 


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
	# [TODO] - fire off open animation for door  
	pass
	
	
func deny_gate():
	# [TODO] - open text box that tells player they need to meet a certain threshhold 
	pass				
