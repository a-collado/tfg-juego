extends BaseMovingState
## Hay que comentar esta clase

var last_ball_position

func enter():
	player.debug_state_label.text = name
	player.animator.play(animation)
	
	# Inicializamos la curve3D
	curve3d = Curve3D.new()
	curve3d.bake_interval = 0.5
	player.path3D.curve = curve3d
	last_ball_position = null
	
	# Reinicamos el proceso de la ultima curva
	clean_path()

func physics_process(_delta: float) -> int:

#	if player.ball.player != null:
#		return BaseState.State.Idle
	var ball_player = player.ball.player
	if ball_player != null && ball_player.team == player.team:
		return BaseState.State.Idle
		
	create_curve()
	move_player()
		
	return BaseState.State.Null

func create_curve():
	var ball_position = player.to_local(Vector3(player.ball.global_position.x, 
						player.floor_y, player.ball.global_position.z))	
	if ball_position != last_ball_position:
		clean_path()
		curve3d.add_point(ball_position)
	
	last_ball_position = ball_position
