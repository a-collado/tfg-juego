extends BaseState

@onready var nav_agent = $"../../Path3D/PathFollow3D/NavigationAgent3D"

var curve3d: Curve3D

func enter():
	player.debug_state_label.text = name
	player.animator.play(animation)
	
	# Reinicamos el proceso de la ultima curva
	clean_path()

func exit():
	clean_path()

func physics_process(_delta: float) -> int:
	#print(player.ball.global_position)
	if player.ball.player != null:
		return BaseState.State.Idle
		
	nav_agent.set_target_position(player.ball.global_position)
	
	var next_point = nav_agent.get_next_path_position()
	if next_point != Vector3.ZERO:
		curve3d.add_point(player.to_local(Vector3(next_point.x, 
		player.floor_y, next_point.z)))
	
	
	
	# Añadimos todos los puntos de la linea a la Curve3d		
	#for i in nav_path.size():
	#	if i > curve3d.point_count:
	#		# Usamos floor_y para que el jugador siempre este a nivel del suelo
	#		curve3d.add_point(player.to_local(Vector3(nav_path[i].x, 
	#		player.floor_y, nav_path[i].z)))
	
	# Hacemos que siga la linea
	if player.pathFollow.progress_ratio < 1 :
		player.pathFollow.progress += player.speed
		
	return BaseState.State.Null

## Reiniciamos el camino del jugador	
func clean_path():
	curve3d = Curve3D.new()
	curve3d.bake_interval = 0.5 # No se si bajar esto podria hacer que se viera más fluido, habria que probar
	player.path3D.curve = curve3d
	player.pathFollow.progress_ratio = 0
	
