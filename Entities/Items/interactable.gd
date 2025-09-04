#@tool

extends StaticBody3D


@export var interact_name: String = "Unknown Object" 
@export var display_name : String = "Unknown Object"

@export var description : String
@export var effect : String = "none"

@export var sprite_preview : Texture 
@export var interact_type : String 

var scene_path : String = "res://Entities/Items/interactable_object.tscn"

@onready var visualSprite = $Visual

@export var npc_name: String = ""  # Optional — leave blank for non-NPCs

var playerInRange = false;
var player 




func _ready():
	if not Engine.is_editor_hint():
		visualSprite.texture = sprite_preview
		visualSprite.scale = Vector3(4.0,4.0,4.0)
	
		
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		visualSprite.texture = sprite_preview
	#UI.closeAllInteractUIs()
	#showInteractionUIElement()
func _physics_process(delta: float) -> void:

	if Global.isPlayerInRange:
		playerInRange = true
	else:
		playerInRange = false 
		
	#showInteractionUIElement()
	


func interact():
	# show you interacted with object 
	print("You interacted with:", interact_name)

	#logic for choosing which function to use: 
	if (interact_type == "Object"): 
		print("interaction type: Object")
		
	if (interact_type == "NPC"): 
		print("interaction type: NPC")
		Dialogic.start("example1")
		
	if (interact_type == "Skill"): 
		print("interaction type: Skill")
		
	if (interact_type == "Item"): 
		print("interaction type: Item")
		pickupItem() 
		
#function for using an item 
func pickupItem():
	var item = {
		"quantity" : 1,
		"type": interact_type,
		"name": interact_name,
		"effect": effect,
		"texture": sprite_preview,
		"scene_path" : scene_path
	}
	print("picking up item", item["name"])
	
	if Global.playerNode:
		Global.addItem(item)
		self.queue_free()
	


	
func showInteractionUIElement():
	print("[", name, "] type=", interact_type, " calling UI")
	match interact_type:
		"Item":
			UI.showItemPickup()
		"Skill":
			UI.showSkillDo()
		"NPC":
			UI.showNPCSpeak()
		"Object":
			UI.showObjectObserve()
		"_":
			UI.closeAllInteractUIs()	
		
		
func set_item_data(data):
	interact_type = data["type"]
	interact_name = data["name"]
	effect = data["effect"]
	sprite_preview = data["texture"]
