extends Node

class_name LineCollider

var bodies: Array[StaticBody2D] = []
var lines: Array[Line] = []


func add_line(line: Line):
	lines.append(line)
	_build_collision(line)


func remove_line(line: Line):
	var index = lines.find(line)
	if index == -1: return
	
	lines.remove_at(index)
	
	var body = bodies[index]
	body.queue_free()
	bodies.remove_at(index)


func clear():
	for body in bodies:
		body.queue_free()
	
	bodies.clear()
	lines.clear()


func _build_collision(line: Line):
	if line.source_points.size() < 2:
		return
	
	var body = StaticBody2D.new()
	body.add_to_group("Line")
	var physics_material := PhysicsMaterial.new()
	physics_material.bounce = 0
	physics_material.absorbent = true
	physics_material.friction = 0
	
	body.physics_material_override = physics_material
	
	get_tree().current_scene.add_child(body)
	
	var points = line.source_points
	var thickness := 20.0
	
	for i in range(points.size() - 1):
		var a = points[i]
		var b = points[i + 1]
		
		var segment = CollisionShape2D.new()
		var shape = CapsuleShape2D.new()
		
		var direction = b - a
		var length = direction.length()
		
		shape.radius = thickness / 2.0
		shape.height = length + thickness
		
		segment.shape = shape
		segment.position = (a + b) / 2.0
		segment.rotation = direction.angle() + PI / 2
		
		body.add_child(segment)
	
	bodies.append(body)
