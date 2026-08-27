extends Node2D
class_name BobzinhoController

var level_manager: LevelManager
var bobzinhos: Array[LittlePlayer] = []


func append_bobzinho(bob: LittlePlayer):
	bobzinhos.append(bob)


func clear():
	for bob in bobzinhos:
		bob.queue_free()
	bobzinhos.clear()
