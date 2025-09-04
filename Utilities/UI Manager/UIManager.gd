## UIManager.gd

extends Control

class_name UIManager

enum Screen { NONE, MAP, INVENTORY, PAUSE, QUEST}

@onready var pause: Control = %Pause
@onready var inventory: Control = %Inventory
@onready var map: Control = %Map
@onready var quest_log: Control = %QuestLog
@onready var interact_ui: Control = %InteractUI

@onready var item_pickup: ColorRect = %InteractUI/ItemPickup
@onready var skill_use: ColorRect = %InteractUI/SkillUse
@onready var npc_talk: ColorRect = %InteractUI/NPCTalk
@onready var object_observe: ColorRect = %InteractUI/ObjectObserve



var current : int = Screen.NONE;

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	#print(map, inventory, pause, quest_log)
	print(item_pickup, skill_use, npc_talk, object_observe)

	
	
func _hide_all():
	for s in [map, inventory, pause, quest_log]:
		s.visible = false
		current = Screen.NONE
		_apply_pause_state()
	
	
func toggle(screen : int) -> void:
	print(current, screen)
	if (current == screen):
		_hide_all()
		Global.canMove = true; 
		print("closing", current)
	else:
		print ("showing", screen)
		Global.canMove = false; 
		_show_only(screen)
	
	
func toggle_map() -> void:
	toggle(Screen.MAP)
	
func toggle_inventory() -> void:
	#get_tree().paused = !get_tree().paused
	toggle(Screen.INVENTORY)
	
	
func toggle_pause() -> void:
	toggle(Screen.PAUSE)
	
func toggle_quest() -> void:
	toggle(Screen.QUEST)
	


func close_all() -> void:
	_hide_all()
	 
	
func _show_only(screen: int) -> void:
	_hide_all()
	match screen:
		Screen.MAP:
			map.visible = true
			current = 1
		Screen.INVENTORY:
			inventory.visible = true
			current = 2
		Screen.PAUSE:
			pause.visible = true
			current = 3
		Screen.QUEST:
			quest_log.visible = true
			current = 4
	#_apply_pause_state() 
	
	
	
func _apply_pause_state():
	var shouldPause := (current == Screen.PAUSE)
	get_tree().paused = shouldPause
	
func showItemPickup():
	print(" item pick up should be visible")
	item_pickup.visible = true
	
func showObjectObserve():
	print(" observe object up should be visible")
	object_observe.visible = true
	
func showNPCSpeak():
	print(" npc speak should be visible")
	npc_talk.visible = true
	
func showSkillDo():
	print(" skill should be visible")
	skill_use.visible = true
	
func closeAllInteractUIs():
	item_pickup.hide()
	skill_use.hide()
	npc_talk.hide()
	object_observe.hide()
	
	
