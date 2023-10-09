extends BaseMovingState

func physics_process(_delta: float) -> int:

	var ball_player = player.ball.player
	if ball_player == null || ball_player.team != player.team:
		return BaseState.State.Idle

	var goal = player.team.goal_target
	var goal_position = floor_vector(goal.global_position)

	create_curve(goal_position)
	move_player()

	return BaseState.State.Null
