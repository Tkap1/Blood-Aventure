extends StaticBody2D

var shootAngle = Vector2(0,-1)

export (float) var damageMultiplier = 1.0
export (float) var shootSpeedMultiplier = 1.0
export (float) var bulletSizeMultiplier = 1.0
export (float) var startDelay = 0.0

onready var shootTimer = $Timer
onready var spr = $Sprite


func _ready():
	z_index = Cfg.turret_z
	shootTimer.wait_time = Cfg.turret_shoot_delay / shootSpeedMultiplier
	
	yield(get_tree().create_timer(startDelay),"timeout")
	shootTimer.start()
	

func shoot():
	var bullet = Refs.bulletSc.instance()
	Refs.main.add_child(bullet)
	bullet.init(self, Cfg.turret_bullet_size * bulletSizeMultiplier, Cfg.turret_bullet_speed, shootAngle.rotated(rotation).angle(), Cfg.turret_bullet_damage * damageMultiplier, Cfg.turret_shoot_attack_invuln)
	bullet.position = $Position2D.global_position
	bullet.set_collision_mask_bit(Refs.mask_enemy,false)

func _on_Timer_timeout():
	shoot()
