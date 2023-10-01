extends CanvasLayer

signal start_game

func _ready():
	$Points.hide()

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()


func show_game_over():
	if Globals.game_is_completed:
		show_message("Game Completed")
		$MessageLabel.text = "Thank you for playing"
	else:
		show_message("Game Over")
		$MessageLabel.text = "Meow?"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$Sound.show()


func _on_StartButton_pressed():
	$StartButton.hide()
	$Sound.hide()
	$Points.show()
	emit_signal("start_game")

func hide_message():
	$MessageLabel.hide()
	$PointsWhite.hide()

func set_scores(scores):
	$Points.text = "Score: " + str(int(scores))
	$PointsWhite.text = "Score: " + str(int(scores))

func white_scores():
	$Points.hide()
	$PointsWhite.show()

func black_scores():
	$Points.show()
	$PointsWhite.hide()

func _on_Sound_pressed():
	var master_sound = AudioServer.get_bus_index("Master")
	if not AudioServer.is_bus_mute(master_sound):
		$Sound.text = "ROUSE SOUND"
		AudioServer.set_bus_mute(master_sound, true)
	else:
		$Sound.text = "QUELL SOUND"
		AudioServer.set_bus_mute(master_sound, false)
