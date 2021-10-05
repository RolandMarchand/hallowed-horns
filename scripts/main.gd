extends CanvasLayer

var current_room: int

func _ready() -> void:
	
	for room in GlobalWorld.global_world[0]:
		$Rooms.add_child(load(room).instance())
	
	# Disables all current rooms, except for starting one
	# Sets current_room to the spawning room ID
	for room in $Rooms.get_children():
		disable_room(room)
		if room.is_in_group("spawn"):
			current_room = room.id
	enable_room(find_room_id(current_room))
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.connect("send_target_info", self, "enemy_target_request")

func change_room(room: int, _node: Node = null) -> void:
	var room_node: Node = find_room_id(room)
	disable_room(find_room_id(current_room))
	enable_room(room_node)
	current_room = room_node.id

func disable_room(room: Node2D) -> void:
	room.hide()
	room.disable_collisions()
	set_scene_process(room, false)

func enable_room(room: Node2D) -> void:
	room.show()
	room.enable_collisions()
	set_scene_process(room, true)

# Pauses a scene and all of its children
func set_scene_process(node: Node, paused: bool) -> void:
	node.set_physics_process(paused)
	node.set_process(paused)
	node.set_process_input(paused)
	for child in node.get_children():
		set_scene_process(child, paused)

func find_room_id(id: int) -> Object:
	for room in $Rooms.get_children():
		if room.id == id:
			return room
	push_error("find_room_id: No room found.")
	return null

func door_locked() -> void:
	print("The door is locked")

func door_unlocked(to: int) -> void:
	print("The door is unlocked")
	change_room(to)

func enemy_target_request(_sender: Node2D) -> void:
	for _player in get_tree().get_nodes_in_group("player"):
		if find_room_id(current_room).is_a_parent_of(_player):
			_sender.set_player(_player)
