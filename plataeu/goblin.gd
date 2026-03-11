extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var collision_shape_attackrange: CollisionShape2D = $AttackRange/CollisionShape2D


enum State {
	ATTACK,
	HURT,
	DEATH,
	IDLE,
	CHASE
}

var state: State = State.IDLE
var health = 20
var direction = 1
var player = null
var invulnerable = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	match state:
	
		State.IDLE:
			idle_state()
	
		State.CHASE:
			chase_state()
	
		State.ATTACK:
			attack_state()
	
		State.HURT:
			hurt_state()
	
		State.DEATH:
			death_state()
	
	move_and_slide()


func idle_state():
	velocity.x = direction * SPEED
	animation_player.play("run")
	
	if is_on_wall():
		turn()
	
	if !ray_cast_2d.is_colliding():
		turn()

func chase_state():
	if player == null:
		state = State.IDLE
		return
	
	var dir = sign(player.global_position.x - global_position.x)
	
	velocity.x = dir * SPEED * 1.5
	
	if !ray_cast_2d.is_colliding():
		direction *= -1
	
	if dir > 0:
		sprite_2d.flip_h = false
		collision_shape_hitbox.position.x = 28
		collision_shape_attackrange.position.x = 26
		ray_cast_2d.position.x *= -1
	else:
		sprite_2d.flip_h = true
		collision_shape_hitbox.position.x = -28
		collision_shape_attackrange.position.x = -26
		ray_cast_2d.position.x *= -1
	
	animation_player.play("run")

func attack_state():
	velocity.x = 0
	
	if animation_player.current_animation != "attack":
		animation_player.play("attack")

func hurt_state():
	velocity.x = 0
	animation_player.play("hurt")

func death_state():
	velocity = Vector2.ZERO
	animation_player.play("death")

func turn():
	direction *= -1
	
	if direction > 0:
		sprite_2d.flip_h = false
		collision_shape_hitbox.position.x = 28
		collision_shape_attackrange.position.x = 26
		ray_cast_2d.position.x *= -1
		
	elif direction < 0:
		sprite_2d.flip_h = true
		collision_shape_hitbox.position.x = -28
		collision_shape_attackrange.position.x = -26
		ray_cast_2d.position.x *= -1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		if player != null:
			state = State.CHASE
		else:
			state = State.IDLE
	
	if anim_name == "hurt":
		if is_on_floor():
			state = State.CHASE
	
	if anim_name == "death":
		queue_free()

func take_damage(amount: int, from_position: Vector2):
	if invulnerable or state == State.DEATH:
		return
	
	health -= amount
	
	if health <= 0:
		state = State.DEATH
		return
	
	invulnerable = true
	state = State.HURT
	
	var direction = sign(global_position.x - from_position.x)
	
	velocity.x = direction * 200
	velocity.y = -250
	
	await get_tree().create_timer(0.5).timeout
	invulnerable = false

func _on_hitbox_body_entered(body) -> void:
	if body.name == "Player":
		state = State.ATTACK


func _on_detection_box_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		state = State.CHASE

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		state = State.ATTACK
