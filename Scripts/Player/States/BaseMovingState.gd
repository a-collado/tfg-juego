extends BaseState
class_name BaseMovingState

var curve3d: Curve3D
var last_target_position

func enter():
	player.debug_state_label.text = name
	player.animator.play(animation)

	# Inicializamos la curve3D
	curve3d = Curve3D.new()
	curve3d.bake_interval = 0.5
	player.path3D.curve = curve3d
	last_target_position = null

	# Reinicamos el proceso de la ultima curva
	clean_path()

func exit():
	clean_path()

func move_player():
	# Hacemos que siga la linea
	if player.pathFollow.progress_ratio < 1 :
		player.pathFollow.progress += player.speed

func create_curve( target_position: Vector3 ):

	if target_position != last_target_position:
		clean_path()
		curve3d.add_point(target_position)

	last_target_position = target_position

## Reiniciamos el camino del jugador
func clean_path():
	curve3d.clear_points()
	player.pathFollow.progress = 0
	curve3d.add_point(floor_vector(player.player_position))
