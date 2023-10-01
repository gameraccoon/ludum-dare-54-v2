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
		"name": "left to right",
		"actions": [
			[2.563636, Vector2(290, 500)],
			[3.109091, Vector2(430, 500)],
			[3.751515, Vector2(582, 502)],
			[4.430303, Vector2(761, 507)],
			[5.036553, Vector2(841, 504)],
			[7.0, null]
		]
	},
	{
		"name": "right to left",
		"actions": [
			[1.133333, Vector2(1007, 499)],
			[1.842424, Vector2(879, 500)],
			[2.460212, Vector2(792, 498)],
			[3.054151, Vector2(666, 492)],
			[3.611727, Vector2(542, 497)],
			[4.187485, Vector2(423, 494)],
			[4.751121, Vector2(341, 494)],
			[5.5, null]
		]
	},
]

var first_pattern_idx = 0
var current_pattern_idx = first_pattern_idx

func _ready():
	randomize()


func game_over():
	if is_invinsible:
		return
	
	current_pattern_idx = -1
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
					break

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
				print("Reset recording")
				pattern_time = 0.0
				debug_recorded_action_times = []
				debug_recorded_action_positions = []
				is_replay = false
			if event.button_index == BUTTON_MIDDLE and event.pressed:
				print("Replaying")
				pattern_time = 0.0
				is_replay = true
			elif event.button_index == BUTTON_LEFT and event.pressed and not is_replay and !$ColorRect.is_visible_in_tree():
				print("			[{0}, Vector2({1}, {2})],".format([pattern_time, event.position.x, event.position.y]))
				debug_recorded_action_times.append(pattern_time)
				debug_recorded_action_positions.append(event.position)
				$FingerSpawner.strike_finger_at(event.position)
				
