extends Node2D

enum state {IDLE, PATH, CHASE}

signal send_target_info

export(state) var _current_state: int = state.IDLE
export var _vision_length: float = 50
export var _speed: float = 60

onready var _path_points: Array = get_node("PathPoints").get_children()
onready var _vision_ray: RayCast2D = get_node("Path2D/PathFollow2D/Body/VisionRay")
onready var _enemy: KinematicBody2D = get_node("Path2D/PathFollow2D/Body")
onready var _path: Path2D = get_node("Path2D")
onready var _path_follow: PathFollow2D = get_node("Path2D/PathFollow2D")
onready var _tween: Tween = get_node("Path2D/PathFollow2D/Tween")

var _curve: Curve2D = Curve2D.new()
var _player: KinematicBody2D setget set_player

func _ready() -> void:
	var _path_points_inverted: Array = _path_points.duplicate()
	_path_points_inverted.invert()
	
	for _point in _path_points:
		_curve.add_point(_point.global_position)
	for _point in _path_points_inverted:
		_curve.add_point(_point.global_position)
	#print(_curve.get_baked_points())
	_path.curve = _curve
	
	match _current_state:
		state.IDLE:
			pass
		state.PATH:
			_move_along_path()
		state.CHASE:
			_chase(_player)
		_:
			push_error("Invalid _current_state.")

func _physics_process(delta) -> void:
	emit_signal("send_target_info", self)
	if _player:
		_vision_ray.cast_to = (Vector2(_player.global_position) -
		_enemy.global_position).clamped(_vision_length)
	
	if _vision_ray.enabled and _vision_ray.get_collider():
		if _vision_ray.get_collider().is_in_group("player"):
			_player_detected()
			_vision_ray.enabled = false

func _chase(node: Node) -> void:
	pass


func _move_along_path() -> void:
	_enemy.global_position = global_position
	_tween.interpolate_property(_path_follow, "unit_offset", 0, 1,
	_find_transition_time(_speed, _curve.get_baked_length()))
	_tween.start()

func _find_transition_time(__speed: float, _length: float) -> float:
	return pow(__speed, -1) * _length

func _player_detected() -> void:
	print("detected")

func set_player(_set_player) -> void:
	_player = _set_player
