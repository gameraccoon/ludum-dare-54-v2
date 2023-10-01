extends Node2D

enum FingerState {
	None, Show, Stay, Disappear
}

var state = FingerState.None

var action_timer = 0.0
const showing_time = 1.0
const staying_time = 0.3
const disappearing_time = 0.5

const finger_to = 0
const figer_from = -720

func strike_at(point: Vector2):
	position = point
	state = FingerState.Show
	$Shadow.show()
	action_timer = 0.0
	_set_params_by_weigth(0.0)


func _process(delta):
	if state == FingerState.Show:
		action_timer += delta
		var weigth = action_timer / showing_time
		weigth = ease(weigth, 4.8)
		if weigth < 1.0:
			_set_params_by_weigth(weigth)
		else:
			_set_params_by_weigth(1.0)
			action_timer = 0.0
			state = FingerState.Stay
	elif state == FingerState.Stay:
		action_timer += delta
		if action_timer >= staying_time:
			action_timer = 0.0
			state = FingerState.Disappear
	elif state == FingerState.Disappear:
		action_timer += delta
		var weigth = action_timer / disappearing_time
		if weigth < 1.0:
			_set_params_by_weigth(1.0 - weigth)
		else:
			_set_params_by_weigth(0.0)
			action_timer = 0.0
			state = FingerState.None
			queue_free()


func _set_params_by_weigth(weigth):
	$Finger.position.y = lerp(figer_from, finger_to, weigth)
	$Shadow.set_weigth(weigth)
