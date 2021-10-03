extends Node

var loaded_rooms: Array = []

# {level : room}
var global_world := {
	0: ["res://rooms/room0.tscn", "res://rooms/room1.tscn"]
}

func _ready():
	load_new_world(0)

func load_new_world(world: int = 0):
	loaded_rooms = []
	for room in GlobalWorld.global_world[world]:
		loaded_rooms.append(load(room).instance())
