extends StaticBody3D

@export var requirement_type : String = "key"
@export var requirement_value : String = ""
@onready var sprite_3d: Sprite3D = $Sprite3D

@export var interact_type : String = "Gate"

var player = Global.playerNode; 
@onready var anim: AnimationPlayer = $Sprite3D/AnimationPlayer

func _ready():
	pass

func interact():
	match requirement_type:
		"key":
			if Global.keys >= 1:
				openGate()
			else:
				denyGate()
		"heart":
			if player.heart_level >= int(requirement_value):
				openHeartGate()
			else:
				denyHeartGate()


func openGate():
 
	Global.keys -= 1;
	Global.say_quick("You use a key and open the door and it opens!")
	#anim.play("DOOROPENING")
	self.queue_free()
	
	
func denyGate():

	Global.say_quick("You need a key to open this door!")			
	
	
func openHeartGate(): 
	Global.keys -= 1;
	Global.say_quick("You are gentle of heart and the gate opens")
	
	
func denyHeartGate():
	Global.say_quick("Try cultivating heart to open this gate")			
	
func showInteractionUIElement():
	UI.showDoorUse()
