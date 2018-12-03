extends Particles2D

var started = false

func _ready():
	add_to_group("removables")
	emitting = true

func _physics_process(delta):
	if emitting and not started:
		started = true
		yield(get_tree().create_timer(lifetime), "timeout")
		queue_free()
		