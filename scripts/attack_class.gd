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
class_name Attack#, "res://assets/attack_class_icon.svg"

var enabled: bool = false setget ,get_enabled
var required_items: Array = []
var key_combination: Array = []
var damage: int = 0
var name: String = "Unamed"

## Sets enabled to true if the player has all the required items of the attack,
## Sets to false otherwise.
## Returns enabled

func get_key_combination_string() -> String:
	var keys: String

	for key in key_combination:
		keys += OS.get_scancode_string(key)
		keys += " "

	keys = keys.trim_suffix(" ")

	return keys

func get_enabled() -> bool:
	for item in required_items:
		if not PlayerStats.inventory.has(item):
			enabled = false
			return enabled

	enabled = true
	return enabled
