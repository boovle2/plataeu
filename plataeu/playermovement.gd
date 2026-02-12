extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var attack: bool = false

func _physics_process(delta: float) -> void:
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	# Attack input (maar 1x per klik)
	if Input.is_action_just_pressed("attack1") and not attack:
		attack = true
		velocity.x = 0
		animated_sprite_2d.play("attack_")

	# Normale animaties (alleen als je niet aanvalt)
	if not attack:
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("jump")

	move_and_slide()


# Wordt automatisch aangeroepen wanneer een animatie klaar is
func _on_AnimatedSprite2D_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack_":
		attack = false
