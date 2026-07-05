extends Marker2D

@export var entity_type: SkinPicker.ENTITY_TYPE
@onready var sprite: Sprite2D = %Sprite


func _ready() -> void:
	SkinPicker.change_skin(entity_type, sprite)
