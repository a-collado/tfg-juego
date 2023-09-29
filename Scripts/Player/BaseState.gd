extends Node
class_name BaseState
## Base para todos los posibles estados del jugador
##
## Implementa las funciones basicas que todos los estados tienen que tener
## para que la maquina de estados funcione. Cada funcion devuelve un estado
## al que cambiar. Si se devuelve null, significa que no se cambia de estado

## Todos los posibles estados
enum State {
	Null,
	Manual,
	Idle,
	Shoot
}

## String que indica la animacion que se reproducira en este estado
@export var animation: String

## Referencia al jugador
var player: Player

func _ready():
	pass
	
func _process(_delta):
	pass

## Se llamara cada vez que se entre a este estado
func enter():
	#print("Entering " + name + " state")
	player.debug_state_label.text = name
	player.animator.play(animation)

## Se llamara cada vez que se salga de este estado
func exit():
	#print("Exiting " + name + " state")
	pass

func process(_delta: float) -> int:
	return State.Null
	
func physics_process(_delta: float) -> int:
	return State.Null	

## Enviar informacion sobre los inputs a este estado
func input(_movementVector, shooting) -> int:
	return State.Null
