extends Node

class Punch extends Attack:
	func _init():
		enabled = true
		required_items = []
		key_combination = [KEY_W, KEY_A, KEY_S, KEY_D]
		damage = 1
		attack_name = "Punch"

class Kick extends Attack:
	func _init():
		enabled = true
		required_items = []
		key_combination = [KEY_I, KEY_L, KEY_K, KEY_J]
		damage = 1
		attack_name = "Kick"
