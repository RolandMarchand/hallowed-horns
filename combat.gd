extends CanvasLayer

onready var time_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer3/ProgressBar
onready var attack_timer: Timer = $AttackTimer
onready var stunned_timer: Timer = $StunnedTimer
onready var buffer_label: Label = $MarginContainer/VBoxContainer/VBoxContainer/Label2
onready var player_health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer2/ProgressBar
onready var enemy_health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/ProgressBar
onready var stream: AudioStreamPlayer = $AudioStreamPlayer
onready var animation: AnimationPlayer = $AnimationPlayer

var punch1: AudioStreamOGGVorbis = preload("res://assets/sounds/impactPunch_heavy_003.ogg")
var punch2: AudioStreamOGGVorbis = preload("res://assets/sounds/impactPunch_heavy_004.ogg")

enum {PLAYER, ENEMY}

var punch: Object = Moves.Punch.new()
var kick: Object = Moves.Kick.new()
var attack_array: Array = [punch, kick]
var attack_buffer: Array = []
var array_pos: int

var enemy_health: int = 7
var enemy_damage: int = 1

func _ready():
	enemy_health_bar.max_value = enemy_health
	enemy_health_bar.value = enemy_health_bar.max_value
	
	player_health_bar.max_value = PlayerStats.health
	player_health_bar.value = player_health_bar.max_value
	
	VisualServer.set_default_clear_color(Color.black)

func _physics_process(_delta):
	time_bar.value = attack_timer.time_left / attack_timer.wait_time * 100
	

func _update_attack_buffer(value: int):
	attack_buffer.append(value)
	array_pos = attack_buffer.size() - 1
	buffer_label.text += OS.get_scancode_string(value) + " "
	
	if not _is_move_valid():
		_damage(PLAYER, enemy_damage)
		return
	
	for attack in attack_array:
		if attack_buffer == Array(attack.key_combination):
			_damage(ENEMY, attack.damage)
			return

func _damage(actor: int, damage):
	attack_timer.start()
	attack_buffer.clear()
	buffer_label.text = ""
	
	match actor:
		PLAYER:
			PlayerStats.health -= punch.damage
			player_health_bar.value = PlayerStats.health
			
			stream.stream = punch1
			stream.play()
			
			animation.stop()
			animation.play("player_hurt")
			
			stunned_timer.start()
			attack_timer.stop()
			set_process_unhandled_key_input(false)
			
			if PlayerStats.health < 1:
				_game_over(false)
			
		ENEMY:
			enemy_health -= punch.damage
			enemy_health_bar.value = enemy_health
			
			stream.stream = punch2
			stream.play()
			
			animation.stop()
			animation.play("enemy_hurt")
			
			if enemy_health < 1:
				_game_over(true)

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
		$GameOver/CenterContainer/VBoxContainer/Label.text = "You Lose!"

func _is_move_valid() -> bool:
	for attack in attack_array:
		if attack_buffer.size() <= attack.key_combination.size():
			if attack_buffer[array_pos] == attack.key_combination[array_pos]:
				return true
	
	return false

func _unhandled_key_input(event):
	if event.is_pressed() and event.scancode >= KEY_A and event.scancode <= KEY_Z:
		_update_attack_buffer(event.scancode)


func _on_AttackTimer_timeout():
	_damage(PLAYER, enemy_damage)


func _on_StunnedTimer_timeout():
	attack_timer.start()
	set_process_unhandled_key_input(true)


func _on_Button_pressed():
	get_tree().quit(0)
