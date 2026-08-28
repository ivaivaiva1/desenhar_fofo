extends Node2D
class_name BobzinhoController

var level_manager: LevelManager
var bobzinhos: Array[LittlePlayer] = []


func append_bobzinho(bob: LittlePlayer):
	bobzinhos.append(bob)
	bob.controller = self 


func kill(bob: LittlePlayer):
	if !bobzinhos.has(bob): return
	bobzinhos.erase(bob)
	bob.queue_free()
	
	if bobzinhos.is_empty():
		level_manager.start_drawning()


func clear():
	if bobzinhos.is_empty(): return
	for bob in bobzinhos:
		bob.queue_free()
	bobzinhos.clear()
