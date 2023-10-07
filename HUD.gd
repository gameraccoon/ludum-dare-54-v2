extends CanvasLayer

signal start_game

func _ready():
	$ColorRect/Animation.visible = false
	$ColorRect/Base.visible = true
	$Paused.visible = false

func show_message(text):
	$ColorRect/Base/MessageLabel.text = text
	$ColorRect/Base/MessageLabel.show()


func show_game_over():
	$ColorRect/Animation.visible = Globals.game_is_completed
	$ColorRect/Base.visible = !Globals.game_is_completed
	
	if Globals.game_is_completed:
		show_message("Game Completed")
		$ColorRect/Base/MessageLabel.text = "Thank you for playing"
	else:
		show_message("Game Over")
		$ColorRect/Base/MessageLabel.text = "Meow?"
	$ColorRect/Base/MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$ColorRect/Base/StartButton.show()
	$Sound.show()


func _on_StartButton_pressed():
	$ColorRect/Base/StartButton.hide()
	$Sound.hide()
	emit_signal("start_game")

func hide_message():
	$ColorRect/Base/MessageLabel.hide()
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
		#$Sound.text = "SOUND: OFF"
		$Sound/SoundOff.visible = false
		$Sound/SoundOn.visible = true
		AudioServer.set_bus_mute(master_sound, true)
	else:
		#$Sound.text = "SOUND: ON"
		$Sound/SoundOff.visible = true
		$Sound/SoundOn.visible = false
		AudioServer.set_bus_mute(master_sound, false)

func _input(event):
	if event.is_action_released("pause"):
		if Globals.game_is_started:
			get_tree().paused = !get_tree().paused
			$Paused.visible = get_tree().paused
			$Sound.visible = get_tree().paused
	if event.is_action_released("start_game") and !Globals.game_is_started:
		_on_StartButton_pressed()


func _on_PlayAgain_pressed():
	$ColorRect/Base/StartButton.hide()
	$Sound.hide()
	emit_signal("start_game")
