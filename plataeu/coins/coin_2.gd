extends Area2D

@onready var collected_sound: AudioStreamPlayer2D = $CollectedSound
@onready var score: Label = %score

func _on_body_entered(_body: Node2D) -> void:
	collected_sound.play()
	score._add_score(1)

func _on_collected_sound_finished() -> void:
	queue_free()
