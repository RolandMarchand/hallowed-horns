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

# TODO:
# Separate the dialogue system and the border

signal text_displayed

const FAST = 5.0
const SLOW = 1.0

onready var _animated_text_scene = preload("res://scenes/GUI/AnimatedText.tscn")
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

# Huge mess about fading in and out

func display_message(message: String) -> void:
	_open_message_screen()
	_animated_text.new_message(message)

func fades_in() -> void:
	get_tree().paused = true
# warning-ignore:return_value_discarded
	_color_rect_tween.interpolate_property(
			_black_color_rect,
			"color",
			Color("#00000000"),
			Color("#000000"),
			0.5,
			Tween.TRANS_QUINT,
			Tween.EASE_IN
			)
# warning-ignore:return_value_discarded
	_color_rect_tween.start()
	yield(_color_rect_tween, "tween_all_completed")
	emit_signal("text_displayed")

func fades_out() -> void:
# warning-ignore:return_value_discarded
	_color_rect_tween.interpolate_property(
			_black_color_rect,
			"color",
			Color("#000000"),
			Color("#00000000"),
			0.5,
			Tween.TRANS_QUINT,
			Tween.EASE_OUT
			)
# warning-ignore:return_value_discarded
	_color_rect_tween.start()

	get_tree().paused = false

func _on_AnimatedText_text_displayed() -> void:
	emit_signal("text_displayed")
	_reload_AnimatedText()
	_close_message_screen()

func _reload_AnimatedText():
	_animated_text = _reload_node(_animated_text, _animated_text_scene)
# warning-ignore:return_value_discarded
	_animated_text.connect("text_displayed", self, "_on_AnimatedText_text_displayed")

func _reload_node(node: Node, replacement: Resource) -> Node:
	var parent: Node = node.get_node("../")
	var new_node = replacement.instance()

	node.queue_free()

	#new_animated_text.connect("text_displayed", self, "_on_AnimatedText_text_displayed")
	parent.add_child(new_node)
	return new_node

func _open_message_screen() -> void:
# warning-ignore:return_value_discarded
	_color_rect_tween.interpolate_property(_black_color_rect, "color",
			Color("#00000000"), Color("#000000"), 0.5, Tween.TRANS_QUINT, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	_color_rect_tween.start()
	_animated_text.show()
	get_tree().paused = true

func _close_message_screen() -> void:
# warning-ignore:return_value_discarded
	_color_rect_tween.interpolate_property(_black_color_rect, "color",
			Color("#000000"), Color("#00000000"), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	_color_rect_tween.start()
	_animated_text.hide()
	get_tree().paused = false

func damaged() -> void:
	_health_label.text = str(PlayerStats.health)
	_flash(cga_palette["red"], 2)

func _flash(flash_color: Color, time: float) -> void:
	var flash_color_alpha: Color = flash_color
	flash_color_alpha.a = 0

	# warning-ignore:return_value_discarded
	_color_rect_tween.interpolate_property(_pain_color_rect, "color",
			flash_color, flash_color_alpha, time,
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	_color_rect_tween.start()

