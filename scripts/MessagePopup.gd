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
extends Popup

onready var _animated_text_scene = preload("res://scenes/GUI/AnimatedText.tscn")
onready var _animated_text: RichTextLabel = get_node("BorderMargin/Panel/TextMargin/AnimatedText")

func _ready() -> void:
# warning-ignore:return_value_discarded
	_animated_text.connect("text_displayed", self, "_on_AnimatedText_text_displayed")

func new_message(message: String):
	popup()
	_animated_text.new_message(message)

func _reload_AnimatedText() -> void:
	var new_anim_text = _animated_text_scene.instance()
	
	_animated_text.queue_free()
	$BorderMargin/Panel/TextMargin.add_child(new_anim_text)
	
	_animated_text = new_anim_text
# warning-ignore:return_value_discarded
	_animated_text.connect("text_displayed", self, "_on_AnimatedText_text_displayed")

func _on_AnimatedText_text_displayed() -> void:
	hide()
	_reload_AnimatedText()
