extends Label
var totalscore: int = 0
@onready var score: Label = %score

func _add_score(score1) -> void:
	totalscore += score1
	print(totalscore) 
	score.text = "Score: " + str(totalscore)
