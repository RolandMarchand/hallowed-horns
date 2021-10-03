extends Node

var keyring: int = 0

# Works on a 1, 2, 4 system like Unix permissions
func add_key(key):
	keyring = key | keyring

func has_key(key):
	return key & keyring
