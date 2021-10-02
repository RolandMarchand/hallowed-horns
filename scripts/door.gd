extends Area2D

signal locked
signal unlocked
signal change_room

export var leads_to := 1
export var is_locked: bool = false
export(ItemDict.keys) var key_required = ItemDict.keys.BRONZE_KEY

func _ready():
# warning-ignore:return_value_discarded
	connect("change_room", get_tree().current_scene, "change_room", [leads_to])
# warning-ignore:return_value_discarded
	connect("locked", get_tree().current_scene, "door_locked")
# warning-ignore:return_value_discarded
	connect("unlocked", get_tree().current_scene, "door_unlocked", [leads_to])


func _on_Door_body_entered(_body):
	if is_locked:
		if PlayerStats.has_key(key_required):
			emit_signal("unlocked")
		else:
			emit_signal("locked")
	else:
		emit_signal("change_room")
