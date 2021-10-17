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
# 1) Add forced randomness.
# Make sure there cannot be the same next move more than 4 times in a row
# 2) Make the listing of moves dynamic
# 3) Create a dynamic enemy system

const ENEMY_MAX_HEALTH := 18

onready var time_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer3/ProgressBar
onready var attack_timer: Timer = $AttackTimer
onready var texture_rect: TextureRect = $TextureRect
onready var stunned_timer: Timer = $StunnedTimer
onready var buffer_label: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/Label2
onready var next_attack_label: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/Label2
onready var player_health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer2/ProgressBar
onready var enemy_health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/ProgressBar
onready var stream: AudioStreamPlayer = $AudioStreamPlayer
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_enemy: AnimationPlayer = $AnimationPlayer2

var punch1: AudioStreamOGGVorbis = preload("res://assets/sounds/impactPunch_heavy_003.ogg")
var punch2: AudioStreamOGGVorbis = preload("res://assets/sounds/impactPunch_heavy_004.ogg")

enum {PLAYER, ENEMY}

var punch: Object = MoveLexicon.Punch.new()
var kick: Object = MoveLexicon.Kick.new()

var enemy: Object

var attack_array: Array = [punch, kick]
var next_attack: int

var attack_buffer: Array = []
var array_pos: int

var stunned: bool # Does not record wrong key presses while stunned

func _ready():
	randomize()
	_new_attack()
	
	#texture_rect.texture = 
	
	enemy_health_bar.max_value = enemy_health
	enemy_health_bar.value = enemy_health_bar.max_value
	
	player_health_bar.max_value = PlayerStats.health
	player_health_bar.value = player_health_bar.max_value
	
	VisualServer.set_default_clear_color(Color.black)

func _physics_process(_delta):
	time_bar.value = attack_timer.time_left / attack_timer.wait_time * 100

func _new_attack():
	next_attack = randi() % attack_array.size()
	next_attack_label.text = attack_array[next_attack].attack_name

func _update_attack_buffer(value: int):
	_record_move(value)
	
	if stunned and not _is_move_valid():
		_clear_attack_buffer()
	
	if not stunned and not _is_move_valid():
		_damage(PLAYER, enemy_damage)
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
			enemy_health -= damage
			enemy_health_bar.value = enemy_health
			
			stream.stream = punch2
			stream.play()
			
			animation_enemy.call_deferred("stop", true)
			#animation_enemy.seek(0, true)
			animation_enemy.call_deferred("play", "enemy_hurt")
			
			_new_attack()
			
			if enemy_health < 1:
				_game_over(true)
			
			attack_timer.wait_time = max(float(enemy_health) / float(ENEMY_MAX_HEALTH) * 3, 1)

func _game_over(win: bool):
	$MarginContainer.hide()
	$GameOver.show()
	attack_timer.stop()
	stunned_timer.stop()
	set_process_unhandled_key_input(false)
	
	if win:
		get_node("TextureRect").flip_v = true
		$GameOver/CenterContainer/VBoxContainer/Label.text = "You Win!"
	else:
		VisualServer.set_default_clear_color(Color("#a31818"))
		$GameOver/CenterContainer/VBoxContainer/Label.text = "You Lose!"

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
	_damage(PLAYER, enemy_damage)

func _on_StunnedTimer_timeout():
	attack_timer.start()
	stunned = false

func _on_Button_pressed():
	get_tree().quit(0)