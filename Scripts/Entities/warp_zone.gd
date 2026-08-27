extends Area2D

var player: Player


func _process(_delta: float) -> void:
	if player == null: return
	if player.global_position.y > 1080.0:
		SfxManager.play_sfx(SoundsList.JUMP_JDWASABI)
		player.global_position.y = 1
	if player.global_position.y < 0:
		SfxManager.play_sfx(SoundsList.JUMP_JDWASABI)
		player.global_position.y = 1079.0


func _on_area_entered(area: Area2D) -> void:
	if player != null: return
	if area.is_in_group("Player"):
		player = area.get_parent() as Player



func _on_area_exited(area: Area2D) -> void:
	if player == null: return
	var exited_object := area.get_parent()
	if exited_object == player:
		player = null
		print("saiu")
