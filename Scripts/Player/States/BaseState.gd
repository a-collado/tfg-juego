@icon("res://Assets/Iconos/Editor/state_machine_state.svg")
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
	Fetch,
	Attack
}

## String que indica la animacion que se reproducira en este estado
@export var animation: String

## Referencia al jugador
var player: Player

## Ultimo input que se relizo
var last_movement: PackedVector3Array

## Se llamara cada vez que se entre a este estado
func enter() -> void:
	#print("Entering " + name + " state")
	player.debug_state_label.text = name
	player.animator.play(animation)

## Se llamara cada vez que se salga de este estado
func exit() -> void:
	#print("Exiting " + name + " state")
	pass

func process(_delta: float) -> int:
	return State.Null

func physics_process(_delta: float) -> int:
	return State.Null

## Enviar informacion sobre los inputs a este estado
func input(movementVector: PackedVector3Array) -> int:
	# Si se detecta movimiento, cambiamos a estado manual
	# Comprobamos que el vector no este vacio y que sea diferente al ultimo input
	if !movementVector.is_empty() && movementVector != last_movement:
		last_movement = movementVector
		return State.Manual
	return State.Null

func _floor_vector(vector: Vector3) -> Vector3:
	# Usamos floor_y para que el jugador siempre este a nivel del suelo
	return player.to_local(Vector3(vector.x,
			Global.floor_y, vector.z))
