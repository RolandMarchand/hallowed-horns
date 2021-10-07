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
extends "res://scripts/item.gd"

export(ItemDict.keys) var _key_type: int = ItemDict.keys.BRONZE_KEY

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body: Node) -> void:
	match _when_interact:
		action.PICKED_UP:
			# Redirect the signal to main so that it can manage the singleton
			# and the GUI message
			emit_signal("picked_up", ItemDict.types.KEYS, _key_type)
			call_deferred("queue_free")

