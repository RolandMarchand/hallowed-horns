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

var player = preload("res://scenes/entities/player.tscn")

var current_room: int

func _ready() -> void:
	# Disables all current rooms, except for starting one
	# Sets current_room to the spawning room ID
	for room in get_children():
		disable_room(room)
		if room.is_in_group("spawn"):
			current_room = room.id
	enable_room(find_room_id(current_room), find_room_id(current_room).spawn_point)

	for door in get_tree().get_nodes_in_group("doors"):
		door.connect("change_room", self, "change_room")

func disable_room(room: Node2D) -> void:
	room.hide()

	for p in get_tree().get_nodes_in_group("player"):
		if room.is_a_parent_of(p):
			p.queue_free()

func enable_room(room: Node2D, pos: Vector2) -> void:
	room.show()
	room.spawn_player(player.instance(), pos)

func find_room_id(id: int) -> Object:
	for room in get_children():
		if room.id == id:
			return room
	push_error("find_room_id: No room found.")
	return null

# Returns the room's node based on its ID
func find_door_id(room_id: int, door_id: int) -> Object:
	for door in get_tree().get_nodes_in_group("doors"):
		if find_room_id(room_id).is_a_parent_of(door) and door.id == door_id:
			return door
	push_error("find_door_id: No door found.")
	return null

func change_room(room: int, door: int, _node: Node = null) -> void:
	var room_node: Node = find_room_id(room)
	var spawning_door: Node = find_door_id(room, door)

	disable_room(find_room_id(current_room))
	enable_room(room_node, spawning_door.spawn_point)
	current_room = room_node.id
