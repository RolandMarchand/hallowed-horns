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

# TODO: Change the message system, set a list of characters to pause at

func _ready() -> void:
	# Prevents a bug
	set_process_unhandled_input(false)

func new_message(message: String) -> void:
	set_process_unhandled_input(true)
	bbcode_text = message

	if not skipped:
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

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if not skipped:
			_skip_text()
		else:
			emit_signal("text_displayed")

func _skip_text() -> void:
	skipped = true

# warning-ignore:return_value_discarded
	_tween.stop_all() # If not paused before queued free, weird bugs happen
	_tween.queue_free()

	_line_timer.queue_free()

	set_percent_visible(1) # Shows all text

	_screen_timer.wait_time = text.length() / text_speed
	_screen_timer.start()


func _find_transition_time(speed: float, words: float) -> float:
	return pow(speed, -1) * words

func _on_ScreenTimer_timeout() -> void:
	set_process_unhandled_input(false)
	emit_signal("text_displayed")
