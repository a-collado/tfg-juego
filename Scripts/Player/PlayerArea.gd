extends Area2D

signal player_pressed

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			player_pressed.emit()

