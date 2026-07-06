extends ColorRect

@onready var collision: CollisionShape2D = %Collision

func _ready() -> void:
	collision.position += size / 2 
	var shape := collision.shape as RectangleShape2D
	shape.size = size
