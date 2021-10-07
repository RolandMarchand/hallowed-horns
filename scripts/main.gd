extends CanvasLayer

var current_room: int
var hide_rooms: bool = true

onready var gui = get_node("GUI")

func _ready() -> void:
	load_world(0)
	
	# Debug
	if get_tree().is_debugging_collisions_hint() or get_tree().is_debugging_navigation_hint():
		hide_rooms = false
		for room in $Rooms.get_children():
			room.modulate = Color("#7fffffff")
	
	VisualServer.set_default_clear_color(Color("#ff5555"))

func load_world(world: int) -> void:
	for room in GlobalWorld.global_world[world]:
		$Rooms.add_child(load(room).instance())
	
	# Disables all current rooms, except for starting one
	# Sets current_room to the spawning room ID
	for room in $Rooms.get_children():
		disable_room(room)
		if room.is_in_group("spawn"):
			current_room = room.id
	enable_room(find_room_id(current_room))
	
	# Connects all signals
	for item in get_tree().get_nodes_in_group("items"):
		item.connect("picked_up", self, "_item_picked_up", [item])
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.connect("body_entered", self, "enemy_touched_player", [enemy])
	
	for door in get_tree().get_nodes_in_group("doors"):
		door.connect("change_room", self, "change_room")
		door.connect("locked", self, "door_locked")
		door.connect("unlocked", self, "door_unlocked")

func change_room(room: int, _node: Node = null) -> void:
	var room_node: Node = find_room_id(room)
	disable_room(find_room_id(current_room))
	enable_room(room_node)
	current_room = room_node.id

func disable_room(room: Node2D) -> void:
	if hide_rooms:
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

func door_unlocked() -> void:
	print("The door is unlocked")

func _item_picked_up(_type, _value, _item: Node) -> void:
	match _type:
		ItemDict.types.KEYS:
			PlayerStats.add_key(_value)

func enemy_touched_player(_player: Node, _enemy: Node):
	_enemy.queue_free()
	PlayerStats.health -= 1
	gui.damaged()
