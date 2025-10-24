# OneShotDialogTrigger.gd
extends Area3D

## The line (or timeline text block) to run.
@export_multiline var dialog_text := "This is a default one time trigger "
@export var oneTime : bool = false;

## The group your player is in (change to match your project).
@export var player_group := "Player"

var _fired := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if _fired:
		return
	if not body.is_in_group(player_group):
		return
	_fired = true

	# Build and start a timeline on the fly from a plain string.
	Global.say_quick(dialog_text)

	# Make sure we won't retrigger, then remove this trigger.
	monitoring = false
	set_deferred("monitoring", false)
	
	if (oneTime):
		queue_free()
