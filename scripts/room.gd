extends Node2D

var _saved_layers: Dictionary
var _saved_masks: Dictionary

func _ready() -> void:
	_save_collisions()

func enable_collisions() -> void:
	_ec(self)
func _ec(node) -> void:
	for child in node.get_children():
		if child.is_in_group("collisions"):
			if "collision_layer" in child:
				child.collision_layer = _saved_layers[child]
			if "collision_mask" in child:
				child.collision_mask = _saved_masks[child]
		_ec(child)

func disable_collisions() -> void:
	_dc(self)
func _dc(node) -> void:
	for child in node.get_children():
		if child.is_in_group("collisions"):
			if "collision_layer" in child:
				child.collision_layer = 0
			if "collision_layer" in child:
				child.collision_mask = 0
		_dc(child)

func _save_collisions() -> void:
	_sc(self)
func _sc(node) -> void:
	for child in node.get_children():
		if "collision_layer" in child:
			_saved_layers[child] = child.collision_layer
		if "collision_layer" in child:
			_saved_masks[child] = child.collision_mask
		_sc(child)
