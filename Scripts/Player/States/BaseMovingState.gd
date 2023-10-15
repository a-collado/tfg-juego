extends BaseState
class_name BaseMovingState

var curve3d: Curve3D
var last_target_position: Vector3

func enter() -> void:
	player.debug_state_label.text = name
	player.animator.play(animation)

	# Inicializamos la curve3D
	curve3d = Curve3D.new()
	curve3d.bake_interval = 0.5
	player.path3D.curve = curve3d
	last_target_position = Vector3.ZERO

	# Reinicamos el proceso de la ultima curva
	_clean_path()

func exit() -> void:
	_clean_path()

func _move_player() -> void:
	# Hacemos que siga la linea
	if player.pathFollow.progress_ratio < 1 :
		player.pathFollow.progress += player.speed

func _create_curve( target_position: Vector3 ) -> void:

	if target_position != last_target_position:
		_clean_path()
		curve3d.add_point(target_position)

	last_target_position = target_position

## Reiniciamos el camino del jugador
func _clean_path() -> void:
	curve3d.clear_points()
	player.pathFollow.progress = 0
	curve3d.add_point(_floor_vector(player.player_position))
