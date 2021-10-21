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

# Bug with the default state of chasing,
# the enemy doesn't go straight to the player

# Feature, add pauses between points of path

signal enemy_touched_player

enum {IDLE, PATH, CHASE}

export(float) var _nav_poly_update_time: float = 0.1

onready var _timer: Timer = $Timer
onready var _navigation = self

var curve_of: Dictionary = {}
var enemy_array: Array = []
var navigation: Navigation2D = self

func _ready() -> void:
	yield(get_parent().get_parent(), "initialized")
	_create_timer()
	_record_enemies()
	_record_curve_paths()
	_update_navigation_path()
	for enemy in enemy_array:
		change_state(enemy)

func _create_timer() -> void:
	_timer.wait_time = _nav_poly_update_time
# warning-ignore:return_value_discarded
	_timer.connect("timeout", self, "_update_navigation_path")

func _record_enemies() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if get_parent().is_a_parent_of(enemy):

			enemy_array.append(enemy)

			enemy.connect("player_detected", self, "_enemy_spotted_player")
			enemy.connect("body_entered", self, "_enemy_touched_player", [enemy])

func _record_curve_paths() -> void:
	for enemy in enemy_array:
		var path_points = enemy.get_points()
		var path: Curve2D = Curve2D.new()

		for point in path_points:
			path.add_point(point.global_position)

		if enemy.walk_back: # Goes back to the first point
			path.add_point(path_points[0].global_position)
		else: # Follows back the path
			var path_points_inverted: PoolVector2Array = path.get_baked_points()
			path_points_inverted.invert()

			for point in path_points_inverted:
				path.add_point(point)

		curve_of[enemy] = path

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
		# Reminder that get_simple_path returns local coordinates
		var navigation_path: Array = get_simple_path(enemy.position,
				to_local(PlayerStats.global_position))
		navigation_path.remove(0)

		# Globalizes each coordinate
		for point in range(navigation_path.size()):
			navigation_path[point] = to_global(navigation_path[point])

		enemy.navigation_path = navigation_path
		navigation_path.append(enemy.global_position)

func _move_along_path(enemy: Node) -> void:
	var path: Curve2D = curve_of[enemy]

	for point in range(path.get_point_count() - 1):
		enemy.tween.interpolate_property(
				enemy,
				"global_position",
				path.get_point_position(point),
				path.get_point_position(point + 1),
				_find_transition_time(
						enemy.speed,
						path.get_point_position(point).distance_to(path.get_point_position(point + 1))
						)
				)
		enemy.tween.start()
		yield(enemy.tween, "tween_all_completed")
	change_state(enemy)

func _find_transition_time(speed: float, distance: float) -> float:
	return pow(speed, -1) * distance

func _enemy_spotted_player(enemy: Node, _current_player: Node) -> void:
# warning-ignore:return_value_discarded
	enemy.state = CHASE

	# remove_all and stop_all did not work
	var new_tween: Tween = Tween.new()
	enemy.tween.queue_free()
	enemy.add_child(new_tween)
	enemy.tween = new_tween

	change_state(enemy)

func _enemy_touched_player(_player: Node, enemy: Node) -> void:
	enemy_array.erase(enemy)
	enemy.call_deferred("queue_free")

	emit_signal("enemy_touched_player", enemy)
