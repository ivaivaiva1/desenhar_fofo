extends Node2D

@onready var player: RigidBody2D = get_parent()
var player_velocity: Vector2


var void_tween: Tween
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("VoidZone"):
		player.freeze = true
		player_velocity = player.linear_velocity
		player.linear_velocity = Vector2.ZERO
		
		var direction := player_velocity.normalized()
		var target_position := player.global_position + direction * 1200
		
		if void_tween: void_tween.kill()
		void_tween = create_tween()
		void_tween.tween_property(player, "global_position", target_position, 1.0)



func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("VoidZone"):
		void_tween_finished()


func void_tween_finished():
	if void_tween: void_tween.kill()
	player.freeze = false
	player.linear_velocity = player_velocity
	player_velocity = Vector2.ZERO
