extends KinematicBody2D

const MOTION_SPEED = 60 # Pixels/second.

func _physics_process(_delta: float) -> void:
	var _motion = Vector2()
	_motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	_motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	_motion.y /= 2
	_motion = _motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(_motion, Vector2(), false)
