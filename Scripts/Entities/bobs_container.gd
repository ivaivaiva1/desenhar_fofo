extends Node2D
class_name BobContainer

var level_manager: LevelManager


func auto_destroy():
	queue_free()
