extends Label

# Houdt de verstreken tijd bij in seconden
var elapsed_time : float = 0.0
var timer_running : bool = true

func _process(delta):
	if timer_running:
		# Voeg de verstreken tijd sinds het vorige frame toe
		elapsed_time += delta
		# Update de tekst van de Label
		text = get_time_text()

# Functie om de tijd als mm:ss te geven
func get_time_text() -> String:
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time) % 60
	# Gebruik pad_zeros() op het getal, niet op een string
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

# Optioneel: functies om te pauzeren of hervatten
func pause_timer():
	timer_running = false

func resume_timer():
	timer_running = true

# Optioneel: reset timer
func reset_timer():
	elapsed_time = 0
	timer_running = true
