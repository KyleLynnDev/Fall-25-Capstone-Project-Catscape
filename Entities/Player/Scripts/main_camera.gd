extends Camera3D

@export_group("Camera movement variables")
@export var cam_move_speed : float = 20.0;
@export var min_elevation_angle : int = 10;
@export var max_elevation_angle : int = 80;
@export var rotation_speed : float = 2.0;


#flags
@export var allow_rotation : bool = true;
@export var invertedY : bool = false;
@export var zoomToCursor : bool = false; 


#movement vars
var _last_mouse_position := Vector2();
var _is_rotating : bool = false;
var look_direction := Vector2.ZERO;
var mouse_sensitivity : float = 0.00075; 


#zoom vars
var _zoom_direction = 0;
@export var minZoom : int = 5;
@export var maxZoom : int = 30; 
@export var zoomSpeed : float = 20.0;
@export var zoomSpeedDamp : float = 0.6;

@export var invert_y: bool = false
@onready var camera_pivot: Node3D = %CameraPivot
@onready var spring_arm: SpringArm3D = %SpringArm3D

var yaw = 0.0;
var pitch = 0.0;

func _ready() -> void:
	yaw = rotation.y
	pitch = rotation.x


func _unhandled_input(event: InputEvent) -> void:
	
	# are we rotating camera at all 
	if (event.is_action_pressed("cameraRotate")):  
		_is_rotating = true;
		_last_mouse_position = get_viewport().get_mouse_position();
	if (event.is_action_released("cameraRotate")):
		_is_rotating = false;
			
	#mouse input
	#if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
	#	look_direction.x -= event.relative.x * rotation_speed;
	#	look_direction.y -= event.relative.y * rotation_speed * (-1 if invert_y else 1); 
			
			
	# are we zooming 
	if (event.is_action_pressed("cameraZoomIn")):
		_zoom_direction = -1;
	if (event.is_action_pressed("cameraZoomIn")):
		_zoom_direction = 1; 
		



func _process(delta: float) -> void:
	#handle_gamepad_input(delta);
	#update_camera_rotation()
	_rotate(delta);
	_zoom(delta);
	
	
	
func handle_gamepad_input(delta):
	var input_x = Input.get_action_strength("lookRight") - Input.get_action_strength("lookLeft");
	var input_y = Input.get_action_strength("lookUp") - Input.get_action_strength("lookDown");
	
	look_direction.x -= input_x * rotation_speed * delta * 100.0;
	look_direction.y -= input_y * rotation_speed * delta * 100.0 *(-1 if invert_y else 1);
	
	var zoom_trigger = Input.get_action_strength("cameraZoomIn") -  Input.get_action_strength("cameraZoomOut")
	if zoom_trigger != 0.0:
		spring_arm.length = clamp(spring_arm.length - zoom_trigger * zoomSpeed * delta * 10.0, minZoom, maxZoom)


	
func _rotate(delta):
	if not _is_rotating or not allow_rotation:
		return;
	var displacement = _get_mouse_displacement();
	_rotate_left_right(delta, displacement.x);
	_elevate(delta, -displacement.y);
	
	
	
func _zoom(delta):
	var newZoom = clamp(position.z + zoomSpeed * delta * _zoom_direction, minZoom, maxZoom);
	position.z = newZoom;
	_zoom_direction *= zoomSpeedDamp;
	if abs(_zoom_direction) <= 0.0001:
		_zoom_direction = 0; 	
		
	
	
	
func _get_mouse_displacement() -> Vector2:
	var current_mouse_position = get_viewport().get_mouse_position();
	var displacement = current_mouse_position - _last_mouse_position;
	_last_mouse_position = current_mouse_position;
	return displacement; 
	
	
	
func _rotate_left_right(delta: float, val: float):
	camera_pivot.rotation_degrees.y -= val * delta * rotation_speed * mouse_sensitivity;
	
	
	
func _elevate(delta: float, val: float):
	var newElevation = camera_pivot.rotation_degrees.x + val * delta * rotation_speed; 
	newElevation = clamp(newElevation, -max_elevation_angle, -min_elevation_angle);
	camera_pivot.rotation_degrees.x = newElevation;
	
func update_camera_rotation():
	look_direction.y = clamp(look_direction.y, deg_to_rad(-60), deg_to_rad(60))
	rotation_degrees = Vector3(rad_to_deg(look_direction.y), rad_to_deg(look_direction.x), 0)
	
	
