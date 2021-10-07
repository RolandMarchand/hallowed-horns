# This file is part of Hallowed Horns.
#
# Hallowed Horns is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Hallowed Horns is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Hallowed Horns.  If not, see <https://www.gnu.org/licenses/>.
extends RichTextLabel

signal text_displayed

const FAST = 5
const SLOW = 1

var _text_display_speed: int = 12 # Characers per second

# Huge mess, this whole UI, I screwed up, fix it

## The text scrolls slowly, and wait for 3 seconds, and ends
## If player interacts, text will scroll slowly and then wait a long time for
## the reader to read all of the text
## If the player interacts again, automatically ends
## ADD A WAIT TIME FOR NEW SENTENCES.
func new_text(message: String) -> void:
	percent_visible = 0
	#message = message.insert(0, "[center]")
	#message = message.insert(message.length(), "[/center]")
	bbcode_text = message
	
	
	$Tween.playback_speed = SLOW
	$Timer.wait_time = 3
	
	$Tween.interpolate_property(self, "percent_visible", 0, 1, _tween_time(_text_display_speed, self.text.length()))
	$Tween.start()

#func _physics_process(delta):
#	print($Timer.time_left)

func _unhandled_input(_event) -> void:
	# Quick printing
	if Input.is_action_just_pressed("ui_accept"):
		if $Tween.is_active():
			match $Tween.playback_speed:
				SLOW:
					print("Getting faster")
					$Tween.playback_speed = FAST
				FAST:
					$Tween.stop_all()
					$Timer.stop()
					emit_signal("text_displayed")
		else:
			emit_signal("text_displayed")
#		if not $Tween.is_active():
#			print(1)
#			$Timer.stop()
#			$Timer.emit_signal("timeout")
#		elif $Tween.is_active() and $Tween.playback_speed == FAST:
#			print(2)
#			$Tween.stop_all()
#			$Timer.stop()
#			emit_signal("text_displayed")
#		else:
#			print(3)
#			$Timer.wait_time = bbcode_text.length() / 10.0 # Lets some time to read the quickly printer screen
#			$Tween.playback_speed = FAST

func _tween_time(speed, words) -> float:
	return pow(speed, -1) * words


func _on_Tween_tween_all_completed():
	print("Tween")
	$Timer.start()


func _on_Timer_timeout():
	print("Timer")
	emit_signal("text_displayed")
