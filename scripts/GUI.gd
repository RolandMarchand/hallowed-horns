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
extends CanvasLayer

signal text_displayed

const FAST = 5.0
const SLOW = 1.0

onready var _animated_text_scene = preload("res://scenes/AnimatedText.tscn").new()
onready var _animated_text: RichTextLabel = get_node("BorderMargin/TextMargin/AnimatedText")
onready var _health_label: Label = get_node("TextureRect/HealthLabel")
onready var _pain_color_rect: ColorRect = get_node("BorderMargin/PainColorRect")
onready var _black_color_rect: ColorRect = get_node("BorderMargin/BlackColorRect")
onready var _color_rect_tween: Tween = get_node("BorderMargin/ColorRectTween")

var _text_display_speed: int = 12 # Characers per second
var cga_palette: Dictionary = {
		"green": Color("#55ff55"),
		"red": Color("#ff5555"),
		"yellow": Color("#ffff55")
		}

func display_message(message: String) -> void:
	_open_message_screen()
	_animated_text.new_message(message)
	
func _on_AnimatedText_text_displayed():
	emit_signal("text_displayed")
	_close_message_screen()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		pass

func _open_message_screen() -> void:
	get_tree().paused = true
	_animated_text.show()
	_black_color_rect.show()

func _close_message_screen() -> void:
	_black_color_rect.hide()
	_animated_text.hide()
	get_tree().paused = false

func damaged() -> void:
	_health_label.text = str(PlayerStats.health)
	_flash(cga_palette["red"])

func _flash(flash_color: Color) -> void:
	var flash_color_alpha: Color = flash_color
	flash_color_alpha.a = 0
	
	# warning-ignore:return_value_discarded
	_color_rect_tween.interpolate_property(_pain_color_rect, "color",
			flash_color, flash_color_alpha, 2,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	_color_rect_tween.start()

func _tween_time(speed, words) -> float:
	return pow(speed, -1) * words


func _on_Tween_tween_all_completed():
	print("done")


func _on_LineTimer_timeout():
	print("timer1")


func _on_ScreenTimer_timeout():
	print("timer2")


