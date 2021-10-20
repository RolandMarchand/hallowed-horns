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

# Pause game for combats

var current_floor: Node2D
var current_room: int
var floor_list: Dictionary = {
		0: preload("res://floor0.tscn")
}

onready var gui = get_node("GUI")

func _ready() -> void:
# warning-ignore:return_value_discarded
	$Combat.connect("combat_over", self, "combat_over")

	VisualServer.set_default_clear_color(Color("#ff5555"))

	change_world(0)


func change_world(world: int) -> void:
	# Unloads
	for f in get_tree().get_nodes_in_group("floor"):
		f.queue_free()

	# Loads
	var new_floor: Node2D = floor_list[world].instance()
	add_child(new_floor)
	current_floor = get_tree().get_nodes_in_group("floors")[0]

	# Connects all signals
	for item in get_tree().get_nodes_in_group("items"):
		item.connect("picked_up", self, "_item_picked_up", [item])

	for enemy in get_tree().get_nodes_in_group("enemy_ai"):
		enemy.connect("enemy_touched_player", self, "enemy_touched_player")

	for door in get_tree().get_nodes_in_group("doors"):
		door.connect("locked", self, "door_locked")
		door.connect("unlocked", self, "door_unlocked")

## Pauses a scene and all of its children
## Useless for now
func set_scene_process(node: Node, paused: bool) -> void:
	node.set_physics_process(paused)
	node.set_process(paused)
	node.set_process_input(paused)
	node.set_process_unhandled_input(paused)
	node.set_process_unhandled_key_input(paused)
	for child in node.get_children():
		set_scene_process(child, paused)

func door_locked() -> void:
	gui.display_message("The door is locked.")

func door_unlocked() -> void:
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
	#yield(gui, "text_displayed")
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
