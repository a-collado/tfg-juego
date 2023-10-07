extends Node3D

#Tambien podria usar: var camera = get_viewport().get_camera_3d()
@onready var camera = %Camera
@onready var current_line3D = PackedVector3Array()
@onready var line_renderer3D = preload("res://Addons/LineRenderer/LineRenderer.tscn").instantiate()

@export var speed = 0.1
@export var floor_y = 0
@export var floor_collision_mask = 1 	# 1: Mascara del suelo

const ray_length= 1000

var curve3d: Curve3D
var drawing = false
var running = false
var index = 0

# Variables que almacenan parametros del raycast y la camara
var raycast_result = null
var from = null
var to = null
var last_raycast_position = null

func _ready():
	add_child(line_renderer3D)

func _input(event: InputEvent) -> void:
	
	# Si no se esta pulsando no se comienza a dibujar la linea	
	if event is InputEventScreenTouch:
		if !event.is_pressed():
			drawing = false

	# Dibujamos los puntos por los que pasa el raton.
	if event is InputEventScreenDrag && drawing && index == event.get_index():

		# Obtenemos los parametros para lanzar un raycast
		from = camera.project_ray_origin(event.position)
		to = from + camera.project_ray_normal(event.position) * ray_length
		
		# Obtenemos el indice del dedo que acaba de tocar la pantalla
		index = event.get_index()
		
func _physics_process(_delta):
	
	# En caso de tener que estar dibujando una linea y se hayan calculado
	# las posiciones para lanzar el raycast (from & to):
	if drawing && from && to:
		shoot_raycast()
		save_raycast_position()
	
	array_to_curve3d()	
	follow_line()
	
# Se llama a esta funcion cuando se pulsa en el personaje
func _on_player_area_3d_player_pressed(_player):
	# En caso de que no estemos dibujando una linea:
	if drawing:
		return

	# Empezamos a dibujar
	drawing = true
	running = false

	# Eliminamos la ultima curva
	call_deferred("clean_line")
	
	# Reinicamos el proceso de la ultima curva
	$Path3D.curve = Curve3D.new()
	$Path3D/PathFollow3D.progress_ratio = 0

# Disparamos un raycast desde la camara hasta la posicion indicada
func shoot_raycast():
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	ray_query.collision_mask = floor_collision_mask
	raycast_result = space_state.intersect_ray(ray_query)
		

# Guardamos la posicion del raycast en current_line3D y en line_renderer3D
func save_raycast_position():	 
	# En caso de que el raycast haya golpeado un objeto, guardamos la posicion
	# Nos aseguramos de que no haya dos puntos iguales en la linea
	if raycast_result.has('position'):
		# Cambiamos la coordenada y por la altura del suelo para evitar errores
		var position_floored = Vector3(raycast_result.position.x, floor_y, raycast_result.position.z)
		if position_floored != last_raycast_position:
			# Añadimos la posicion del raycast al line3D
			current_line3D.append(to_local(position_floored))
			
			reset_line_renderer()

			# Sumamos un offset de 0.05 para que la textura no clippe con el suelo	
			line_renderer3D.points.append(Vector3(position_floored.x, floor_y + 0.05, position_floored.z))
			# Guardamos la anterior posicion del raycast para evitar duplicados
			last_raycast_position = position_floored

# Comprobamos si el line_renderer esta "vacio" y lo inicializamos
func reset_line_renderer():
	# Si no hacemos esto, la linea empezara en (0, 0, 0)
	if line_renderer3D.points == PackedVector3Array([Vector3.ZERO, Vector3.ZERO]):
		line_renderer3D.points = PackedVector3Array()
		
# Convertimos la array current_line3D a una curve3d y la asignamos al path3d
func array_to_curve3d():
	# Si no estamos dibujando la linea, y existe una linea dibujada
	if !drawing && current_line3D.size() > 0 && !curve3d:
		curve3d = Curve3D.new()
		
		# Añadimos todos los puntos a la Curve2d
		for i in current_line3D.size():
			curve3d.add_point(current_line3D[i])
		
		# Asignamos la curva al Path2D
		$Path3D.curve = curve3d
		
		# Colocamos el PathFollow2D al inicio de la linea
		$Path3D/PathFollow3D.progress_ratio = 0
		running = true

# Reniciamos el avance Pathfollow3D y hacemos que siga la curva del path3d
func follow_line():
	
	# Hacemos que siga la linea
	if $Path3D/PathFollow3D.progress_ratio < 1 && running:
		$Path3D/PathFollow3D.progress += speed
	# Si ya ha llegado al final de la linea:
	elif $Path3D/PathFollow3D.progress_ratio >= 1: 
		running = false
		if curve3d:
			call_deferred("clean_line")

# Borramos la linea en la pantalla y la curva del Path3D
func clean_line():
	curve3d = null
	current_line3D = PackedVector3Array()
	# Por alguna razon esta es la unica manera de borrar la linea
	line_renderer3D.points = PackedVector3Array([Vector3.ZERO, Vector3.ZERO])

# Dibujamos esferas para saber donde ha golpeado el raycast
func draw_debug():
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()
		
	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = raycast_result.position
		
	sphere_mesh.radius = 0.1
	sphere_mesh.height = 0.1*2
	sphere_mesh.material = material
		
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.AQUA
		
	get_tree().get_root().add_child(mesh_instance)	
