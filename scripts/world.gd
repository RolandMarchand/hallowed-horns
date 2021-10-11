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
extends Node

var loaded_rooms: Array = []

# {level : room}
var global_world := {
	0: ["res://scenes/rooms/world0/room0.tscn",
			"res://scenes/rooms/world0/room1.tscn",
			"res://scenes/rooms/world0/room2.tscn",]
}

func _ready() -> void:
	load_new_world(0)

func _on_Timer_timeout() -> void:
	print("Hello")

func load_new_world(world: int = 0):
	loaded_rooms = []
	for room in GlobalWorld.global_world[world]:
		loaded_rooms.append(load(room).instance())
