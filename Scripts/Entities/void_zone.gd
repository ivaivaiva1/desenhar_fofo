extends ColorRect

@onready var collision: CollisionShape2D = %Collision
@onready var block_col: CollisionShape2D = %BlockCol
@onready var margin: ColorRect = %margin
var size_increase: float = 300


func _ready() -> void:
	collision.position += size / 2
	block_col.position += size / 2
	
	margin.size = size - Vector2(size_increase, size_increase)
	margin.position = Vector2(size_increase / 2, size_increase / 2)
	
	var shape := collision.shape as RectangleShape2D
	shape.size = margin.size
	
	var block_shape := block_col.shape as RectangleShape2D
	block_shape.size = size
