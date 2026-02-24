extends CharacterBody2D

@onready var timer: Timer = %Timer


var Speed = 300

func _process(delta: float) -> void:
	position.x += Speed * delta
	if position.x > 5000.0:
		position.x = -100
		position.y = randf_range(40, 500)



func _on_timer_timeout() -> void:
	position.x = 20
