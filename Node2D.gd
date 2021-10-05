extends Node2D

onready var _path: Path2D = $Path2D
onready var _path_follow: PathFollow2D = $Path2D/PathFollow2D
onready var _tween: Tween = $Tween

func _ready():
#	_tween.interpolate_property($Path2D/PathFollow2D, "unit_offset", 0.0, 1.0, 1)
#	_tween.start()
#	_path_follow.unit_offset = 0.5
	pass

func _physics_process(delta):
	$Path2D/PathFollow2D.unit_offset += 0.1 * delta
	print($Path2D/PathFollow2D.offset)


func _on_Tween_tween_all_completed():
	print("done")
