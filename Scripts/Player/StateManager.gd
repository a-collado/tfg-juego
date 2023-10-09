extends Node
## Maquina de estados finita que contiene todos los poibles comportamientos
## de un jugador

## Esta actual de la maquina
var current_state: BaseState

## Todos los posibles estados
@onready var states = {
	BaseState.State.Idle: $Idle,
	BaseState.State.Manual: $Manual,
	BaseState.State.Fetch: $Fetch,
	BaseState.State.Attack: $Attack,
}

## Inicializamos todos los posibles estados
func init(player: Player):
	for child in get_children():
		if child is BaseState:
			child.player = player

	## El estado inicial sera "Idle"
	change_state(BaseState.State.Idle)

func change_state(new_state: int):
	if current_state:
		current_state.exit()

	current_state = states[new_state]
	current_state.enter()

func physics_process(delta: float):
	var new_state = current_state.physics_process(delta)
	if new_state != BaseState.State.Null:
		change_state(new_state)

func input(movementVector, shooting):
	var new_state = current_state.input(movementVector, shooting)
	if new_state != BaseState.State.Null:
		change_state(new_state)
