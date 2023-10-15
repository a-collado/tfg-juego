extends Node

var title = "Game v0.1"

func _process(_delta):
	print("fps: " + str(Engine.get_frames_per_second()))
