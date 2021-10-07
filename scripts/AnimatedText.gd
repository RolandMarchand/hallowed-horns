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

var _text_display_speed: int = 12 # Characers per second

# Stupid mess I got myself in half asleep at 3AM
# Just arrange the animated text so that the first time the player presses space
# the text scroll faster, the second time it sends the signal text_displayed.
# Keep the timer as it is
func new_text(message: String) -> void:
	percent_visible = 0
	message = message.insert(0, "[center]")
	message = message.insert(message.length(), "[/center]")
	bbcode_text = message
	
	
	$Tween.playback_speed = 1
	$Timer.wait_time = 3
	
	$Tween.interpolate_property(self, "percent_visible", 0, 1, _tween_time(_text_display_speed, self.text.length()))
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Timer.start()
	yield($Timer, "timeout")
	emit_signal("text_displayed")

func _unhandled_input(_event) -> void:
	# Quick printing
	if Input.is_action_just_pressed("ui_accept"):
		if not $Tween.is_active():
			$Timer.stop()
			$Timer.emit_signal("timeout")
		else:
			$Timer.wait_time = bbcode_text.length() / 10 # Lets some time to read the quickly printer screen
			$Tween.playback_speed = 5

func _tween_time(speed, words) -> float:
	return pow(speed, -1) * words
