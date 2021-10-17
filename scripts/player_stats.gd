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
extends Node

var health: int = 18
var _keyring: int = 0

## Works on a 1, 2, 4 system like Unix permissions
func add_key(key) -> void:
	_keyring = key | _keyring

## Returns > 0 if has the key
## Only works with one key at a time
func has_key(key) -> int:
	return key & _keyring
