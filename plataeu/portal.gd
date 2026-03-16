extends Area2D

@onready var gpu_particles_2d: GPUParticles2D = $"../GPUParticles2D"
@onready var timer: Timer = $Timer



func _on_body_entered(_body: Node2D) -> void:
	$"../GPUParticles2D".restart()
	$Timer.start()


func _on_timer_timeout() -> void:
	global.unlockedlevels += 1
	get_tree().change_scene_to_file("res://levels//level"+ str(global.unlockedlevels) +".tscn")
