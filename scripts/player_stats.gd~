extends Node

var health: int = 3
var _keyring: int = 0

## Works on a 1, 2, 4 system like Unix permissions
func add_key(key) -> void:
	_keyring = key | _keyring

## Returns > 0 if has the key
## Only works with one key at a time
func has_key(key) -> int:
	return key & _keyring
