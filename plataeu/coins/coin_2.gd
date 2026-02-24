extends Area2D

@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound

signal coin_collected


func _on_body_entered(_body: Node2D) -> void:
	collected_sound.play()
	coin_collected.emit(1)
	queue_free()

func _on_collected_sound_finished() -> void:
	queue_free()
