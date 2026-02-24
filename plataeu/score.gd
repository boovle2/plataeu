extends Label


var current_score = 0

func _add_score(amount):
	current_score += amount
	text = "Score: " + str(current_score)
