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
extends Area2D

signal player_detected

onready var vision_ray = $RayCast2D
onready var tween = $Tween

var stats: Object = EnemyLexicon.Goblin.new()
var player: KinematicBody2D
var navigation_path: PoolVector2Array = []

export(int, "Idle", "Path", "Chase") var state = 0
export(int) var vision_length: int = stats.vision_length
export(float) var speed: float = stats.walk_speed
export(bool) var loop_path: bool = false

func _physics_process(_delta: float) -> void:
	if player:
		vision_ray.cast_to = (Vector2(player.global_position) - self.global_position).clamped(vision_length)

	if vision_ray.enabled and vision_ray.get_collider():
		if vision_ray.get_collider().is_in_group("player"):
			emit_signal("player_detected", self, player)
			vision_ray.enabled = false

func get_points() -> Array:
	return $Points.get_children()
