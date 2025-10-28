extends Control

func _ready(): 
	$VBoxContainer/Master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$VBoxContainer/SFX.value = db_to_linear(AudioServer.get_bus_volume_db(1))

func _process(delta):
	release_focus() 

func _on_sfx_mouse_exited() -> void:
	release_focus() 

func _on_master_mouse_exited() -> void:
	release_focus() 
