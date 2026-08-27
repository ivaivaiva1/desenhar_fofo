extends Area2D

var player: Player
var little_bobs: Array[LittlePlayer] = []


func _process(_delta: float) -> void:
	if player != null:
		if player.global_position.y > 1080.0:
			SfxManager.play_sfx(SoundsList.JUMP_JDWASABI)
			player.global_position.y = 1
		if player.global_position.y < 0:
			SfxManager.play_sfx(SoundsList.JUMP_JDWASABI)
			player.global_position.y = 1079.0
	elif little_bobs.size() > 0:
		for bobzinho in little_bobs:
			if bobzinho.global_position.y > 1080.0:
				SfxManager.play_sfx(SoundsList.JUMP_JDWASABI)
				bobzinho.global_position.y = 1
			if bobzinho.global_position.y < 0:
				SfxManager.play_sfx(SoundsList.JUMP_JDWASABI)
				bobzinho.global_position.y = 1079.0


func _on_area_entered(area: Area2D) -> void:
	if player != null: return
	if area.is_in_group("Player"):
		var area_parent = area.get_parent()
		if area_parent is Player: 
			player = area_parent as Player
		elif area_parent is LittlePlayer:
			little_bobs.append(area_parent)



func _on_area_exited(area: Area2D) -> void:
	var exited_object := area.get_parent()
	if exited_object == player:
		player = null
	elif exited_object is LittlePlayer:
		for bobzinho in little_bobs:
			if exited_object == bobzinho:
				little_bobs.erase(bobzinho)
