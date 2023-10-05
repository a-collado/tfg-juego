extends Node
## Esta clase recibe todo el input del juego y lo envia a los jugadores
##
## Conecta a todos los jugadores a esta clase para detectar cada vez que se
## pulsa sobre ellos y maneja todo el input a la hora de dibujar los caminos.
## Indica cuando moverse y cuando chutar a todos los jugadores del equipo.


## Nombre del grupo al que pertenecen todos los jugadores
const team_group = "Team"
@export var team_A: Team

## Vector3 donde guardaremos los puntos de la linea que seguira el jugador
@onready var current_line3D = PackedVector3Array()
@onready var raycast_manager = $RaycastManager
@onready var click_marker = $Marker

@onready var ball: Ball = %Ball

## Coordenada 'y' a la que esta el suelo
@export var floor_y = 0

## Jugador al que se esta controlando
var selected_player: Player
var player_clicked = false

## Indica si se esta dibujando el path de un personaje
var drawing = false 
## Indice del dedo que esta tocando la pantalla
var index = 0
## Poisicion en la que impacto el ultima raycast emitido
var last_raycast_position = null

func _ready():
	# Obtenemos todos los jugadores del grupo "Team"
	var team_players = team_A.players
	
	# Conectamos la señal "player_pressed" para detectar cada vez que se pulsa un jugador
	for player in team_players:
		var area = player.player_area
		area.player_pressed.connect(self._on_player_area_player_pressed)

func _physics_process(_delta):
	
	# Si estamos dibujando un path y se puede emitir un raycast:
	if drawing && raycast_manager.is_raycast_ready():
		raycast_manager.shoot_raycast()
		save_raycast_position()
		
		# Nos aseguramos de que haya al menos 2 puntos en el path para empezar:
		if selected_player && current_line3D.size() > 2:
			selected_player.input(current_line3D, false)
		
	if !drawing && raycast_manager.is_raycast_ready():
		# Disparamos el raycast
		raycast_manager.shoot_raycast()
		# En el caso de que el raycast impacte en una superficie
		if raycast_manager.raycast_result.has('position'):
			var raycast_position = raycast_manager.raycast_result.position
				
			# Esperamos a que se procese el frame para que nos de tiempo a
			# comrobar si estamos pulsando a un jugador o no (player_clicked)
			await get_tree().process_frame
				
			# Detectamos si tenemos un jugador seleccionado, 
			# si tiene posesion de balon, y si esta siendo clicado
			if selected_player && !player_clicked:
				if ball.player != null:
					shoot_ball(raycast_position, ball.player)
				
			player_clicked = false	

## Esta funcion se llama cada vez que se toque con el dedo a un jugador
func _on_player_area_player_pressed(player: Player, event_index):
	# En caso de que ya estemos dibujando una linea:
	if drawing:
		return
	# Indicamos que empezamos a dibujar el path y guardamos el jugador	
	drawing = true
	selected_player = player
	player_clicked = true
	# Obtenemos el indice del dedo que acaba de tocar la pantalla
	index = event_index
	# Inicializamos la linea donde guardaremos los puntos del path
	current_line3D = PackedVector3Array()
	
func _input(event: InputEvent) -> void:

	# Si se detecta un unico toque en la pantalla:
	if event is InputEventScreenTouch:
		# En el caso de que no se este tocando la pantalla:
		if !event.is_pressed():
			drawing = false
			raycast_manager.clear_raycast()
		else:
			if index == event.get_index():
				# Preparamos los parametros para disparar el raycast en el punto
				# donde se ha detectado el toque
				raycast_manager.calculate_from_to(event.position) 	

	# En el caso de que se este arrastrando el dedo por la pantalla,
	# se este dibujando un path y el se este utilizando solo un dedo:
	if event is InputEventScreenDrag && drawing && index == event.get_index():
		# Calculamos los parametros para lanzar un raycast en la posicion del dedo
		raycast_manager.calculate_from_to(event.position)

func shoot_ball(raycast_position, player: Player):
	# Indicamos al jugador que cambia su estado a "Shoot" para chutar
	#selected_player.states.change_state(BaseState.State.Shoot)
	click_marker.position = Vector3(raycast_position.x, floor_y 
	+ 0.01, raycast_position.z)
	click_marker.get_child(0).play("Click")
	# Indicamos al jugador el punto donde debe chutar
	player.ball.shoot(raycast_position)
	player.dettach_ball()
	

## Guardamos la posicion del raycast en current_line3D
func save_raycast_position():	
	# En caso de que el raycast haya golpeado un objeto, guardamos la posicion
	# Nos aseguramos de que no haya dos puntos iguales en la linea
	if raycast_manager.raycast_result.has('position'):
		var raycast_result = raycast_manager.raycast_result
		# Cambiamos la coordenada y por la altura del suelo para evitar errores
		var position_floored = Vector3(raycast_result.position.x, floor_y, raycast_result.position.z)
		if position_floored != last_raycast_position:
			# Añadimos la posicion del raycast al line3D
			current_line3D.append(position_floored)
			# Guardamos la posicion actual para evitar repeticiones
			last_raycast_position = position_floored
