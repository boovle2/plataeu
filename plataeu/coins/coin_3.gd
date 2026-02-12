extends Area2D

@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound

var score: int = 0

func _on_body_entered(_body: Node2D) -> void:
	collected_sound.play()
	score += 3
	print(score)

func _on_collected_sound_finished() -> void:
	queue_free()
