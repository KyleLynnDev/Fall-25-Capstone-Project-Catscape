extends "res://Utilities/Utility Scripts and objects/one_time_trigger.gd"



func _on_body_entered(body: Node3D) -> void:
	if _fired:
		return
	if not body.is_in_group(player_group):
		return
	_fired = true

	# Build and start a timeline on the fly from a plain string.
	Global.say_quick("Key aquired!")
	Global.keys += 1

	# Make sure we won't retrigger, then remove this trigger.
	monitoring = false
	set_deferred("monitoring", false)
	queue_free()
