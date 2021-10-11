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

# TODO:
# 1) Define multiple respawn points

export(int) var id: int
onready var _player: KinematicBody2D = get_node("Walls/Player")
onready var _enemy_ai_dict: Dictionary = {}

var pause: bool setget set_pause
var _saved_layers: Dictionary
var _saved_masks: Dictionary

func _ready() -> void:
	for ai in get_tree().get_nodes_in_group("enemy_ai"):
		if self.is_a_parent_of(ai):
			ai.player = _player

func spawn(door: Area2D):
	_player.global_position = door.spawn_point

func enable_collisions() -> void:
	_ec(self)
func _ec(node) -> void:
	for child in node.get_children():
		if "collision_layer" in child:
			child.collision_layer = _saved_layers[child]
		
		if "collision_mask" in child:
			child.collision_mask = _saved_masks[child]
		
		_ec(child)

func disable_collisions() -> void:
	_save_collisions()
	_dc(self)
func _dc(node: Node) -> void:
	for child in node.get_children():
		if "collision_layer" in child:
			if child.has_method("get_protected_layers"):
				child.collision_layer = child.get_protected_layers()
			else:
				child.collision_layer = 0
		
		if "collision_mask" in child:
			if child.has_method("get_protected_masks"):
				child.collision_mask = child.get_protected_masks()
			else:
				child.collision_mask = 0
		
		_dc(child)

func _save_collisions() -> void:
	_sc(self)
func _sc(node: Node) -> void:
	for child in node.get_children():
		if "collision_layer" in child:
			_saved_layers[child] = child.collision_layer
		
		if "collision_mask" in child:
			_saved_masks[child] = child.collision_mask
		
		_sc(child)

# pause setter
func set_pause (is_paused: bool) -> void:
	for entity in $Walls.get_children():
		if entity.has_method("set_pause"):
			entity.set_pause(is_paused)
