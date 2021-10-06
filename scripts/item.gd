extends Area2D

# warning-ignore:unused_signal
# used by instanced scenes
signal picked_up

enum action {PICKED_UP}

export(action) var _when_interact: int = action.PICKED_UP
