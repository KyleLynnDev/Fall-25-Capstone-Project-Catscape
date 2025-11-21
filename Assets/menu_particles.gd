extends Node2D
@onready var emitter: CPUParticles2D = $CPUParticles2D
@export var smooth := 1.0          # 1.0 = snap to mouse; 0.2 = smooth follow
@export var offset := Vector2.ZERO # optional cursor offset

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emitter.local_coords = false
	emitter.emitting = true

func _process(_delta):
	var m := get_viewport().get_mouse_position()
	global_position = (m + offset) if smooth >= 1.0 else global_position.lerp(m + offset, clampf(smooth, 0.0, 1.0))
