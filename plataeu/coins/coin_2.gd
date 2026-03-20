extends Area2D

@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound

signal coin_collected(amount)

func _ready():
	global.register_coin(self)

func _on_body_entered(_body: Node2D) -> void:
	collected_sound.play()
	coin_collected.emit(1)

func _on_collected_sound_finished() -> void:
	queue_free()
