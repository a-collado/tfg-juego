extends CSGSphere3D
class_name Ball

@onready var area3d: Area3D = $Area3D
@onready var collision_shape: CollisionShape3D = $Area3D/CollisionShape3D
var tween: Tween

# Jugador que tiene posesion de la pelota
var player: Player = null

func shoot(target_position):
	tween = create_tween().bind_node(self)

	var distance = global_position.distance_to(target_position)
	tween.tween_property(self, "global_position", target_position, 1)


func stop():
	if tween:
		tween.stop()
