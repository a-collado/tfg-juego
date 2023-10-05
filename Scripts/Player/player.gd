extends Node3D
class_name Player
## Inicia la maquina de estados del jugador y guarda componentes importantes
##
## Se inician todos los precesos para poner en marcha la maquina de estados
## y se guardan referencias a todos los nodos importantes del jugador
## para que puedan ser usados por la maquina de estados.
## Tambien maneja la posesion del balon

## Maquina de estados que maneja el comportamiento del jugador 
@onready var states = $"State Manager"
## Linea que seguira el PathFollow3D
@onready var path3D: Path3D = $Path3D
## Nodo encargado de seguir la linea que indica el camino del jugador
@onready var pathFollow: PathFollow3D = $Path3D/PathFollow3D
## Nodo que se encarga de de dibujar una linea en 2D en el espacio 3D
@onready var line_renderer3D = $LineRenderer
## Area que detecta cuando cuando cuando se selecciona un jugador
@onready var player_area: Area3D = $Path3D/PathFollow3D/Sprite3D/PlayerArea3D
## Nodo que reproduce las animaciones del jugador
@onready var animator: AnimationPlayer = $Path3D/PathFollow3D/Sprite3D/AnimationPlayer

@onready var ball_timer: Timer = $Timer

@onready var ball: Ball = %Ball

## [Debug] Texto que indica el estado actual del jugador 
@onready var debug_state_label = $Path3D/PathFollow3D/Sprite3D/debug_state_label

## Coordenada 'y' del suelo
@export var floor_y = 0

## Velocidad a la que se movera el jugador
@export var speed = 0.1

## Tiempo que tiene que pasar para que un jugador pueda volver a tener el balon
var ball_cooldown = 0.5

## Indica si el jugador esta en posesion del balon
#var ball_possesion = false
## Variable donde guardaremos el balon cuando el jugador tenga posesion

func _ready():
	states.init(self)
	ball_timer.wait_time = ball_cooldown

func _physics_process(delta):
	states.physics_process(delta)

## Shooting indica si se esta moviendo o esta chutando
## true: Chutando	false: Moviendose
func input(movementVector, shooting):
	states.input(movementVector, shooting)

## Se llama cuando un area entra en contacto con 'player_area'
func _on_player_area_3d_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	# Comprobamos si el jugador ha tocado la pelota
	var ball = area.get_parent()
	if ball is Ball && ball.player == null:
		attach_ball(area)

## Transferimos la posesion del balon al jugador
func attach_ball(area):
	# Esto aun esta a medias:
	if !ball_timer.is_stopped():
		return
	ball.player = self
	ball = area.get_parent()
	ball.stop()
	ball.collision_shape.set_deferred("disabled", true)
	ball.reparent(pathFollow)
	ball.position = Vector3(0, 0.004, 0.75)

## Retiramos la posesion del balon al jugador
func dettach_ball():
	# Esto aun esta a medias:
	ball.collision_shape.set_deferred("disabled", false)
	ball.reparent(get_tree().get_root())
	ball.player = null
	ball_timer.start()
