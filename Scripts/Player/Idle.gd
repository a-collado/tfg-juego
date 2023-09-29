extends BaseState

## Ultimo input que se relizo
var last_movement

func exit():
	#print("Exiting " + name + " state")
	pass

func input(movementVector, shooting) -> int:
	# Si se detecta movimiento, cambiamos a estado manual
	# Comprobamos que el vector no este vacio y que sea diferente al ultimo input
	if movementVector != PackedVector3Array([]) && movementVector != last_movement:
		last_movement = movementVector
		return State.Manual
	return State.Null
