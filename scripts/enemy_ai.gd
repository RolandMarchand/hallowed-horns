# This file is part of Hallowed Horns.
#
# Hallowed Horns is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Hallowed Horns is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Hallowed Horns.  If not, see <https://www.gnu.org/licenses/>.
extends Navigation2D

# TODO:
# 1) Free the AI when the enemy dies
# 2) Stop relying on _physic_process() for switching states, find a new model
# 3) Find a way to export the navigation polygon and the remotetransform2d remote path

enum STATE {IDLE, PATH, CHASE}

export(STATE) var _current_state: int = STATE.IDLE setget set_current_state
export var _vision_length: float = 50 # Pixels
export var _speed: float = 32 # Pixels / second
export(bool) var _looping_path: bool = false

onready var _is_ready: bool = true
onready var _path_points: Array = get_node("PathPoints").get_children()
onready var _vision_ray: RayCast2D = get_node("Path2D/PathFollow2D/RemoteEnemy/RayCast2D")
onready var remote_enemy: RemoteTransform2D = get_node("Path2D/PathFollow2D/RemoteEnemy")
onready var _path: Path2D = get_node("Path2D")
onready var _path_follow: PathFollow2D = get_node("Path2D/PathFollow2D")
onready var _path_tween: Tween = get_node("Path2D/PathFollow2D/PathTween")
onready var _nav_tween: Tween = get_node("Path2D/PathFollow2D/NavTween")
onready var _timer: Timer = get_node("Timer")

var pause: bool setget set_pause
var _references_set: bool = false
var _navigation_path: PoolVector2Array = []
var _path_curve: Curve2D = Curve2D.new()
var _player: KinematicBody2D

func _ready() -> void:
	# Loops all the points from PathPoints
	for point in _path_points:
		_path_curve.add_point(point.global_position)
	
	if not _looping_path: # Follow back the path
		var _path_points_inverted: Array = _path_points.duplicate()
		_path_points_inverted.invert()
		
		for point in _path_points_inverted:
			_path_curve.add_point(point.global_position)
		
	else: # Goes back to the first point
		_path_curve.add_point(_path_points[0].global_position)
	
# warning-ignore:return_value_discarded
	_timer.connect("timeout", self, "_update_navigation_path")

func _physics_process(_delta: float) -> void:
	if _player:
		_vision_ray.cast_to = (Vector2(_player.global_position) -
		remote_enemy.global_position).clamped(_vision_length)
	
	if _vision_ray.enabled and _vision_ray.get_collider():
		if _vision_ray.get_collider().is_in_group("player"):
			_player_detected()
			_vision_ray.enabled = false
	
	match _current_state:
		STATE.IDLE:
			pass
		STATE.PATH:
			if not _path_tween.is_active():
				_move_along_path()
		STATE.CHASE:
			if not _nav_tween.is_active():
				_chase()

func _chase() -> void:
	_update_navigation_path()
	var _current_pos: Vector2 = remote_enemy.global_position
	var _current_path: PoolVector2Array = _navigation_path
	while _current_path.size():
# warning-ignore:return_value_discarded
		_nav_tween.interpolate_property(remote_enemy, "global_position", _current_pos, _current_path[0],
		_find_transition_time(_speed, _current_pos.distance_to(_current_path[0])))
# warning-ignore:return_value_discarded
		_nav_tween.start()
		yield(_nav_tween, "tween_completed")
		_current_path.remove(0)
		_current_pos = remote_enemy.global_position

func _move_along_path() -> void:
	_path.curve = _path_curve
	remote_enemy.global_position = global_position
# warning-ignore:return_value_discarded
	_path_tween.interpolate_property(_path_follow, "unit_offset", 0, 1,
	_find_transition_time(_speed, _path_curve.get_baked_length()))
# warning-ignore:return_value_discarded
	_path_tween.start() # Loops, will never call signal tween_all_completed

## Gets called by _timer
func _update_navigation_path() -> void:
	if _player:
		_navigation_path = get_simple_path(remote_enemy.global_position,
		_player.global_position)
		_navigation_path.remove(0)

func _find_transition_time(speed: float, distance: float) -> float:
	return pow(speed, -1) * distance

func _player_detected() -> void:
# warning-ignore:return_value_discarded
	set_current_state(STATE.CHASE)

func set_references(new_player: KinematicBody2D) -> void:
	_player = new_player
	_references_set = true

## _current_state setter
func set_current_state(new_state: int) -> void:
	_reset_state()
	_current_state = new_state
	
func _reset_state() -> void:
	if _references_set:
		_navigation_path = []
	# warning-ignore:return_value_discarded
		_path_tween.stop_all()
	# warning-ignore:return_value_discarded
		_nav_tween.stop_all()

## pause setter
func set_pause(is_paused: bool) -> void:
	if is_paused:
		_nav_tween.stop_all()
		_path_tween.stop_all()
	else:
		_nav_tween.start()
		_path_tween.start()
