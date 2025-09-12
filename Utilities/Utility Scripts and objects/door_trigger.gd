extends Area3D

@export var transitionFade : ColorRect
@export var nextScenePATH : String 
@export var positionToSpawn : Vector3


func _on_body_entered(body: Node3D) -> void:
	print(body)
	
	if body.is_in_group("Player"):
		Global.wherePlayerShouldSpawn = positionToSpawn;
		transitionFade.transitionTo(nextScenePATH); 
