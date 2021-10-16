extends CanvasLayer

onready var time_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer3/ProgressBar
onready var attack_timer: Timer = $AttackTimer
onready var buffer_label: Label = $MarginContainer/VBoxContainer/VBoxContainer/Label2
onready var player_health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer2/ProgressBar
onready var enemy_health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/ProgressBar

var punch: Object = Attack.new(true, [], [KEY_W, KEY_A, KEY_S, KEY_D], 1)
var attack_buffer: Array = []
var array_pos: int

func _ready():
	pass

func _physics_process(_delta):
	time_bar.value = attack_timer.time_left / attack_timer.wait_time * 100
	

func _update_attack_buffer(value: int):
	array_pos = attack_buffer.size() - 1
	
	attack_buffer.append(value)
	buffer_label.text = String(attack_buffer)
	
	if not _is_move_valid():
		_damage_player()
		return
	
	if attack_buffer == Array(punch.key_combination):
		_damage_enemy()
		return

func _damage_player():
	player_health_bar.value -= 1
	attack_timer.time_left = 3.0

func _damage_enemy():
	enemy_health_bar.value -= punch.damage
	attack_timer.time_left = 3.0

func _is_move_valid() -> bool:
	if attack_buffer.size() <= punch.key_combination.size():
		if attack_buffer[array_pos] == punch.key_combination[array_pos]:
			return true
	
	return false

func _unhandled_key_input(event):
	if event.is_pressed():
		_update_attack_buffer(event.scancode)
