extends Node2D

signal hit

export var base_speed = 200 # How fast the player will move (pixels/sec).
export var dash_speed = 2000
var screen_size # Size of the game window.

var start_limit = Vector2(0, 0)
var end_limit = Vector2(100, 100)

var dash_cooldown_time = 1.0
var dash_cooldown_left = 0.0
var dash_length = 0.1
var dash_time_left = 0.0
var dash_start_velocity_vector = Vector2(0.0, 0.0)

var touch_movement_pos = Vector2(0.0, 0.0)
var touch_movement_active = false
const DOUBLE_TAP_WINDOW = 0.2
const DOUBLE_TAP_RESET_DISTANCE = 50.0
var double_tap_window_cooldown = 0.0
var double_tap_activated = false
var movement_treshold = 10.0

# use first frame to precache things
var first_frames_count = 0
var frames_to_precache_particles = 5

var is_dead = false

func _ready():
	hide()
	# we need to start with emitting the particle, to avoid lag on first dash
	$Visuals/DashTrail.emitting = true
	dash_cooldown_left = 0.0
	dash_time_left = 0.0


func _process(delta):
	if first_frames_count < frames_to_precache_particles and is_visible_in_tree():
		first_frames_count += 1
		if first_frames_count == frames_to_precache_particles:
			# we're done with precaching, stop the particles
			$Visuals/DashTrail.emitting = false

	$Visuals.position.y = Globals.space_offset if Globals.is_space_pressed else 0
	
	double_tap_window_cooldown -= delta
	if double_tap_window_cooldown < 0.0:
		double_tap_window_cooldown = 0.0
	
	var velocity = Vector2.ZERO # The player's movement vector.

	if !is_dead:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
			touch_movement_active = false
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
			touch_movement_active = false
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
			touch_movement_active = false
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
			touch_movement_active = false

		if touch_movement_active:
			var diff = touch_movement_pos - position
			var diff_length = diff.length()
			if diff_length > movement_treshold:
				velocity = diff / diff_length

	dash_cooldown_left -= delta
	if dash_cooldown_left < 0.0:
		dash_cooldown_left = 0.0
	
	# are we stopping dash this frame
	if dash_time_left > 0.0 and dash_time_left - delta <= 0.0:
		$Visuals/DashTrail.emitting = false

	var speed = base_speed

	dash_time_left -= delta
	if dash_time_left > 0.0:
		speed = dash_speed
		velocity = dash_start_velocity_vector
	else:
		dash_time_left = 0.0

	var dash_requested = Input.is_action_pressed("Dash") or double_tap_activated
	double_tap_activated = false

	if (dash_requested and dash_cooldown_left == 0.0) and velocity != Vector2(0.0, 0.0) and Globals.game_is_started:
		# start dash
		$Visuals/DashTrail.emitting = true
		dash_cooldown_left = dash_cooldown_time
		dash_time_left = dash_length
		dash_start_velocity_vector = velocity
		$SoundDash.play(0.25)

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	if is_dead:
		velocity = Vector2(0.0, 0.0)

	position += velocity * delta
	position.x = clamp(position.x, start_limit.x, end_limit.x)
	position.y = clamp(position.y, start_limit.y, end_limit.y)

	if velocity.x != 0:
		$Visuals/Sprite.flip_h = velocity.x > 0
		$Visuals/Sprite.position.x = 26 if velocity.x <= 0 else -20
		if dash_time_left > 0.0:
			$Visuals/Sprite.animation = "dash"
		else:
			$Visuals/Sprite.animation = "go"
	else:
		if is_dead:
			$Visuals/Sprite.animation = "die"
		else:
			$Visuals/Sprite.animation = "stand"

func start(pos):
	position = pos
	show()
	$Area2D/Collison.disabled = false


func _on_Area2D_body_entered(_body):
	# Must be deferred as we can't change physics properties on a physics callback.
	$Area2D/Collison.set_deferred("disabled", true)
	emit_signal("hit")


func _input(event):
	if event is InputEventMouseMotion:
		if (touch_movement_pos - event.position).length() > DOUBLE_TAP_RESET_DISTANCE:
			double_tap_window_cooldown = 0.0
		touch_movement_pos = event.position
	if event is InputEventScreenTouch:
		if Globals.game_is_started:
			if event.is_pressed():
				if double_tap_window_cooldown > 0.0:
					double_tap_activated = true
					double_tap_window_cooldown = 0.0
				else:
					double_tap_window_cooldown = DOUBLE_TAP_WINDOW
				touch_movement_active = true
				touch_movement_pos = event.position
			if !event.is_pressed():
				touch_movement_active = false
		else:
			touch_movement_active = false
