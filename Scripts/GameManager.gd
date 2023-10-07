extends Node

@export var team_A: Team
@export var team_B: Team
#@export var goal_A: Area3D
#@export var goal_B: Area3D


func _on_goal_B_entered(area):
	if area.get_parent() is Ball:
		var ball_player = area.get_parent().player
		if ball_player != null && ball_player.team == team_A:
			print("Golazo del equipo A")

func _on_goal_A_entered(area):
	if area.get_parent() is Ball:
		var ball_player = area.get_parent().player
		if ball_player != null && ball_player.team == team_B:
			print("Golazo del equipo A")
