extends Area2D
@onready var player: CharacterBody2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(body: Node2D) -> void:
	player.animated_sprite_2d.play("hurt")
