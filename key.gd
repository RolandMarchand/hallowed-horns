extends Area2D

signal picked_up

export(ItemDict.keys) var key_type = ItemDict.keys.BRONZE_KEY

func _ready():
# warning-ignore:return_value_discarded
	connect("picked_up", PlayerStats, "add_key")


func _on_Key_body_entered(_body):
	emit_signal("picked_up", key_type)
	call_deferred("free")
