#quest manager 

extends Node

enum QuestState{ NOT_STARTED, STARTED, HAS_ITEM, COMPLETE};

#This dictionary holds all quests, their name as key and status
var quests := {
	
	"main_quest" : QuestState.NOT_STARTED,
	"side_quest_one" : QuestState.NOT_STARTED,
}

const SAVE_PATH = "user://save.json";




func _ready() -> void:
	loadGame()
		
	#mirror dialogic variables 
	
	for id in quests.keys():
		Dialogic.VAR.set("quests." +id, quests[id])
	
	Dialogic.signal_event.connect(onDialogicSignal)
	
	Dialogic.timeline_ended.connect(func():
		saveGame()
	)
	
	
	
func getState(id:String) -> int:
	return quests.get(id, QuestState.NOT_STARTED)
	
	
	
func setState(id:String, state:int) -> void:
	quests[id] = state
	Dialogic.VAR.set("quests."+id, state)
	saveGame()
	
	
	
func advanceQuest(id:String, toState:int) -> void:
	if toState > getState(id):
		setState(id, toState)
	
	
	
func saveGame():
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({"quests": quests}))
		file.close()
	
	
	
func loadGame():
	if not FileAccess.file_exists(SAVE_PATH):
		print("file does not exist")
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file: 
		return
		
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if typeof(data) == TYPE_DICTIONARY and data.has("quests"):
		quests = data.quests



func onDialogicSignal(arg:String):
	match arg:
		"main_quest_started":
			advanceQuest("main_quest", QuestState.STARTED)
		"main_quest_has_item":
			advanceQuest("main_quest", QuestState.HAS_ITEM)
		"main_quest_has_completed":
			advanceQuest("main_quest", QuestState.COMPLETE)
