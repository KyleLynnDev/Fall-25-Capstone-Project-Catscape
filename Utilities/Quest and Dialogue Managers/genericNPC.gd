
## generic NPC, extend or copy this script. 

extends StaticBody3D

@export var questID := "main_quest"


func interact():
	if Dialogic.current_timeline != null:
		return
	var s = QuestManager.getState(questID)		
	var timeline = match s:
		QuestManager.QuestState.NOT_STARTED: ""
