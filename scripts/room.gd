extends Node2D

var _saved_layers: Dictionary
var _saved_masks: Dictionary

#func get_player_node() -> KinematicBody2D:
#	var _player: KinematicBody2D = 
#	return _player

func enable_collisions() -> void:
	_ec(self)
func _ec(node) -> void:
	for child in node.get_children():
		if not child.is_in_group("dont_disable_collisions"):
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
		if not child.is_in_group("dont_disable_collisions"):
			if "collision_layer" in child:
				child.collision_layer = 0
			if "collision_mask" in child:
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
