extends Node2D
class_name Collectable

@export var entity_type: SkinPicker.ENTITY_TYPE
@export var frame_freeze: bool = false
var is_picked: bool = false
@onready var sprite:= %Sprite
@export var is_papagaio: bool = false
var can_be_picked: bool = true


func _ready() -> void:
	if entity_type != SkinPicker.ENTITY_TYPE.NULL: SkinPicker.change_skin(entity_type, sprite)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_picked: return
	if !can_be_picked: return
	if area.is_in_group("Player"):
		if frame_freeze: HitFreeze.freeze()
		make_picked()
		if is_papagaio: papagaio_collected()
		var player: Player = area.get_parent() as Player
		player.pump_yuumy()


func papagaio_collected():
	HitFreeze.freeze()
	ScreenShake.do_screen_shake(5, 0.15)


func make_picked():
	if !can_be_picked: return
	is_picked = true
	sprite.visible = false


func make_unpicked():
	if !is_picked: return
	is_picked = false
	sprite.visible = true
	can_be_picked = true
