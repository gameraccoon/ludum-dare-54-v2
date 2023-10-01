extends Camera2D

var shake_intensity: float = 0
var shake_duration: float = 0
var time_passed: float = 0

func _ready():
	make_current()

func shake_camera(intensity: float, duration: float):
	shake_intensity = intensity
	shake_duration = duration
	time_passed = 0

func _process(delta: float):
	if time_passed < shake_duration:
		time_passed += delta
		offset = Vector2(
			randf() * shake_intensity, 
			randf() * shake_intensity
		)
	else:
		offset = Vector2.ZERO  # Reset the offset to stop the shake

	# Decreasing the shake intensity over time
	shake_intensity = lerp(shake_intensity, 0, delta)


func _on_FingerSpawner_finger_stroke():
	shake_camera(3.0, 0.25)
