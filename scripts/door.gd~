extends Area2D

signal locked
signal unlocked
signal change_room

export var leads_to := 1
export var is_locked: bool = false
export(ItemDict.keys) var key_required = ItemDict.keys.BRONZE_KEY
export(int, FLAGS, "Walls", "Player", "Entities", "Doors") var _protected_layers = 0 setget ,get_protected_layers
export(int, FLAGS, "Walls", "Player", "Entities", "Doors") var _protected_masks = 0 setget ,get_protected_masks

func _on_Door_body_entered(_body):
	if is_locked:
		if PlayerStats.has_key(key_required):
			emit_signal("unlocked")
			is_locked = false
			emit_signal("change_room", leads_to)
		else:
			emit_signal("locked")
	else:
		emit_signal("change_room", leads_to)

func get_protected_layers() -> int:
	return _protected_layers

func get_protected_masks() -> int:
	return _protected_masks
