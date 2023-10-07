extends CanvasLayer

signal start_game

var is_menu_interactible = true
var show_touch_ui = false

func _ready():
	$ColorRect/Animation.visible = false
	$ColorRect/Base.visible = true
	$Paused.visible = false
	update_touch_ui()

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
	update_touch_ui()
	yield(get_tree().create_timer(1), "timeout")
	$ColorRect/Base/StartButton.show()
	update_sound_icon()
	$Sound.show()
	is_menu_interactible = true


func _on_StartButton_pressed():
	if $Sound.visible:
		$ColorRect/Base/StartButton.hide()
		$Sound.hide()
		is_menu_interactible = false
		update_touch_ui()
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
	toggle_sound()

func is_muted():
	var master_sound = AudioServer.get_bus_index("Master")
	return AudioServer.is_bus_mute(master_sound)


func toggle_sound():
	var master_sound = AudioServer.get_bus_index("Master")
	var was_muted = AudioServer.is_bus_mute(master_sound)
	AudioServer.set_bus_mute(master_sound, !was_muted)
	
	if !Globals.game_is_started or get_tree().paused:
		update_sound_icon()
	else:
		$Sound.show()
		var is_muted = is_muted()
		$Sound/SoundOff.visible = is_muted
		$Sound/SoundOn.visible = !is_muted
		$SoundBlinkTimer.start()


func toggle_pause():
	if Globals.game_is_started:
		get_tree().paused = !is_paused()
		var is_paused = is_paused()
		$Paused.visible = is_paused
		$Sound.visible = is_paused
		if is_paused:
			update_sound_icon()

func is_paused():
	return get_tree().paused


func _input(event):
	if event.is_action_released("pause"):
		toggle_pause()
	if event.is_action_released("start_game") and is_menu_interactible:
		_on_StartButton_pressed()
	if event.is_action_released("toggle_sound"):
		toggle_sound()
	
	if event is InputEventJoypadButton:
		update_touch_ui_from_controls(false)
	if event is InputEventJoypadMotion:
		update_touch_ui_from_controls(false)
	if event is InputEventKey:
		update_touch_ui_from_controls(false)
	if event is InputEventScreenTouch:
		update_touch_ui_from_controls(true)


func _on_PlayAgain_pressed():
	if is_menu_interactible:
		$ColorRect/Base/StartButton.hide()
		$Sound.hide()
		is_menu_interactible = false
		emit_signal("start_game")


func _on_SoundBlinkTimer_timeout():
	if Globals.game_is_started and !is_paused():
		$Sound.hide()


func update_sound_icon():
	var is_muted = is_muted()
	$Sound/SoundOff.visible = !is_muted
	$Sound/SoundOn.visible = is_muted


func update_touch_ui_from_controls(is_touch_event):
	show_touch_ui = is_touch_event
	update_touch_ui()

func update_touch_ui():
	$Touch.visible = Globals.game_is_started and show_touch_ui
	var is_paused = is_paused()
	$Touch/TouchPauseButton.visible = !is_paused
	$Touch/TouchUnpauseButton.visible = is_paused

func _on_TouchPauseButton_pressed():
	toggle_pause()
	Globals.touch_movement_active = false
