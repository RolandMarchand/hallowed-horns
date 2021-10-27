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

onready var message_popup = get_node("MessagePopup")

var _text_display_speed: int = 12 # Characers per second
var cga_palette: Dictionary = {
		"green": Color("#55ff55"),
		"red": Color("#ff5555"),
		"yellow": Color("#ffff55")
		}

func display_message(message: String) -> void:
	message_popup.new_message(message)

## Unused
func _reload_node(node: Node, replacement: Resource) -> Node:
	var new_node = replacement.instance()

	node.queue_free()

	$BorderMargin/NinePatchRect/MarginContainer.add_child(new_node)
	return new_node

func _on_MessagePopup_about_to_show():
	get_tree().paused = true


func _on_MessagePopup_popup_hide():
	get_tree().paused = false
	emit_signal("text_displayed")
