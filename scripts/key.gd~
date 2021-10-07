extends "res://scripts/item.gd"

export(ItemDict.keys) var _key_type: int = ItemDict.keys.BRONZE_KEY

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body: Node) -> void:
	match _when_interact:
		action.PICKED_UP:
			emit_signal("picked_up", ItemDict.types.KEYS, _key_type)
			call_deferred("queue_free")

