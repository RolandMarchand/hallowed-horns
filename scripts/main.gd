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

# Bug that switches room back and forth multiple times
# Pause game for combats

var current_room: int
var hide_rooms: bool = true

onready var gui = get_node("GUI")

func _ready() -> void:
	load_world(0)

# warning-ignore:return_value_discarded
	$Combat.connect("combat_over", self, "combat_over")

#	for room in $Rooms.get_children():
#		room.modulate = Color("#7fffffff")

	VisualServer.set_default_clear_color(Color("#ff5555"))

func unload_current_world():
	for node in $Rooms.get_children():
		get_tree().queue_delete(node)

func load_world(world: int) -> void:
	for room in GlobalWorld.global_world[world]:
		$Rooms.add_child(load(room).instance())

	# Disables all current rooms, except for starting one
	# Sets current_room to the spawning room ID
	for room in $Rooms.get_children():
		disable_room(room)
		if room.is_in_group("spawn"):
			current_room = room.id
	enable_room(find_room_id(current_room), find_door_id(current_room, 0))

	# Connects all signals
	for item in get_tree().get_nodes_in_group("items"):
		item.connect("picked_up", self, "_item_picked_up", [item])

	for door in get_tree().get_nodes_in_group("doors"):
		door.connect("change_room", self, "change_room")
		door.connect("locked", self, "door_locked")
		door.connect("unlocked", self, "door_unlocked")

	for enemy in get_tree().get_nodes_in_group("enemy_ai"):
		enemy.connect("enemy_touched_player", self, "enemy_touched_player")

func disable_room(room: Node2D) -> void:
	room.hide()
	room.disable_collisions()
	set_scene_process(room, false)
	room.set_pause(true)

func enable_room(room: Node2D, door: Area2D) -> void:
	room.show()
	room.enable_collisions()
	room.spawn(door)
	set_scene_process(room, true)
	room.set_pause(false)

# Pauses a scene and all of its children
func set_scene_process(node: Node, paused: bool) -> void:
	node.set_physics_process(paused)
	node.set_process(paused)
	node.set_process_input(paused)
	for child in node.get_children():
		set_scene_process(child, paused)

func find_room_id(id: int) -> Object:
	for room in $Rooms.get_children():
		if room.id == id:
			return room
	push_error("find_room_id: No room found.")
	return null

func find_door_id(room_id: int, door_id: int) -> Object:
	for door in get_tree().get_nodes_in_group("doors"):
		if find_room_id(room_id).is_a_parent_of(door) and door.id == door_id:
			return door
	push_error("find_door_id: No door found.")
	return null

# Huge mess about fading in and out

func change_room(room: int, door: int, _node: Node = null) -> void:
	var room_node: Node = find_room_id(room)
	var spawning_door: Node = find_door_id(room, door)

	disable_room(find_room_id(current_room))
	enable_room(room_node, spawning_door)
	current_room = room_node.id

func door_locked() -> void:
	gui.display_message("The door is locked.")

func door_unlocked(room: int, door: int) -> void:
	change_room(room, door)
	gui.display_message("The door is locked.\nBut you have the key.")

func _item_picked_up(type: int, value: int, message: String, _item: Node) -> void:
	match type:
		ItemLexicon.TYPE.KEY:
			PlayerStats.add_key(value)

			gui.display_message(message)

func enemy_touched_player():
	$Combat.new_combat(EnemyLexicon.Mouse.new())
#	PlayerStats.health -= 1
#	gui.damaged()
#	if PlayerStats.health < 1:
#		_death()

func combat_over():
	pass

func _death():
	gui.display_message("You have died.\nThe level will restart...")
	yield(gui, "text_displayed")
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
