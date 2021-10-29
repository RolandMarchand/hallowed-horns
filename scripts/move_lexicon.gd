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

#enum ATTACK {PUNCH, KICK}
#
#var attack_dict: Dictionary = {
#		ATTACK.PUNCH: Punch,
#		ATTACK.KICK: Kick,
#}
#
#func get_attack(attack: int) -> Object:
#	return attack_dict[attack]

var attack_list: Array = [Punch, Kick]

class Punch extends Attack:
	func _init():
		enabled = true
		required_items = []
		key_combination = [KEY_W, KEY_A, KEY_S, KEY_D]
		damage = 1
		name = "Punch"

class Kick extends Attack:
	func _init():
		enabled = true
		required_items = []
		key_combination = [KEY_I, KEY_L, KEY_K, KEY_J]
		damage = 1
		name = "Kick"
