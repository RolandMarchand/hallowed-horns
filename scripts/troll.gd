extends KinematicBody2D

const MOTION_SPEED = 60 # Pixels/second.

export var zoom: Vector2

func _ready() -> void:
	if zoom:
		$Camera2D.zoom = zoom

func _physics_process(_delta) -> void:
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	move_and_slide(motion, Vector2(), false)
