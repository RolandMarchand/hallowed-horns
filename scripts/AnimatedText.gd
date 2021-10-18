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

const SLOW := 1.0
const FAST := 5.0

onready var _tween: Tween = $Tween
onready var _line_timer: Timer = $LineTimer
onready var _screen_timer: Timer = $ScreenTimer

var text_speed = 12 # Words per second

# Code text skipping mechanic
# Instead of restarting this node's processes, free and reload this node

func new_message(message: String):
	text = message
	visible_characters = 0

	for line in message.split("\n"):
# warning-ignore:return_value_discarded
		_tween.interpolate_property(self, "visible_characters",
				visible_characters, visible_characters + line.length(),
				_find_transition_time(text_speed, line.length()))
# warning-ignore:return_value_discarded
		_tween.start()
		yield(_tween, "tween_all_completed")

		_line_timer.start()
		yield(_line_timer, "timeout")

	_screen_timer.start()
	yield(_screen_timer, "timeout")

	emit_signal("text_displayed")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		match _tween.playback_speed:
			SLOW:
				_tween.playback_speed = FAST
				_line_timer.wait_time = 0.001
				_screen_timer.wait_time = text.length() / text_speed
			FAST:
				emit_signal("text_displayed")

func _find_transition_time(speed: float, words: float) -> float:
	return pow(speed, -1) * words
