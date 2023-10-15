extends BaseState

## Curva que contiene los puntos del path que ha de seguir el jugador
var curve3d: Curve3D

func enter() -> void:
	player.debug_state_label.text = name
	player.animator.play(animation)

	curve3d = Curve3D.new()
	curve3d.bake_interval = 0.2 # No se si bajar esto podria hacer que se viera más fluido, habria que probar
	player.path3D.curve = curve3d

	# Reinicamos el proceso de la ultima curva
	clean_path()
	_reset_line_renderer()

func exit() -> void:
	clean_path()

func input(movementVector) -> int:
	return _create_curves(movementVector)

## Creamos la curva que seguira el jugador en base a un Vector de coordenadas
func _create_curves(movementVector) -> int:
	# Comprovamos si se ha empezado a crear una nueva linea
	if movementVector.size() < curve3d.point_count:
		# Hacemos que el jugador deje de recorrer la linea actual
		clean_path()
		_reset_line_renderer()

	# Añadimos todos los puntos de la linea a la Curve3d
	for i in movementVector.size():
		if i > curve3d.point_count:
			curve3d.add_point(_floor_vector(movementVector[i]))
			# Añadimos un pequeño offset a floor_y para que se renderize correctamente la linea
			player.line_renderer3D.points.append((Vector3(movementVector[i].x,
			Global.floor_y + 0.05, movementVector[i].z)))
	return State.Null

func physics_process(_delta: float) -> int:

	# Hacemos que siga la linea
	if player.pathFollow.progress_ratio < 1 :
		player.pathFollow.progress += player.speed
		_trim_line_to_player()

	# Si ya ha llegado al final de la linea:
	elif player.pathFollow.progress_ratio >= 1:
		return State.Idle
	# Continuamos en este estado
	return State.Null

## Reiniciamos el camino del jugador
func clean_path() -> void:
	curve3d.clear_points()
	player.pathFollow.progress_ratio = 0

	curve3d.add_point(_floor_vector(player.player_position))

	# Por alguna razon esta es la unica manera de borrar la linea
	player.line_renderer3D.points = PackedVector3Array([Vector3.ZERO, Vector3.ZERO])

## Comprobamos si el line_renderer esta "vacio" y lo inicializamos
func _reset_line_renderer() -> void:
	# Si no hacemos esto, la linea empezara en (0, 0, 0)
	if player.line_renderer3D.points == PackedVector3Array([Vector3.ZERO, Vector3.ZERO]):
		player.line_renderer3D.points = PackedVector3Array()

## Codigo para encontrar el punto más cercano  "point" en una array
func _find_closest_node_to_point(array, point):
	var closest_node = null
	var closest_node_distance = 0.0
	var iterations = 0
	for i in array:
		if iterations < 5: # Maximo de iteraciones para evitar problemas
			var current_node_distance = point.distance_to(player.to_global(i))
			if closest_node == null or current_node_distance < closest_node_distance:
				closest_node = i
				closest_node_distance = current_node_distance
		iterations += 1
	return closest_node

## Hacemos que la linea que indica el Path se empiece a dibujar en los pies del jugador
func _trim_line_to_player() -> void:
	# Obtenemos la posicion actual del jugador
	var player_position = player.pathFollow.position
	# Hacemos que y esta a la misma altura que la linea dibujada
	player_position.y = Global.floor_y + 0.05
	# Encontramos el punto más cercano al jugador
	var nearest_point = _find_closest_node_to_point(player.line_renderer3D.points, player_position)
	if nearest_point is Vector3:
		# Hacemos que la linea empiece a dibujarse a partir del punto
		player.line_renderer3D.points = player.line_renderer3D.points.slice(
		player.line_renderer3D.points.find(nearest_point),
		player.line_renderer3D.points.size())
