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
# 4) connect AI to body
# 5) Make so we only need 1 AI to control all the enemies
enum {IDLE, PATH, CHASE}

onready var _timer: Timer = get_node("Timer")
onready var _navigation = self

var player: KinematicBody2D
var _movement_preload: Resource = preload("res://scenes/entities/enemy/enemy_movement.tscn")
var path_of: Dictionary = {}
var enemy_array: Array = []
var navigation: Navigation2D = self

func _ready() -> void:
	_update_navigation_path()
	_record_path_curves()
	_timer.connect("timeout", self, "_update_navigation_path")
	
	yield(get_parent(), "ready")
	_record_enemies()
	for enemy in enemy_array:
		change_state(enemy)

func _record_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy_bodies"):
		if get_parent().is_a_parent_of(enemy):
			var movement = _movement_preload.instance()
			add_child(movement)
			
			enemy_array.append(enemy)
			
			path_of[enemy] = movement
			
			enemy.connect("player_detected", self, "_enemy_spotted_player")

#
#
#export(STATE) var _current_state: int = STATE.IDLE setget set_current_state
#export var _vision_length: float = 50 # Pixels
#export var _speed: float = 32 # Pixels / second
#export(bool) var _looping_path: bool = false
#
#onready var _is_ready: bool = true
#onready var _path_points: Array = get_node("PathPoints").get_children()
#onready var _vision_ray: RayCast2D = get_node("Path2D/PathFollow2D/RemoteEnemy/RayCast2D")
#onready var remote_enemy: RemoteTransform2D = get_node("Path2D/PathFollow2D/RemoteEnemy")
#onready var _path: Path2D = get_node("Path2D")
#onready var _path_follow: PathFollow2D = get_node("Path2D/PathFollow2D")
#onready var _path_tween: Tween = get_node("Path2D/PathFollow2D/PathTween")
#onready var _nav_tween: Tween = get_node("Path2D/PathFollow2D/NavTween")
#onready var _timer: Timer = get_node("Timer")
#
#var pause: bool setget set_pause
#var _references_set: bool = false
#var _navigation_path: PoolVector2Array = []
#var _path_curve: Curve2D = Curve2D.new()
#
func _record_path_curves() -> void:
	for enemy in enemy_array:
		var path_points = enemy.get_points()
		var path: Curve2D = Curve2D.new()
		
		for point in path_points:
			path.path_curve.add_point(point.global_position)
		
		if enemy.loop_path: # Goes back to the first point
			path.path_curve.add_point(path_points[0].global_position)
			
		else: # Follows back the path
			var path_points_inverted: Array = path.path_curve.duplicate()
			path_points_inverted.invert()
			
			for point in path_points_inverted:
				path.path_curve.add_point(point.global_position)
		
		path_of[enemy].curve = path

func change_state(enemy: Node) -> void:
	match enemy.state:
		IDLE:
			pass
		PATH:
			_move_along_path(enemy)
		CHASE:
			_chase(enemy)
	
func _chase(enemy: Node) -> void:
	var current_pos: Vector2 = enemy.global_position
	var current_path: PoolVector2Array = enemy.navigation_path
	
	while current_path.size():
# warning-ignore:return_value_discarded
		enemy.tween.interpolate_property(enemy, "global_position", current_pos, current_path[0],
		_find_transition_time(enemy.speed, current_pos.distance_to(current_path[0])))

# warning-ignore:return_value_discarded
		enemy.tween.start()
		yield(enemy.tween, "tween_all_completed")

		current_path.remove(0)
		current_pos = enemy.global_position
	
	change_state(enemy)

## Gets called by _timer
func _update_navigation_path() -> void:
	for enemy in enemy_array:
		var navigation_path := PoolVector2Array(get_simple_path(enemy.global_position,
				player.global_position))
		navigation_path.remove(0)
			
		enemy.navigation_path = navigation_path


func _move_along_path(enemy: Node) -> void:
	var path = path_of[enemy]
	#enemy.global_position = global_position
	
# warning-ignore:return_value_discarded
	path.tween.interpolate_property(path.follow, "unit_offset", 0, 1,
	_find_transition_time(enemy.speed, path.get_baked_length()))
	
# warning-ignore:return_value_discarded
	path.tween.start()
	yield(path.tween, "tween_all_completed")
	
	change_state(enemy)


func _find_transition_time(speed: float, distance: float) -> float:
	return pow(speed, -1) * distance

func _enemy_spotted_player(enemy: Node, player: Node) -> void:
# warning-ignore:return_value_discarded
	pass#set_current_state(STATE.CHASE)

#func _on_enemy_body_entered(player: Node, body: Node):
#	body.call_deferred("queue_free")
#	self.call_deferred("queue_free")
#
#func set_references(new_player: KinematicBody2D) -> void:
#	_player = new_player
#	_references_set = true
#
### _current_state setter
#func set_current_state(new_state: int) -> void:
#	_reset_state()
#	_current_state = new_state
#
#func _reset_state() -> void:
#	if _references_set:
#		_navigation_path = []
#	# warning-ignore:return_value_discarded
#		_path_tween.stop_all()
#	# warning-ignore:return_value_discarded
#		_nav_tween.stop_all()
#
### pause setter
#func set_pause(is_paused: bool) -> void:
#	if is_paused:
#		_nav_tween.stop_all()
#		_path_tween.stop_all()
#	else:
#		_nav_tween.start()
#		_path_tween.start()
#
#func get_enemy_body_node() -> Node:
#	return get_node(remote_enemy.remote_path)
