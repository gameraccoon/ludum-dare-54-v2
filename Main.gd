extends Node

var score

var time = 0.0

# debug_only
var debug_recorded_action_times = []
var debug_recorded_action_positions = []
var is_replay = false

const is_invinsible = false

func _ready():
	randomize()


func game_over():
	if is_invinsible:
		return
		
	$Player.hide() # Player disappears after being hit.
	$HUD.show_game_over()
	$Music.stop()
	$ColorRect.show()
	#$DeathSound.play()


func new_game():
	score = 0
	$Player.start_limit = $MovementLimits.get_begin()
	$Player.end_limit = $MovementLimits.get_end()
	$Player.start($StartPosition.position)
	$HUD.show_message("Get Ready")
	$ColorRect.hide()
	time = 0.0
	#$Music.play()


func _process(delta):
	if OS.is_debug_build():
		if is_replay:
			for i in range(0, len(debug_recorded_action_times)):
				var i_time = debug_recorded_action_times[i]
				if time < i_time and time + delta >= i_time:
					var pos = debug_recorded_action_positions[i]
					print("Replaying pos {0}, {1}".format([pos.x, pos.y]))
					$FingerSpawner.strike_finger_at(pos)
					break
	
	time += delta
	


func _input(event):
	if OS.is_debug_build():
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_RIGHT and event.pressed:
				print("Reset recording")
				time = 0.0
				debug_recorded_action_times = []
				debug_recorded_action_positions = []
				is_replay = false
			if event.button_index == BUTTON_MIDDLE and event.pressed:
				print("Replaying")
				time = 0.0
				is_replay = true
			elif event.button_index == BUTTON_LEFT and event.pressed and not is_replay:
				print("Record click: [{0}, Vector2({1}, {2})]".format([time, event.position.x, event.position.y]))
				debug_recorded_action_times.append(time)
				debug_recorded_action_positions.append(event.position)
				$FingerSpawner.strike_finger_at(event.position)
				
