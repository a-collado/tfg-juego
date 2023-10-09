extends BaseMovingState
## Hay que comentar esta clase

func physics_process(_delta: float) -> int:

	var ball_player = player.ball.player
	if ball_player != null && ball_player.team == player.team:
		return BaseState.State.Idle

	var ball_position = floor_vector(player.ball.global_position)

	create_curve(ball_position)
	move_player()

	return BaseState.State.Null
