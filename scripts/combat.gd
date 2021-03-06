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
extends CanvasLayer

# TODO
# 1) Rely on tweening the time bar instead of using _physics_process

signal combat_over

const ATTACK_LOG_lENGTH := 3
const ENEMY_MAX_HEALTH := 18

onready var time_bar: ProgressBar = $Control/MarginContainer/VBoxContainer/HBoxContainer3/ProgressBar
onready var attack_timer: Timer = $AttackTimer
onready var texture_rect: TextureRect = $Control/TextureRect
onready var stunned_timer: Timer = $StunnedTimer
onready var buffer_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/Label2
onready var next_attack_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/Label2
onready var player_health_bar: ProgressBar = $Control/MarginContainer/VBoxContainer/HBoxContainer2/ProgressBar
onready var enemy_health_bar: ProgressBar = $Control/MarginContainer/VBoxContainer/HBoxContainer/ProgressBar
onready var stream: AudioStreamPlayer = $AudioStreamPlayer
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_enemy: AnimationPlayer = $AnimationPlayer2
onready var moves_container: HBoxContainer = $Control/MarginContainer/VBoxContainer/Moves

var punch1: AudioStreamOGGVorbis = preload("res://assets/sounds/impactPunch_heavy_003.ogg")
var punch2: AudioStreamOGGVorbis = preload("res://assets/sounds/impactPunch_heavy_004.ogg")

enum {PLAYER, ENEMY}

var enemy: Object

var attack_array: Array
var next_attack: int

var attack_log: Array = []
var attack_buffer: Array = []
var array_pos: int

var stunned: bool # Does not record wrong key presses while stunned

func _ready():
	randomize()
	set_process_unhandled_key_input(false)
	_load_attacks()

# TODO, get list of all attacks that can be played and dynamically add
# VBoxContainer's to the Moves node
func _load_attacks():
	attack_array = AttackLexicon.get_available_attacks()

	for attack in attack_array:
		moves_container.add_child(get_new_attack_container(attack))

func get_new_attack_container(attack: Attack) -> VBoxContainer:
	var container := VBoxContainer.new()
	var attack_name := Label.new()
	var attack_combo := Label.new()

	attack_name.text = attack.name
	attack_combo.text = attack.get_key_combination_string()

	for label in [attack_name, attack_combo]:
		label.align = Label.ALIGN_CENTER
		container.add_child(label)

	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	return container

func new_combat(new_enemy: Object):
	set_process_unhandled_key_input(true)

	get_tree().paused = true

	$Control.show()

	_new_attack()

	enemy = new_enemy

	attack_timer.wait_time = enemy.attack_speed
	attack_timer.start()

	texture_rect.texture = enemy.texture

	enemy_health_bar.max_value = enemy.health
	enemy_health_bar.value = enemy_health_bar.max_value

	player_health_bar.max_value = PlayerStats.MAX_HEALTH
	player_health_bar.value = PlayerStats.health

func _physics_process(_delta):
	time_bar.value = attack_timer.time_left / attack_timer.wait_time * 100

func _new_attack():
	assert(attack_array.size() > 0, "attack_array needs to hold at least one attack.")
	next_attack = _pseudo_randi(attack_array.size())
	next_attack_label.text = attack_array[next_attack].name

## Returns a random number that feels more random.
## randi can return the same value 5 times in a row, which doesn't feel random.
## pseudo_randi returns more balanced values.
func _pseudo_randi(maximum: int) -> int:
	var random_val: int

	while true:
		random_val = randi() % maximum

		if attack_log.size() < ATTACK_LOG_lENGTH:
			attack_log.append(random_val)
			break

		if attack_log.size() != attack_log.count(random_val):
			attack_log.pop_front()
			attack_log.append(random_val)
			break

	return random_val

func _update_attack_buffer(value: int):
	_record_move(value)

	if stunned and not _is_move_valid():
		_clear_attack_buffer()

	if not stunned and not _is_move_valid():
		_damage(PLAYER, enemy.damage)
		return

	if attack_buffer == Array(attack_array[next_attack].key_combination):
		_damage(ENEMY, attack_array[next_attack].damage)

func _clear_attack_buffer():
	attack_buffer.clear()
	buffer_label.text = ""

func _record_move(move: int):
	attack_buffer.append(move)
	array_pos = attack_buffer.size() - 1
	buffer_label.text += OS.get_scancode_string(move) + " "

func _damage(actor: int, damage):
	attack_timer.start()
	_clear_attack_buffer()

	match actor:
		PLAYER:
			PlayerStats.health -= damage
			player_health_bar.value = PlayerStats.health

			stream.stream = punch1
			stream.play()

			animation_player.call_deferred("stop", true)
			#animation_player.seek(0, true)
			animation_player.call_deferred("play", "player_hurt")

			stunned_timer.start()
			stunned = true

			attack_timer.stop()

			if PlayerStats.health < 1:
				_game_over(false)

		ENEMY:
			enemy.health -= damage
			enemy_health_bar.value = enemy.health

			stream.stream = punch2
			stream.play()

			animation_enemy.call_deferred("stop", true)
			#animation_enemy.seek(0, true)
			animation_enemy.call_deferred("play", "enemy_hurt")

			_new_attack()

			if enemy.health < 1:
				_game_over(true)

			attack_timer.wait_time = max(float(enemy.health) / float(ENEMY_MAX_HEALTH) * 3, 1)

func _game_over(win: bool):
	attack_timer.stop()
	stunned_timer.stop()
	set_process_unhandled_key_input(false)
	$Control/MarginContainer.hide()
	if win:
		texture_rect.flip_v = true
		$Control/GameOver/CenterContainer/VBoxContainer/Label.text = "You Win!"
	else:
		$Control/BGRect.color = Color("#a31818")
		$Control/GameOver/CenterContainer/VBoxContainer/Label.text = "You Lose!"

	$EndTimer.start()
	yield($EndTimer, "timeout")
	get_tree().paused = false
	emit_signal("combat_over", win)

func _is_move_valid() -> bool:
	var valid_attack = attack_array[next_attack]

	if attack_buffer.size() <= valid_attack.key_combination.size():
		if attack_buffer[array_pos] == valid_attack.key_combination[array_pos]:
			return true

	return false

func _unhandled_key_input(event):
	if event.is_pressed() and event.scancode >= KEY_A and event.scancode <= KEY_Z:
		_update_attack_buffer(event.scancode)

func _on_AttackTimer_timeout():
	_damage(PLAYER, enemy.damage)

func _on_StunnedTimer_timeout():
	attack_timer.start()
	stunned = false

func _on_Button_pressed():
	get_tree().quit(0)
