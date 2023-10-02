extends CanvasLayer

signal start_game

func _ready():
	pass

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
	emit_signal("start_game")

func hide_message():
	$MessageLabel.hide()
	$PointsWhite.hide()

func set_scores(scores):
	get_parent().find_node("Points").text = "Score: " + str(int(scores))
	$PointsWhite.text = "Score: " + str(int(scores))

func white_scores():
	$PointsWhite.show()

func black_scores():
	$PointsWhite.hide()

func _on_Sound_pressed():
	var master_sound = AudioServer.get_bus_index("Master")
	if not AudioServer.is_bus_mute(master_sound):
		$Sound.text = "SOUND: OFF"
		AudioServer.set_bus_mute(master_sound, true)
	else:
		$Sound.text = "SOUND: ON"
		AudioServer.set_bus_mute(master_sound, false)
#
#func _input(event):
#	if event.is_action_released("pause"):
#		if not get_node(GlobalVar.pathToGameOver).visible:
#			get_tree().paused = !get_tree().paused
#			visible = get_tree().paused
