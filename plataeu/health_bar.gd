extends TextureProgressBar

@export var player : Player

func _ready() -> void:
	player.healthChanged.connect(update)
	update()

func update():
	value = player.currenHealth * 100 / player.maxHealth
