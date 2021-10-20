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
extends Node2D

signal initialized

export(int) var id: int

func spawn_player(player: KinematicBody2D, spawn: Vector2) -> void:
	$Walls.call_deferred("add_child", player)

	player.call_deferred("set_global_position", spawn)
	emit_signal("initialized")

# pause setter
func set_pause (is_paused: bool) -> void:
	for entity in $Walls.get_children():
		if entity.has_method("set_pause"):
			entity.set_pause(is_paused)
