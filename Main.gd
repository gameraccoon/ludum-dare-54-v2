extends Node

var score = 0

var pattern_time = 0.0

# debug_only
var debug_recorded_action_times = []
var debug_recorded_action_positions = []
var is_replay = false

const is_invinsible = false

var click_sound = preload("res://sounds/space_press.mp3")

const PATTERNS = [
	{
		"name": "left to right (easy)",
		"actions": [
			[2.563636, Vector2(290, 510-50)],
			[3.109091, Vector2(430, 510-50)],
			[3.751515, Vector2(582, 510-50)],
			[4.4330303, Vector2(731, 510-50)],
			[5.036553, Vector2(841, 510-50)],
			[7.0, null]
		]
	},
	{
		"name": "right to left (easy)",
		"actions": [
			[1.133333, Vector2(970, 510-50)],
			[1.842424, Vector2(879, 510-50)],
			[2.460212, Vector2(792, 510-50)],
			[3.054151, Vector2(666, 510-50)],
			[3.611727, Vector2(542, 510-50)],
			[4.187485, Vector2(423, 510-50)],
			[5.5, null]
		]
	},
	{
		"name": "inside (easy)",
		"actions": [
			[0.575758, Vector2(290, 510-50)],
			[0.575758, Vector2(970, 510-50)],
			[1.145042, Vector2(436, 510-50)],
			[1.145042, Vector2(785, 510-50)],
			[2.0, null]
		]
	},
	{
		"name": "outside (easy)",
		"actions": [
			[0.980682, Vector2(551, 510-50)],
			[0.990682, Vector2(688, 510-50)],
			[2.206731, Vector2(390, 510-50)],
			[2.206731, Vector2(810, 510-50)],
			[3.0, null]
		]
	},
	{
		"name": "left to right fast (medium)",
		"actions": [
			[1.5, Vector2(290, 510-50)],
			[1.75, Vector2(430, 510-50)],
			[2.0, Vector2(582, 510-50)],
			[2.25, Vector2(761, 510-50)],
			[2.5, Vector2(841, 510-50)],
			[4.0, null]
		]
	},
	{
		"name": "trick one (medium)",
		"actions": [
			[0.791263, Vector2(970, 510-50)],
			[1.203886, Vector2(585, 510-50)],
			[1.658386, Vector2(290, 510-50)],
			[2.006766, Vector2(440, 510-50)],
			[2.324906, Vector2(770, 510-50)],
			[4.0, null]
		]
	},
	{
		"name": "trick two (hard)",
		"actions": [
			[1.630303, Vector2(822, 510-50)],
			[2.375758, Vector2(627, 510-50)],
			[2.709091, Vector2(456, 510-50)],
			[3.012121, Vector2(309, 510-50)],
			[4.0, null]
		]
	},
	{
		"name": "verticality demonstration (easy)",
		"actions": [
			[1.545455, Vector2(890, 450-50)],
			[2.387879, Vector2(678, 590-50)],
			[3.447899, Vector2(476, 450-50)],
			[4.278202, Vector2(290, 590-50)],
			[5.0, null]
		]
	},
	{
		"name": "all top right to left and all bottom right to left (medium)",
		"actions": [
			[1.812121, Vector2(1032, 450-50)],
			[2.206061, Vector2(874, 450-50)],
			[2.739394, Vector2(709, 450-50)],
			[3.157576, Vector2(574, 450-50)],
			[3.569697, Vector2(423, 450-50)],
			[4.059155, Vector2(272, 450-50)],

			[3.812121, Vector2(1032, 560-50)],
			[4.206061, Vector2(874, 560-50)],
			[4.739394, Vector2(709, 560-50)],
			[5.157576, Vector2(574, 560-50)],
			[5.569697, Vector2(423, 560-50)],
			[6.059155, Vector2(272, 560-50)],

			[8.0, null]
		]
	},
	{
		"name": "only one place to escape (hard)",
		"actions": [
			[0.25, Vector2(250, 510-50)],
			[0.5, Vector2(350, 510-50)],
			[0.75, Vector2(450, 510-50)],
			[1, Vector2(600, 450-50)],
			[1.25, Vector2(750, 510-50)],
			[1.50, Vector2(850, 510-50)],
			[1.75, Vector2(950, 510-50)],
			[2.2, null]
		]
	},
	{
		"name": "wave preview (easy)",
		"actions": [
			[1, Vector2(221, 379)],
			[1.5, Vector2(335, 455)],
			[2, Vector2(471, 522)],
			[2.5, Vector2(634, 455)],
			[3, Vector2(748, 379)],
			[3.5, Vector2(871, 444)],
			[4, Vector2(1016, 522)],

			[4, Vector2(221, 522)],
			[4.5, Vector2(335, 455)],
			[5, Vector2(471, 379)],
			[5.5, Vector2(634, 455)],
			[6, Vector2(748, 522)],
			[6.5, Vector2(871, 444)],
			[7, Vector2(1016, 379)],
			[9, null]
		]
	},
	{
		"name": "wave (medium)",
		"actions": [
			[1, Vector2(221, 379)],
			[1, Vector2(335, 455)],
			[1, Vector2(471, 522)],
			[1, Vector2(634, 455)],
			[1, Vector2(748, 379)],
			[1, Vector2(871, 444)],
			[1, Vector2(1016, 522)],

			[2.5, Vector2(221, 522)],
			[2.5, Vector2(335, 455)],
			[2.5, Vector2(471, 379)],
			[2.5, Vector2(634, 455)],
			[2.5, Vector2(748, 522)],
			[2.5, Vector2(871, 444)],
			[2.5, Vector2(1016, 379)],
			[3.0, null]
		]
	},
	{
		"name": "wave 2 (hard)",
		"actions": [
			[1, Vector2(221, 379)],
			[1, Vector2(335, 455)],
			[1, Vector2(471, 522)],
			[1, Vector2(634, 455)],
			[1, Vector2(748, 379)],
			[1, Vector2(871, 444)],
			[1, Vector2(1016, 522)],

			[1.8, Vector2(221, 522)],
			[1.8, Vector2(335, 455)],
			[1.8, Vector2(471, 379)],
			[1.8, Vector2(634, 455)],
			[1.8, Vector2(748, 522)],
			[1.8, Vector2(871, 444)],
			[1.8, Vector2(1016, 379)],
			[4.0, null]
		]
	},
]

