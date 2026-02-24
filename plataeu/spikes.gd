extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var move_up = true
var Speed = 49

func _process(delta: float) -> void:
	animated_sprite_2d.play("default")
	if move_up == true:
		if collision_shape_2d.position.y >= -24 :
			collision_shape_2d.position.y -= Speed * delta
		else:
			move_up = false
	elif move_up == false:
		if collision_shape_2d.position.y <= 24:
			collision_shape_2d.position.y += Speed * delta
		else:
			move_up = true
