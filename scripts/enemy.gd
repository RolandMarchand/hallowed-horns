extends Node2D

enum state {IDLE, PATH, CHASE}

export(state) var _current_state: int = state.IDLE
export var _vision_length: float = 50
export var _speed: float = 60

onready var _path_points: Array = get_node("PathPoints").get_children()
onready var _vision_ray: RayCast2D = get_node("Path2D/PathFollow2D/Body/VisionRay")
onready var _enemy: KinematicBody2D = get_node("Path2D/PathFollow2D/Body")
onready var _path: Path2D = get_node("Path2D")
onready var _path_follow: PathFollow2D = get_node("Path2D/PathFollow2D")
onready var _path_tween: Tween = get_node("Path2D/PathFollow2D/PathTween")
onready var _nav_tween: Tween = get_node("Path2D/PathFollow2D/NavTween")
onready var _timer: Timer = get_node("Path2D/PathFollow2D/Body/Timer")

var _navigation: Navigation2D setget set_navigation
var _navigation_path: PoolVector2Array = []
var _path_curve: Curve2D = Curve2D.new()
var _player: KinematicBody2D setget set_player

var _current_state_running: bool = false

func _ready() -> void:
	var _path_points_inverted: Array = _path_points.duplicate()
	_path_points_inverted.invert()
	
	# Loops all the points from PathPoints
	for _point in _path_points:
		_path_curve.add_point(_point.global_position)
	for _point in _path_points_inverted:
		_path_curve.add_point(_point.global_position)
	
# warning-ignore:return_value_discarded
	_timer.connect("timeout", self, "_update_navigation_path")

func _physics_process(_delta: float) -> void:
	if _navigation_path and not _current_state_running:
		match _current_state:
			state.IDLE:
				pass
			state.PATH:
				_move_along_path()
			state.CHASE:
				_chase()
			_:
				push_error("Invalid _current_state.")
		_current_state_running = true
	
	if _player:
		_vision_ray.cast_to = (Vector2(_player.global_position) -
		_enemy.global_position).clamped(_vision_length)
	
	if _vision_ray.enabled and _vision_ray.get_collider():
		if _vision_ray.get_collider().is_in_group("player"):
			_player_detected()
			_vision_ray.enabled = false

func _chase() -> void:
	var _current_pos: Vector2 = _enemy.global_position
	var _current_path: PoolVector2Array = _navigation_path
	while _current_path.size():
# warning-ignore:return_value_discarded
		_nav_tween.interpolate_property(_enemy, "global_position", _current_pos, _current_path[0],
		_find_transition_time(_speed, _current_pos.distance_to(_current_path[0])))
# warning-ignore:return_value_discarded
		_nav_tween.start()
		yield(_nav_tween, "tween_completed")
		_current_path.remove(0)
		_current_pos = _enemy.global_position
	_current_state_running = false

func _move_along_path() -> void:
	_path.curve = _path_curve
	_enemy.global_position = global_position
# warning-ignore:return_value_discarded
	_path_tween.interpolate_property(_path_follow, "unit_offset", 0, 1,
	_find_transition_time(_speed, _path_curve.get_baked_length()))
# warning-ignore:return_value_discarded
	_path_tween.start() # Loops, will never call signal tween_all_completed

## Gets called by _timer
func _update_navigation_path() -> void:
	if _player and _navigation:
		_navigation_path = _navigation.get_simple_path(_enemy.global_position,
		_player.global_position)
		_navigation_path.remove(0)

func _find_transition_time(__speed: float, _distance: float) -> float:
	return pow(__speed, -1) * _distance

func _player_detected() -> void:
# warning-ignore:return_value_discarded
	_path_tween.stop_all()
	_current_state = state.CHASE
	_current_state_running = false

## _player setter
func set_player(_set_player) -> void:
	_player = _set_player

func set_navigation(_set_navigation) -> void:
	_navigation = _set_navigation
