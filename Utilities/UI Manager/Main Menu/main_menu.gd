extends Node3D

@onready var start_game: Button = $"CanvasLayer/VBoxContainer/Start Game"
@onready var transition = $CanvasLayer/SceneTransitionRect

var rotation_speed = 0.10



func _ready() -> void:
	start_game.grab_focus()



func _process(delta):
	$Camera3D.rotate_y(rotation_speed * delta)



func _on_start_game_pressed():
	print("Starting Game")
	transition.transitionTo("res://World/Test Tut Level.tscn")
	#get_tree().change_scene_to_file("res://World/GameWorld.tscn") ## old way of transitioning screen



func _on_exit_pressed() -> void:
	print("Exiting game")
	get_tree().quit()



func _on_credits_pressed() -> void:
	### [TODO]
	print("Here is where credits will go hehe")
	pass # Replace with function body.
	


### This is for the extra debugging buttons	



func _on_cave_pressed() -> void:
	print("Opening Cave Level")
	transition.transitionTo("res://World/CaveLevel.tscn")


func _on_overworld_pressed() -> void:
	print("Opening Overworld")
	transition.transitionTo("res://World/GameWorld.tscn")


func _on_test_level_pressed() -> void:
	print("Opening Test Playground")
	transition.transitionTo("res://World/TestScenePlayground.tscn")
