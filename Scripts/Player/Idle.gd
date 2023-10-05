extends BaseState

func exit():
	#print("Exiting " + name + " state")
	pass

func physics_process(_delta: float) -> int:
	var ball_player = player.ball.player
	if  ball_player == null:
		return State.Fetch
	return State.Null	
