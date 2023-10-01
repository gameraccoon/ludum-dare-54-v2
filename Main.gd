extends Node

var score

var pattern_time = 0.0

# debug_only
var debug_recorded_action_times = []
var debug_recorded_action_positions = []
var is_replay = false

const is_invinsible = false

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
			[5.0, null]
		]
	},
]

var first_pattern_idx = 0
var current_pattern_idx = -1

func _ready():
	randomize()


func game_over():
	if is_invinsible:
		return
	
	current_pattern_idx = -1
	$YSort/Player.hide() # Player disappears after being hit.
	$HUD.show_game_over()
	$Music.stop()
	$ColorRect.show()
	#$DeathSound.play()


func new_game():
	score = 0
	$YSort/Player.start_limit = $MovementLimits.get_begin()
	$YSort/Player.end_limit = $MovementLimits.get_end()
	$YSort/Player.start($StartPosition.position)
	$ColorRect.hide()
	$HUD.hide_message()
	pattern_time = 0.0
	current_pattern_idx = first_pattern_idx
	#$Music.play()
	
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
				if OS.is_debug_build() and current_pattern_idx < PATTERNS.size():
					print("Playing pattern: ", PATTERNS[current_pattern_idx]["name"])
				else:
					print("Finished playing predefined patterns")
		else:
			# game over?
			pass
	


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
			elif event.button_index == BUTTON_LEFT and event.pressed and not is_replay and !$ColorRect.is_visible_in_tree() and current_pattern_idx == -1:
				print("			[{0}, Vector2({1}, {2})],".format([pattern_time, event.position.x, event.position.y]))
				debug_recorded_action_times.append(pattern_time)
				debug_recorded_action_positions.append(event.position)
				$FingerSpawner.strike_finger_at(event.position)
				
