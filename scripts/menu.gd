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
extends MarginContainer

func _ready():
	_connect_buttons()

## Recursively connects all button children to _on_button_down and _on_button_up
func _connect_buttons() -> void:
	_cb(self)
## Gets called by _connect_buttons
func _cb(node) -> void:
	for child in node.get_children():
		if child.is_class("Button"):
			if child.toggle_mode:
				child.connect("toggled", self, "_on_button_toggled", [child])
			else:
				child.connect("button_down", self, "_on_button_down", [child])
				child.connect("button_up", self, "_on_button_up", [child])
		_cb(child)

func _on_button_down(button: Button) -> void:
	button.modulate = Color.red

func _on_button_up(button: Button) -> void:
	button.modulate = Color.white

func _on_button_toggled(button_pressed: bool, button: Button) -> void:
	if button_pressed:
		button.modulate = Color.red
	else:
		button.modulate = Color.white
