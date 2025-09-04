extends BaseScreen

@onready var resume: Button = $VBoxContainer/Resume

func open(args := {}) -> void:
	visible = true
	resume.grab_focus()
	
func close() -> void:
	visible = false
	
func _on_Resume_pressed()-> void:
	#UIManager.pop()
	pass
	
func on_quit_Button_pressed() -> void:
	#TODO swap to title screen
	get_tree().paused = false
	#get_tree().change_scene_to_file( [route to title screen scene])
	
func handle_back() -> bool:
	#UIManager.pop()
	return true
	
