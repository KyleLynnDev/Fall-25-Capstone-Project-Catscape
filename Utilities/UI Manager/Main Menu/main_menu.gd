extends Node3D

@onready var start_game: Button = $"CanvasLayer/VBoxContainer/Start Game"
@onready var transition = $CanvasLayer/SceneTransitionRect

var rotation_speed = 0.10

func _ready() -> void:
	start_game.grab_focus()

func _process(delta):
	$Camera3D.rotate_y(rotation_speed * delta)

func _on_start_game_pressed():
	transition.transitionTo("res://World/GameWorld.tscn")
	#get_tree().change_scene_to_file("res://World/GameWorld.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
