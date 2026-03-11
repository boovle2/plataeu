class_name HitBox extends Area2D

#hitbox doet damage

@export var damage := 10

func get_damage() -> int:
	print("damage")
	return damage + 1
