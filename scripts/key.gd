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

export(ItemLexicon.KEY) var _value: int = ItemLexicon.KEY.BRONZE

func _ready() -> void:
	type = ItemLexicon.TYPE.KEY
	value = _value
	message = "You picked up the {key} key.".format(
			{"key": ItemLexicon.key_dict[_value]}
			)

