extends Area2D



func _on_Spike_body_entered(body):
	if body.has_method("getHit"):
		body.getHit(Cfg.spike_damage, 0)
