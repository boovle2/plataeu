extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for coin in $coins.get_children():
		coin.coin_collected.connect(_on_coin_collected)

func _on_coin_collected(amount):
	$Player/Camera2D/score._add_score(amount)
