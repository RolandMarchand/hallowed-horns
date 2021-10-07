extends KinematicBody2D

export(int, FLAGS, "Walls", "Player", "Entities", "Doors") var _protected_layers = 0 setget ,get_protected_layers
export(int, FLAGS, "Walls", "Player", "Entities", "Doors") var _protected_masks = 0 setget ,get_protected_masks

export var _speed = 32 # Pixels/second.

func _physics_process(_delta: float) -> void:
	var _motion = Vector2()
	_motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	_motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	_motion.y /= 2
	_motion = _motion.normalized() * _speed
	#warning-ignore:return_value_discarded
	move_and_slide(_motion, Vector2(), false)

func get_protected_layers() -> int:
	return _protected_layers

func get_protected_masks() -> int:
	return _protected_masks
