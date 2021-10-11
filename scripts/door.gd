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

signal locked
signal unlocked
signal change_room

export var leads_to_room: int
export var leads_to_door: int
export var id: int
export var is_locked: bool = false
export(ItemDict.KEY) var key_required = ItemDict.KEY.BRONZE
export(int, FLAGS, "Walls", "Player", "Entities", "Doors") var _protected_layers = 0 setget ,get_protected_layers
export(int, FLAGS, "Walls", "Player", "Entities", "Doors") var _protected_masks = 0 setget ,get_protected_masks

onready var spawn_point: Vector2 = $Respawn.global_position

func _on_Door_body_entered(_body):
	if is_locked:
		if PlayerStats.has_key(key_required):
			emit_signal("unlocked", leads_to_room, leads_to_door)
			is_locked = false
		else:
			emit_signal("locked")
	else:
		emit_signal("change_room", leads_to_room, leads_to_door)

func get_protected_layers() -> int:
	return _protected_layers

func get_protected_masks() -> int:
	return _protected_masks
