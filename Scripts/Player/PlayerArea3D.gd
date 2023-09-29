extends Area3D
## Area3D que detecta cuando se toca a un jugador con el dedo

## Señal que se llamara cada vez que un jugador sea pulsado
signal player_pressed

## Referencia a el jugador que esta siendo pulsado
@onready var player: Player = $"../../../.."

func _input_event(_camera, event, _position, _normal, _shape_idx):
	
	# Si al Area3D es tocada por un Touch Input emitimos la señal
	if event is InputEventScreenTouch:
		if event.pressed:
			player_pressed.emit(player, event.get_index())
