extends Node

@export var base_bus := "Music"

var current_player: AudioStreamPlayer = null
var current_playing_music 


func get_valid_bus() -> String:
	if AudioServer.get_bus_index(base_bus) == -1:
		push_warning("Audio bus '%s' does not exist. Falling back to Master." % base_bus)
		return "Master"
	return base_bus

# toca musica instantaneamente - delay opcional
func play_instant(music_data: Dictionary, delay: float = 0.0) -> void:
	if delay > 0.0:
		await get_tree().create_timer(delay).timeout
	
	
	var player := AudioStreamPlayer.new()
	player.bus = get_valid_bus()
	player.stream = music_data["stream"]
	player.volume_db = music_data["volume"]
	add_child(player)
	player.play()
	
	current_player = player
	current_playing_music = music_data["stream"]


# toca musica com fade-in - delay opcional
func play_with_fade_in(music_data: Dictionary, fade_time: float = 1.5, delay: float = 0.0) -> void:
	if delay > 0.0:
		await get_tree().create_timer(delay).timeout
	
	
	var player := AudioStreamPlayer.new()
	player.bus = get_valid_bus()
	player.stream = music_data["stream"]
	player.volume_db = -30.0  # começa silencioso
	add_child(player)
	player.play()
	
	
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(player, "volume_db", music_data["volume"], fade_time)
	
	
	current_player = player
	current_playing_music = music_data["stream"]
	await tween.finished


# da fade-out e para a musica
func fade_out(duration: float = 1.5) -> void:
	if current_player == null: return
	
	var player: AudioStreamPlayer = current_player
	var tween := get_tree().create_tween()
	tween.tween_property(player, "volume_db", -30.0, duration)
	await tween.finished
	
	if current_player == player:
		current_player = null
	if current_playing_music:
		current_playing_music = ""
	player.stop()
	player.queue_free()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
