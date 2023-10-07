#TODO: Probar a usar los touch inputs personalziados para cambiarlo a solo 1 touch
#	 : Hacer que no puedas darle a dos jugadores a al vez
extends Node2D

@onready var current_line2D = Line2D.new()
@export var speed = 5

var curve2d: Curve2D
var drawing = false
var running = false
var index = 0

func _ready():
	add_child(current_line2D)
	
func _input(event: InputEvent) -> void:
	
	# Si no se esta pulsando no se comienza a dibujar la linea	
	if event is InputEventScreenTouch:
		if !event.is_pressed():
			drawing = false

	# Dibujamos los puntos por los que pasa el raton.	
	if event is InputEventScreenDrag && drawing && index == event.get_index():
		# Mapeamos las coordenadas de la pantalla para que coincidan
		var x = map(event.get_position().x, 0, get_canvas_transform().get_origin().x*2, get_canvas_transform().get_origin().x*(-2), get_canvas_transform().get_origin().x*2)
		var y = map(event.get_position().y, 0, get_canvas_transform().get_origin().y*2, get_canvas_transform().get_origin().y*(-2), get_canvas_transform().get_origin().y*2)
		current_line2D.add_point(to_local(Vector2(x,y)))
		index = event.get_index()

func _physics_process(_delta):
	
	# Si no estamos dibujando la linea, y existe una linea dibujada
	if !drawing && current_line2D.points.size() > 0 && !curve2d:
		curve2d = Curve2D.new()
		
		# Añadimos todos los puntos a la Curve2d
		for i in current_line2D.points.size():
			curve2d.add_point(current_line2D.points[i])

		# Asignamos la curva al Path2D	
		$Path2D.curve = curve2d
		
		# Colocamos el PathFollow2D al inicio de la linea
		$Path2D/PathFollow2D.progress_ratio = 0
		running = true
		
		# Hacemos que siga la linea
	if $Path2D/PathFollow2D.progress_ratio < 1 && running:
		$Path2D/PathFollow2D.progress += speed
		# Si ya ha llegado al final de la linea:
	elif $Path2D/PathFollow2D.progress_ratio >= 1: 
		running = false
		clean_line()

# Señal que se activa al pulsar sobre el Area2D del jugador
func _on_area_2d_player_pressed():
	# En caso de que no estemos dibujando una linea:
	if !drawing:
		# Empezamos a dibujar
		drawing = true
		running = false
		
		# Eliminamos la ultima curva
		clean_line()
		
		# Reinicamos el proceso de la ultima curva
		$Path2D.curve = Curve2D.new()
		$Path2D/PathFollow2D.progress_ratio = 0

# Borramos la linea en la pantalla y la curva del Path2D
func clean_line():
	curve2d = null
	current_line2D.points = PackedVector2Array()

# Funcion para mapear entre 2 valores
func map (value : float, from1: float, to1: float, from2: float, to2: float):
	return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
