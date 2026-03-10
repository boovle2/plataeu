extends Area2D

@onready var gpu_particles_2d: GPUParticles2D = $"../GPUParticles2D"
@onready var timer: Timer = $Timer



func _on_body_entered(_body: Node2D) -> void:
	$Timer.start()
	$"../GPUParticles2D".restart()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://home_screen.tscn")
