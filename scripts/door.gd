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
export(ItemLexicon.KEY) var key_required = ItemLexicon.KEY.BRONZE

onready var spawn_point: Vector2 = $Position2D.global_position

func _on_Door_body_entered(_body):
	if is_locked:
		if PlayerStats.has_key(key_required):
			is_locked = false
			emit_signal("unlocked")
			_on_Door_body_entered(_body)
			print("lmao")
		else:
			emit_signal("locked")
			print("lmao")
	else:
		emit_signal("change_room", leads_to_room, leads_to_door)
