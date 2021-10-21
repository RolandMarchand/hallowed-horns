extends KinematicBody2D


func _ready():
	assert(get_parent().is_class("Navigation2D"),
			"Parent not of type Navigation2D")

#func _update_navigation_path() -> void:
#	var navigation_path: PoolVector2Array = get_simple_path(enemy.get_global_position(),
#			PlayerStats.global_position)
#	print(enemy.get_global_position())
#	navigation_path.remove(0)
#
#	enemy.navigation_path = navigation_path
#	navigation_path.append(enemy.get_global_position())
