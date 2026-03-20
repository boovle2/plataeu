extends Node

var levels = []
var unlockedlevels = 1

func register_coin(coin):
	if not coin.coin_collected.is_connected(_on_coin_collected):
		coin.coin_collected.connect(_on_coin_collected)

var score_node
func register_score(node):
	score_node = node

func _on_coin_collected(amount):
	if score_node:
		score_node._add_score(amount)
