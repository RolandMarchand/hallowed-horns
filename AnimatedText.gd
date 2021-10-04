extends RichTextLabel


func _ready() -> void:
	visible_characters = 0

func _on_Timer_timeout():
	visible_characters += 1
