extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var health = 10
var attack: bool = false
var hurt: bool = false
var invulnerable: bool = false

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
	if Input.is_action_just_pressed("attack1") and not attack and not hurt:
		attack = true
		velocity.x = 0
		animated_sprite_2d.play("attack_")

	# Normale animaties (alleen als je niet aanvalt)
	if not attack and not hurt:
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("jump")
	
	if invulnerable:
		animated_sprite_2d.visible = sin(Time.get_ticks_msec() * 0.02) > 0
	else:
		animated_sprite_2d.visible = true
	
	move_and_slide()


# Wordt automatisch aangeroepen wanneer een animatie klaar is
func _on_AnimatedSprite2D_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack_":
		attack = false


func take_damage(amount: int, from_position: Vector2) -> void:
	if invulnerable:
		return
	
	print("take damage")
	invulnerable = true 
	hurt = true
	
	var direction = sign(global_position.x - from_position.x)
	velocity.x = direction * 250
	velocity.y = -200
	
	animated_sprite_2d.play("hurt")
	
	await get_tree().create_timer(1.0).timeout
	hurt = false
	invulnerable = false 
