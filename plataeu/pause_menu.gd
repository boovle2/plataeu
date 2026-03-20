extends Control
@onready var pause_menu: Control = $"."

func resume(): 
	get_tree().paused = false
	pause_menu.hide()
	

func pause():
	get_tree().paused = true
	pause_menu.show()

func Esc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()

func _process(_delta):
	Esc()


func _on_button_pressed() -> void:
	resume()


func _on_button_2_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_button_3_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://home_screen.tscn")
