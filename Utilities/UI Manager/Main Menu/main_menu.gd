extends Node3D

const MenuParticlesScene := preload("res://Assets/MenuParticles.tscn")

@onready var start_game: Button = $"CanvasLayer/VBoxContainer/Start Game"
@onready var transition = $CanvasLayer/SceneTransitionRect
@onready var ui_layer: CanvasLayer = $CanvasLayer

var rotation_speed = 0.10
var menu_particles: Node2D


func _ready() -> void:
	start_game.grab_focus()
	menu_particles = MenuParticlesScene.instantiate()
	ui_layer.add_child(menu_particles)
	menu_particles.position = get_viewport().get_visible_rect().size / 2.0
	menu_particles.get_node("CPUParticles2D").emitting = true


func _process(delta):
	$Camera3D.rotate_y(rotation_speed * delta)



func _on_start_game_pressed():
	print("Starting Game")
	transition.transitionTo("res://World/GameWorld.tscn")
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
