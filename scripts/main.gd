extends Node

var current_room: int
onready var lmao = 3
func lmao():
	print(lmao)
func _ready():
	lmao()
	for room in GlobalWorld.global_world[0]:
		$Rooms.add_child(load(room).instance())
	
	# Disables all current rooms, except for starting one
	# Sets current_room to the spawning room ID
	for room in $Rooms.get_children():
		disable_room(room)
		
		if room.is_in_group("spawn"):
			current_room = room.id
	
	enable_room(find_room_id(current_room))

func change_room(room: int, _node: Node = null):
	var room_node: Node = find_room_id(room)
	disable_room(find_room_id(current_room))
	enable_room(room_node)
	current_room = room_node.id

func disable_room(room: Node):
	room.hide()
	set_scene_process(room, false)

func enable_room(room: Node):
	room.show()
	set_scene_process(room, true)

# Pauses a scene and all of its children
func set_scene_process(node: Node, paused: bool):
	node.set_physics_process(paused)
	node.set_process(paused)
	node.set_process_input(paused)
	for child in node.get_children():
		set_scene_process(child, paused)

func find_room_id(id: int):
	for room in $Rooms.get_children():
		if room.id == id:
			return room
	push_error("find_room_id: No room found.")

func door_locked():
	print("The door is locked")

func door_unlocked(to: int):
	print("The door is unlocked")
	change_room(to)
