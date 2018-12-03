extends "res://Scripts/Pickup.gd"

func applyEffect(body):
	if body.has_method("heal"):
		body.heal(Cfg.pickup_blood_heal)
		queue_free()
	