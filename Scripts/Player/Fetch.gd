extends BaseState
## Hay que comentar esta clase

var curve3d: Curve3D
var last_ball_position

func enter():
	player.debug_state_label.text = name
	player.animator.play(animation)
	
	# Reinicamos el proceso de la ultima curva
	clean_path()
	
	curve3d.add_point(player.pathFollow.position)

func exit():
	clean_path()

func physics_process(_delta: float) -> int:
	#print(player.ball.global_position)
	if player.ball.player != null:
		return BaseState.State.Idle
	
	var ball_position = player.to_local(Vector3(player.ball.position.x, 
			player.floor_y, player.ball.position.z))	
	if ball_position != last_ball_position:
		curve3d.add_point(ball_position)	
		last_ball_position = ball_position
			
	
	# Hacemos que siga la linea
	if player.pathFollow.progress_ratio < 1 :
		player.pathFollow.progress += player.speed
		
	return BaseState.State.Null

## Reiniciamos el camino del jugador	
func clean_path():
	curve3d = Curve3D.new()
	curve3d.bake_interval = 0.5 # No se si bajar esto podria hacer que se viera más fluido, habria que probar
	player.path3D.curve = curve3d
	curve3d.clear_points()
	player.pathFollow.progress = 0
	last_ball_position = null
	
