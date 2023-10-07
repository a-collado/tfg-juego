extends BaseState

func physics_process(_delta: float) -> int:
#	if player.ball.player == null:
#		return State.Fetch

	var ball_player = player.ball.player
	if ball_player == null || ball_player.team != player.team:
		return State.Fetch
	return State.Null
