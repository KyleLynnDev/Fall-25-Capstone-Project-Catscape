extends Area3D

@export var use_once := false
@export var preciseLocationOfSpawn : Vector3 = self.global_position

var pos = $".".global_position

var _used := false

func _ready() -> void:
	pos = $".".global_position
	print(pos)
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node3D) -> void:
	if _used and use_once:
		return
	if not body.is_in_group("Player"):
		return

	if (Global.checkpointPosition == pos):
		return
	Global.setCheckpoint(pos)
	Global.say_quick("Checkpoint reached at " + str(pos))
	_used = true

	# Optional: visual/audio feedback here

	if use_once:
		queue_free()
