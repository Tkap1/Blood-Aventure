extends KinematicBody2D

enum MOVE_STATE {CHASE,PATROL,IDLE,STATIC,JUMP}
export (MOVE_STATE) var moveState = null

enum ATTACK_STATE {MELEE,SHOOT}
export (ATTACK_STATE) var attackState = null

export (float) var sprRotation = 0.0


var sees_player = false
var sleeping = true
var vel = Vector2()
var acc = Vector2()
var shootTimer

var currHP

# Reaction stuff
var yielding = false
var canReact = false

onready var ray = $RayCast2D
onready var spr = $AnimatedSprite

func _ready():
	ray.add_exception(Refs.player)
	shootTimer = Timer.new()
	shootTimer.wait_time = Cfg.e_shoot_delay
	shootTimer.one_shot = true
	add_child(shootTimer)
	
	spr.rotation_degrees = sprRotation
	
	match(attackState):
		MELEE:
			spr.animation = "melee"
			currHP = Cfg.e_melee_hp
		SHOOT:
			spr.animation = "ranged"
			currHP = Cfg.e_ranged_hp
			
	
	

func _physics_process(delta):
	sleeping = Cfg.e_sleep_dist <= (position - Refs.player.position).length()
	if not sleeping:
		ray.cast_to = Refs.player.position - position
		sees_player = !ray.is_colliding()
		setReaction()
		match(moveState):
			CHASE:
				acc.y += Cfg.gravity
				if canReact:
					acc.x = -1 * Cfg.e_speed if position > Refs.player.position else 1 * Cfg.e_speed
			IDLE:
				acc.y += Cfg.gravity
			STATIC:
				pass
				
		# Movement
		vel += acc
		vel = move_and_slide(vel, Vector2(0,-1))
		vel *= Cfg.e_vel_decay
		acc *= 0
		
		match(attackState):
				MELEE:
					for i in get_slide_count():
						var collider = get_slide_collision(i).collider
						if collider == Refs.player:
							collisionResponse(Refs.player)
				SHOOT:
					if canReact:
						if shootTimer.is_stopped():
							shoot()
							$Shoot.play()
							shootTimer.start()
						
						
func setReaction():
	if not canReact and not yielding and sees_player:
		yielding = true
		yield(get_tree().create_timer(Cfg.e_reaction_time), "timeout")
		yielding = false
		if sees_player:
			canReact = true
	elif canReact and not sees_player:
		canReact = false
						
func shoot():
	var angle = Refs.player.position.angle_to_point(position)
	var bullet = Refs.bulletSc.instance()
	Refs.main.add_child(bullet)
	bullet.init(self, Cfg.e_bullet_size, Cfg.e_bullet_speed, angle, Cfg.e_bullet_damage, Cfg.e_shoot_attack_invuln)
	bullet.set_collision_mask_bit(Refs.mask_enemy,false)
	
	
	
func collisionResponse(body):
	if body.has_method("getHit"):
		body.getHit(Cfg.e_melee_damage, Cfg.e_hit_invul_duration)
	
func die():
	var bloodPickup = Refs.bloodPickupSc.instance()
	Refs.main.add_child(bloodPickup)
	bloodPickup.position = position
	queue_free()
	
func getHit(damage, invulnTime):
	currHP -= damage
	if currHP <= 0:
		die()
	