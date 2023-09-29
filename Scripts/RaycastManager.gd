extends Node3D

@onready var camera = get_viewport().get_camera_3d()

## Mascara de colision para solo colisionar con el suelo
@export var floor_collision_mask = 1 	# 1: Mascara del suelo
## Distancia maxima a la que llegara el raycast 
const ray_length = 1000

## Variable donde se guardara el resultado del ultimo raycast emitido
var raycast_result = null

# Variables para calcular la posicion de origen y destino del raycast
# respecto a la camara
var from = null
var to = null
	
## Calculamos los parametros para lanzar un raycast respecto a la camara
func calculate_from_to(target_position):
	from = camera.project_ray_origin(target_position)
	to = from + camera.project_ray_normal(target_position) * ray_length

## Devuelve true si los parametros para lanzar el raycast han sido calculados
func is_raycast_ready():
	return from && to

## Disparamos un raycast desde la camara hasta la posicion indicada
func shoot_raycast():
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true
	ray_query.collision_mask = floor_collision_mask
	raycast_result = space_state.intersect_ray(ray_query)

func clear_raycast():
	raycast_result = null
	from = null
	to = null

## [Debug] Dibujamos esferas para saber donde ha golpeado el raycast
func draw_debug():
	if !raycast_result.has('position'):
		return
		
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
