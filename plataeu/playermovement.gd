extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

enum State {
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	ATTACK,
	RUN_ATTACK,
	JUMP_ATTACK,
	CROUCH_ATTACK,
	HURT,
	DEATH
}

var state: State = State.IDLE
var health = 10
var invulnerable = false
var crouch_pressed = false


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if velocity.y > 0 and animation_player.current_animation != "jump_attack":
		state = State.FALL
	
	match state:
	
		State.IDLE:
			idle_state(direction)
	
		State.RUN:
			run_state(direction)
	
		State.JUMP:
			jump_state(direction)
	
		State.FALL:
			fall_state(direction)
	
		State.CROUCH:
			crouch_state(direction)
	
		State.ATTACK:
			attack_state()
	
		State.RUN_ATTACK:
			run_attack_state(direction)
	
		State.JUMP_ATTACK:
			jump_attack_state(direction)
	
		State.CROUCH_ATTACK:
			crouch_attack_state()
	
		State.HURT:
			hurt_state()
	
		State.DEATH:
			death_state()
	
	move_and_slide()


func idle_state(direction):
	if Input.is_action_pressed("ui_down"):
		state = State.CROUCH
		return
	
	animation_player.play("idle")
	
	velocity.x = 0
	
	if direction != 0:
		state = State.RUN
	if Input.is_action_just_pressed("attack1"):
		state = State.ATTACK
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		state = State.JUMP

func run_state(direction):
	if Input.is_action_pressed("ui_down"):
		state = State.CROUCH
		return
	
	animation_player.play("run")
	
	velocity.x = direction * SPEED
	
	if direction == 0:
		state = State.IDLE
	
	if Input.is_action_just_pressed("attack1"):
		state = State.RUN_ATTACK
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		state = State.JUMP


func jump_state(direction):
	animation_player.play("jump")
	
	velocity.x = direction * SPEED
	
	if velocity.y > 0:
		state = State.FALL
	
	if Input.is_action_just_pressed("attack1"):
		state = State.JUMP_ATTACK


func fall_state(direction):
	animation_player.play("fall")
	
	velocity.x = direction * SPEED
	
	if is_on_floor():
		state = State.IDLE

func crouch_state(direction):
	velocity.x = direction * SPEED
	
	if not Input.is_action_pressed("ui_down"):
		crouch_pressed = false
		state = State.IDLE
		return
	
	if not crouch_pressed:
		crouch_pressed = true
		if animation_player.current_animation != "crouch":
			animation_player.play("crouch")  # loop uit
	
	
	if Input.is_action_just_pressed("attack1"):
		state = State.CROUCH_ATTACK


func attack_state():
	
	if animation_player.current_animation != "attack":
		animation_player.play("attack")
	

func run_attack_state(direction):
	
	if animation_player.current_animation != "run_attack":
		animation_player.play("run_attack")
	
	velocity.x = direction * SPEED

func jump_attack_state(direction):
	if animation_player.current_animation != "jump_attack":
		animation_player.play("jump_attack")
	
	velocity.x = direction * SPEED

func crouch_attack_state():
	velocity.x = 0
	
	if animation_player.current_animation != "crouch_attack":
		animation_player.play("crouch_attack")


func hurt_state():
	if animation_player.current_animation != "hurt":
		animation_player.play("hurt")

func death_state():
	velocity = Vector2.ZERO
	
	if animation_player.current_animation != "death":
		animation_player.play("death")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		state = State.IDLE
	
	if anim_name == "run_attack":
		state = State.RUN
	
	if anim_name == "jump_attack":
		state = State.FALL
	
	if anim_name == "crouch_attack":
		state = State.CROUCH
	
	if anim_name == "hurt":
		state = State.IDLE


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
	
	await get_tree().create_timer(1).timeout
	invulnerable = false
