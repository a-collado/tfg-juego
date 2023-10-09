extends Node

@export var team_A: Team
@export var team_B: Team

@onready var ball: Ball = %Ball

var inital_positions: PackedVector3Array

func _ready() -> void:
	for player in team_A.players:
		inital_positions.append(player.player_position)
	for player in team_B.players:
		inital_positions.append(player.player_position)
	inital_positions.append(ball.global_position)

func reset_positions():
	var i: int = 0
	for player in team_A.players:
		player.player_position = inital_positions[i]
		i += 1
	for player in team_B.players:
		player.player_position = inital_positions[i]
		i += 1
	ball.player.dettach_ball()
	ball.global_position = inital_positions[i]

func _on_goal_B_entered(area):
#	if area.get_parent() is Ball:
#		var ball_player = area.get_parent().player
#		if ball_player != null && ball_player.team == team_A:
#			print("Golazo del equipo A")
	if "player" in area:
		var player = area.player
		if ball.player == player && player.team == team_A:
			print("Golazo del equipo A")
			reset_positions()

func _on_goal_A_entered(area):
#	if area.get_parent() is Ball:
#		var ball_player = area.get_parent().player
#		if ball_player != null && ball_player.team == team_B:
#			print("Golazo del equipo A")
	if "player" in area:
		var player = area.player
		if ball.player == player && player.team == team_B:
			print("Golazo del equipo B")
			reset_positions()
