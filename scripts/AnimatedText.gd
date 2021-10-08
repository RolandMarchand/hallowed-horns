extends RichTextLabel

signal text_displayed
signal reload_node

const SLOW := 1.0
const FAST := 5.0

var text_speed = 12 # Words per second

# Code text skipping mechanic
# Instead of restarting this node's processes, free and reload this node

func new_message(message: String):
	text = message
	visible_characters = 0
	
	for line in message.split("\n"):
		$Tween.interpolate_property(self, "visible_characters",
				visible_characters, visible_characters + line.length(), 
				_find_transition_time(text_speed, line.length()))
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		$LineTimer.start()
		yield($LineTimer, "timeout")
	
	$ScreenTimer.start()
	yield($ScreenTimer, "timeout")
	
	emit_signal("text_displayed")

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		match $Tween.playback_speed:
			SLOW:
				$Tween.playback_speed = FAST
				$LineTimer.wait_time = 0.001
				$ScreenTimer.wait_time = text.length() / text_speed
			FAST:
				emit_signal("reload_node")

func _find_transition_time(speed: float, words: float) -> float:
	return pow(speed, -1) * words