var first_pattern_idx = 0
var current_pattern_idx = -1
var is_game_over = false

func _ready():
	# defauld sound is too loud, make it quiter
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -20.0)
	$MusicMainMenu.play()
	$HUD.set_scores(0)
	randomize()


func game_over():
	if is_invinsible:
		return
	
	is_game_over = true
	current_pattern_idx = -1
	$YSort/Player.is_dead = true
	$Music.stop()
	$MusicMainMenu.play()
	$DeathSound.play()
	$RandomFingerTimer.stop()
	$DelayTimer.start()


func new_game():
	score = 0
	is_game_over = false
	$YSort/Player.start_limit = $MovementLimits.get_begin()
	$YSort/Player.end_limit = $MovementLimits.get_end()
	$YSort/Player.start($StartPosition.position)
	$HUD/ColorRect.hide()
	$HUD.hide_message()
	pattern_time = 0.0
	current_pattern_idx = first_pattern_idx
	$YSort/Player.is_dead = false
	$Music.play()
	$MusicMainMenu.stop()
	
	if OS.is_debug_build() and current_pattern_idx > -1 and current_pattern_idx < PATTERNS.size():
		print("Playing pattern: ", PATTERNS[current_pattern_idx]["name"])


func _process(delta):
	if OS.is_debug_build():
		if is_replay:
			for i in range(0, len(debug_recorded_action_times)):
				var i_time = debug_recorded_action_times[i]
				if pattern_time < i_time and pattern_time + delta >= i_time:
					var pos = debug_recorded_action_positions[i]
					print("Replaying pos {0}, {1}".format([pos.x, pos.y]))
					$FingerSpawner.strike_finger_at(pos)
				if pattern_time + delta < i_time:
					break
	
	pattern_time += delta
	if not is_game_over:
		score += delta
		$HUD.set_scores(score)


	if current_pattern_idx > -1:
		if current_pattern_idx < PATTERNS.size():
			var current_pattern = PATTERNS[current_pattern_idx]
			var is_out_of_actions = true
			var pattern_actions = current_pattern["actions"]
			for i in range(0, len(pattern_actions)):
				var i_time = pattern_actions[i][0]
				if pattern_time < i_time and pattern_time + delta >= i_time:
					var pos = pattern_actions[i][1]
					if pos != null:
						$FingerSpawner.strike_finger_at(pos)
				if pattern_time + delta < i_time:
					is_out_of_actions = false

			if is_out_of_actions:
				current_pattern_idx += 1
				pattern_time = 0
				
				if current_pattern_idx >= PATTERNS.size():
					Globals.game_is_completed = true
					$RandomFingerTimer.start()

				if OS.is_debug_build() and current_pattern_idx < PATTERNS.size():
					print("Playing pattern: ", PATTERNS[current_pattern_idx]["name"])
				else:
					print("Finished playing predefined patterns")

	var is_pressed = is_space_pressed()
	var was_pressed = Globals.is_space_pressed
	if is_pressed and !was_pressed:
		$SpaceClick.play(0.1)
		$Background/Node2D/SpacePressed.visible = true
		$Background/Node2D/SpaceReleased.visible = false
	elif !is_pressed and was_pressed:
		$Background/Node2D/SpacePressed.visible = false
		$Background/Node2D/SpaceReleased.visible = true
	Globals.is_space_pressed = is_pressed


