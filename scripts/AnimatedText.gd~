extends RichTextLabel

var _text_display_speed: int = 12 # Characers per second

func _ready() -> void:
	new_text()

func new_text() -> void:
	$Timer.start()
	yield($Timer, "timeout")
	
	percent_visible = 0
	$Tween.interpolate_property(self, "percent_visible", 0, 1, _tween_time(_text_display_speed, self.text.length()))
	
	$Tween.playback_speed = 1
	$Timer.wait_time = 3
	
	$Tween.start()

func _unhandled_input(_event) -> void:
	# Quick printing
	if Input.is_action_just_pressed("ui_accept"):
		if not $Tween.is_active():
			$Timer.stop()
			$Timer.emit_signal("timeout")
		else:
			$Timer.wait_time = 15 # Lets some time to read the quickly printer screen
			$Tween.playback_speed = 5
#	if Input.is_action_pressed("ui_accept"):
#		$Tween.playback_speed = 5
#	else:
#		$Tween.playback_speed = 1

func _physics_process(_delta):
	pass

func _tween_time(speed, words) -> float:
	return pow(speed, -1) * words
