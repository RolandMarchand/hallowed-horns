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

# When updating this line, also update enemy.gd. Godot bug.
enum RACE {GOBLIN, MOUSE}

var race_dict: Dictionary = {
		RACE.GOBLIN: Goblin,
		RACE.MOUSE: Mouse,
}

class Goblin extends Enemy:
	func _init():
		attack_speed = 3 # Second per attack
		damage = 1
		entrance= "I'm just a little Goblin!"
		health = 18
		name = "Goblin"
		texture = preload("res://assets/sprites/troll2.png")
		vision_length = 50 # Overriden by the enemy's local vision length
		walk_speed = 64 # Overriden by the enemy's local speed

class Mouse extends Enemy:
	func _init():
		attack_speed = 60 # Second per attack
		damage = 1
		entrance= "I'm just a little Goblin!"
		health = 1
		name = "Mouse"
		texture = preload("res://assets/sprites/mouse.png")
		vision_length = 50 # Overriden by the enemy's local vision length
		walk_speed = 32 # Overriden by the enemy's local speed
