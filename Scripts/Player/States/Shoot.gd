extends BaseState

func input(movementVector) -> int:
	player.ball.shoot(movementVector)
	player.dettach_ball()
	return State.Idle
	
func shoot_ball(movementVector):
	
	var tween = player.ball.create_tween()
	
	# Hay que hacer que el tween se pare cuando toque a un jugador
	# Probablemente habria que trasladar la logica de mover la pelota
	# a un script en la propia pelota
	tween.tween_property(player.ball, "global_position", movementVector, 1)
	player.dettach_ball()
