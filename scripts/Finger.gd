extends Node2D

enum FingerState {
	None,
	ShowShadow,
	Pause,
	StrikeFinger,
	Stay,
	Disappear
}

const FingerStateTimers = {
	FingerState.None: 0.1,
	FingerState.ShowShadow: 0.3,
	FingerState.Pause: 0.7,
	FingerState.StrikeFinger: 1.0,
	FingerState.Stay: 0.3,
	FingerState.Disappear: 0.5,
}

const finger_to = 0
const figer_from = -720

var state = FingerState.None
var action_timer = 0.0
var action_time = 0.0

var finger_stroke_cb = null

func strike_at(point: Vector2, callback):
	finger_stroke_cb = callback
	position = point
	start_state(FingerState.ShowShadow)
	_update_shadow_weigth(0.0)
	_update_finger_weigth(0.0)
	$StaticBody2D/Collision.disabled = true

func start_state(new_state):
	state = new_state
	action_timer = 0.0
	action_time = FingerStateTimers[state]

	if new_state == FingerState.Stay:
		$StaticBody2D/Collision.disabled = false
	if new_state == FingerState.Disappear:
		$StaticBody2D/Collision.disabled = true

func _process(delta):
	action_timer += delta
	if state == FingerState.ShowShadow:
		var weigth = get_action_factor()
		_update_shadow_weigth(weigth)
		if action_is_completed():
			start_state(FingerState.Pause)
	elif state == FingerState.Pause:
		if action_is_completed():
			start_state(FingerState.StrikeFinger)
	elif state == FingerState.StrikeFinger:
		var weigth = ease(get_action_factor(), 4.8)
		_update_finger_weigth(weigth)
		if action_is_completed():
			if finger_stroke_cb:
				finger_stroke_cb.call_func(position)
				finger_stroke_cb = null
			start_state(FingerState.Stay)
	elif state == FingerState.Stay:
		if action_is_completed():
			start_state(FingerState.Disappear)
	elif state == FingerState.Disappear:
		var weigth = 1.0 - get_action_factor()
		_update_finger_weigth(weigth)
		_update_shadow_weigth(weigth)
		if action_is_completed():
			start_state(FingerState.None)
			queue_free()

func get_action_factor() -> float:
	return min(action_timer / action_time, 1.0)

func action_is_completed() -> bool:
	return action_timer > action_time

func _update_finger_weigth(weigth: float):
	$Finger.position.y = lerp(figer_from, finger_to, weigth)

func _update_shadow_weigth(weigth: float):
	$Shadow.set_weigth(weigth)
