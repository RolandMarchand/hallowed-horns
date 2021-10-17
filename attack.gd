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

var enabled: bool = false
var required_items: PoolIntArray
var key_combination: PoolIntArray
var damage: int
var attack_name: String

## Returns false if item_list doesn't have all the values in required_items
func has_required_items(item_list: Array) -> bool:
	for required in required_items:
		if not item_list.has(required):
			return false
	return true
