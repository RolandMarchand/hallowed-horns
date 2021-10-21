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

onready var _tween: Tween = $Tween
onready var _line_timer: Timer = $LineTimer
onready var _screen_timer: Timer = $ScreenTimer

var skipped: bool = false
var text_speed = 12.0 # Words per second

# Code text skipping mechanic
# Instead of restarting this node's processes, free and reload this node

func new_message(message: String):
	text = message

	if not skipped:
		for line in message.split("\n"):
	# warning-ignore:return_value_discarded
			_tween.interpolate_property(self, "visible_characters",
					visible_characters, visible_characters + line.length(),
					_find_transition_time(text_speed, line.length()))
	# warning-ignore:return_value_discarded
			_tween.start()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if not skipped:
			_tween.queue_free()
			_line_timer.queue_free()
			call_deferred("set_percent_visible", 1)
			skipped = true
			_screen_timer.wait_time = text.length() / text_speed
			_screen_timer.start()
		else:
			emit_signal("text_displayed")

func _find_transition_time(speed: float, words: float) -> float:
	return pow(speed, -1) * words

func _on_Tween_tween_all_completed():
	_line_timer.start()

func _on_LineTimer_timeout():
	_screen_timer.start()

func _on_ScreenTimer_timeout():
	emit_signal("text_displayed")
