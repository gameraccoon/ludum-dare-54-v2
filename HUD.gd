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


func _on_StartButton_pressed():
	$StartButton.hide()
	$Points.show()
	emit_signal("start_game")

func hide_message():
	$MessageLabel.hide()

func set_scores(scores):
	$Points.text = "Scores: " + str(int(scores))
