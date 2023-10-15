extends Camera3D

@onready var ball: Ball = $"../Ball"

@export var move_speed = 0.5
@export var zoom_speed = 0.05
@export var min_zoom = 1.5
@export var max_zoom = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
