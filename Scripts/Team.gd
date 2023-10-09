extends Node
class_name Team

var players: Array

@export var goal_target: CSGCylinder3D

# Called when the node enters the scene tree for the first time.
func _ready():
	players.append_array(get_children())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
