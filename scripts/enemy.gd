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
extends Area2D

signal player_detected

# When updating this line, also update enemy_lexicon.gd. Godot bug.
enum RACE {GOBLIN, MOUSE}

var navigation_path: PoolVector2Array = []

export(RACE) onready var value # Ignore the error, Godot bug

# Those variables need to be onready because of how exports are managed
onready var type = EnemyLexicon.get_race(value).new()
export(int) onready var vision_length: int = type.vision_length
export(float) onready var speed: float = type.walk_speed

export(int, "Idle", "Path", "Chase") var state = 0
export(bool) var walk_back: bool = false

onready var vision_ray = $RayCast2D
onready var tween = $Tween

func _ready():
	$Sprite.texture = type.texture

func _physics_process(_delta: float) -> void:
	vision_ray.cast_to = (Vector2(PlayerStats.global_position) - self.global_position).clamped(vision_length)

	if vision_ray.enabled and vision_ray.get_collider():
		if vision_ray.get_collider().is_in_group("player"):
			emit_signal("player_detected", self, PlayerStats.node)
			vision_ray.enabled = false

func get_points() -> Array:
	return $Points.get_children()
