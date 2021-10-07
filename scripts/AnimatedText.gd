extends RichTextLabel

signal text_displayed

func _ready() -> void:
	visible_characters = 0

func _unhandled_input(_event) -> void:
	if Input.is_action_pressed("ui_accept"):
		$Timer.wait_time = 0.01
	else:
		$Timer.wait_time = 0.075

func _on_Timer_timeout() -> void:
	visible_characters += 1
	
	if percent_visible > 1:
		$Timer.one_shot = true
		emit_signal("text_displayed")
