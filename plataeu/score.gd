extends Label


var current_score = 0

func _ready():
	global.register_score(self)

func _add_score(amount):
	current_score += amount
	text = "Score: " + str(current_score)
