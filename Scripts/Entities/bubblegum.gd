extends Node2D
class_name Bubblegum

var is_alive: bool = true
var player: Player
var has_player: bool = false
var jump_cd: float = 0.01
var jump_timer: float 
@onready var sprite: AnimatedSprite2D = %Sprite

@export var is_horizontal: bool = false
@export var is_right: bool = false
@export var is_up: bool = false

var jump_x: float 
var jump_y: float


func _ready() -> void:
	set_degrees()
	set_force()


func set_force():
	if is_horizontal:
		jump_y = -600
		if is_right:
			jump_x = 600
		else:
			jump_x = -600
	else:
		jump_x = 0
		if is_up:
			jump_y = -1200
		else:
			jump_y = 1500


func _process(delta: float) -> void:
	if player == null:
		bubble_reset()
	if has_player:
		if jump_timer > 0:
			jump_timer -= delta
		else:
			release_player()


func release_player():
	sprite.play("destroy")
	sprite.rotation_degrees = 0
	has_player = false
	if player.get_parent() != get_tree().current_scene: 
		player.reparent(get_tree().current_scene)
	player.freeze = false
	player.player_jump(jump_x, jump_y)



var tween: Tween
func move_player_to_me() -> void:
	if player == null: return
	if player.get_parent() != self: 
		player.reparent(self)
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player, "position", Vector2.ZERO, 0.7)
	
	await tween.finished
	if player == null: return
	has_player = true
	jump_timer = jump_cd



func _on_area_2d_area_entered(area: Area2D) -> void:
	if !is_alive: return
	if has_player: return
	if area.is_in_group("Player"):
		is_alive = false
		player = area.get_parent() as Player
		player.linear_velocity = Vector2.ZERO
		player.angular_velocity = 0.0
		player.set_deferred("freeze", true)
		
		call_deferred("move_player_to_me")


func bubble_reset() -> void:
	sprite.play("default")
	set_degrees()
	is_alive = true
	has_player = false
	
	jump_timer = 0.0
	
	if tween:
		tween.kill()
		tween = null
	
	if player:
		if player.get_parent() != get_tree().current_scene:
			player.reparent(get_tree().current_scene)
		
		player.freeze = false
		player.linear_velocity = Vector2.ZERO
		player.angular_velocity = 0.0
		player = null


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed: 
			change_direction()


func change_direction():
	#if CurrentLevel.level_manager.current_state == CurrentLevel.level_manager.GAME_STATE.ROLLING: return
	if is_horizontal:
		if is_right:
			is_right = false
		else:
			is_right = true
	else:
		if is_up:
			is_up = false
		else:
			is_up = true
	set_degrees()
	set_force()


func set_degrees():
	if is_horizontal:
		if is_right:
			sprite.rotation_degrees = -56
		else:
			sprite.rotation_degrees = 125
	else:
		if is_up:
			sprite.rotation_degrees = -147.0
		else:
			sprite.rotation_degrees = 33