func _input(event):
	if OS.is_debug_build():
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_RIGHT and event.pressed:
				print("Start recording")
				pattern_time = 0.0
				debug_recorded_action_times = []
				debug_recorded_action_positions = []
				current_pattern_idx = -1
				is_replay = false
			if event.button_index == BUTTON_MIDDLE and event.pressed:
				print("Replaying")
				pattern_time = 0.0
				is_replay = true
				current_pattern_idx = -1
			elif event.button_index == BUTTON_LEFT and event.pressed and not is_replay and !$HUD/ColorRect.is_visible_in_tree() and current_pattern_idx == -1:
				print("			[{0}, Vector2({1}, {2})],".format([pattern_time, event.position.x, event.position.y]))
				debug_recorded_action_times.append(pattern_time)
				debug_recorded_action_positions.append(event.position)
				$FingerSpawner.strike_finger_at(event.position)
				

func is_space_pressed():
	if Input.is_action_pressed("space"):
		return true
	
	for i in range(0, $YSort.get_child_count()):
		var child = $YSort.get_child(i)
		if child is Finger:
			if child.state == Finger.FingerState.Stay:
				return true
	return false

func get_random_position_for_finger():
	return Vector2(rand_range($MovementLimits.get_begin().x, $MovementLimits.get_end().x), rand_range($MovementLimits.get_begin().y, $MovementLimits.get_end().y))

func get_unoccupied_by_fingers_random_position():
	var finger_position
	for j in range(0, 30):
		finger_position = get_random_position_for_finger()
		var occupied = false
		for i in range(0, $YSort.get_child_count()):
			var child = $YSort.get_child(i)
			if child is Finger:
				if finger_position.distance_squared_to(child.position) < 100*100:
					occupied = true
					break
		
		if !occupied:
			return finger_position
	
	return finger_position

func _on_RandomFingerTimer_timeout():
	$FingerSpawner.strike_finger_at(get_unoccupied_by_fingers_random_position())
	$RandomFingerTimer.start(rand_range(0.2, 0.9))

func _on_DelayTimer_timeout():
	$HUD/ColorRect.show()
	$HUD.white_scores()
	$HUD.show_game_over()
