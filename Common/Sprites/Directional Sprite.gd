extends Sprite3D

@export var camera_path: NodePath
#@export var hframes := 4 # number of frames per animation (e.g. walk has 4 frames)
#@export var vframes := 4 # number of directions
@export var animation_speed := 6.0 # frames per second

enum Direction { FRONT, RIGHT, BACK, LEFT }

var camera: Camera3D
var current_direction: Direction = Direction.FRONT
var is_walking: bool = false

var frame_timer := 0.0
var current_anim_frame := 0

func _ready():
	camera = get_node_or_null(camera_path)
	if not camera:
		camera = get_viewport().get_camera_3d()
	set_sprite_frame(0, current_direction)

func _process(delta):
	if not camera:
		return

	update_direction()
	update_animation(delta)

func update_direction():
	var to_camera = (camera.global_transform.origin - global_transform.origin).normalized()
	var forward = -global_transform.basis.z.normalized()

	var angle = atan2(to_camera.x, to_camera.z) - atan2(forward.x, forward.z)
	angle = wrapf(angle, -PI, PI)

	var dir: Direction
	if abs(angle) < PI * 0.25:
		dir = Direction.FRONT
	elif abs(angle) > PI * 0.75:
		dir = Direction.BACK
	elif angle > 0:
		dir = Direction.RIGHT
	else:
		dir = Direction.LEFT

	if dir != current_direction:
		current_direction = dir
		current_anim_frame = 0  # Reset animation when direction changes
		frame_timer = 0.0

func update_animation(delta):
	# In a real project, you'd determine walking by checking velocity
	is_walking = true  # Replace with actual logic later

	if is_walking:
		frame_timer += delta
		if frame_timer >= 1.0 / animation_speed:
			frame_timer = 0.0
			current_anim_frame = (current_anim_frame + 1) % hframes
	else:
		current_anim_frame = 0  # idle pose

	set_sprite_frame(current_anim_frame, current_direction)

func set_sprite_frame(x: int, dir: Direction):
	frame_coords = Vector2i(x, int(dir))
