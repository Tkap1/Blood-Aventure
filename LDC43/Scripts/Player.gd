extends KinematicBody2D

signal bloodChanged(player)
signal playerDead(player)
signal levelBeat

var blood setget setBlood
var invulnerable = false

var ignore_input = false

var vel = Vector2()
var acc = Vector2()

var dashing = false
var dashDirection = Vector2()

var shootTimer
var dashTimer

var jumps = []


onready var spr = $Sprite

func _ready():
	self.blood = Cfg.p_max_blood
	jumps.append({"jumping":false,"canJump":false,"currFrames":0, "jumpForce": Cfg.p_jump_height*1.2, "bloodCost": 0.0})
	jumps.append({"jumping":false,"canJump":false,"currFrames":0, "jumpForce": Cfg.p_jump_height, "bloodCost": 50.0})
	jumps.append({"jumping":false,"canJump":false,"currFrames":0, "jumpForce": Cfg.p_jump_height, "bloodCost": 100.0})
	shootTimer = Timer.new()
	shootTimer.wait_time = Cfg.p_shoot_delay
	shootTimer.one_shot = true
	add_child(shootTimer)
	
	# Dash timer
	dashTimer = Timer.new()
	dashTimer.wait_time = Cfg.p_dash_cd
	dashTimer.one_shot = true
	add_child(dashTimer)

func _unhandled_input(event):
	if not ignore_input:
		if event.is_action_pressed("jump"):
			tryJump()
			get_tree().set_input_as_handled()
		if event.is_action_pressed("restart"):
			die()
			get_tree().set_input_as_handled()
		if event.is_action_pressed("dash") and dashTimer.is_stopped():
			dash()
			dashTimer.start()
			get_tree().set_input_as_handled()
		
		
func dash():
	var angle = get_global_mouse_position().angle_to_point(position)
	self.blood -= Cfg.p_dash_cost
	dashDirection = Vector2(cos(angle),sin(angle))
	dashing = true
	yield(get_tree().create_timer(Cfg.p_dash_duration),"timeout")
	dashing = false
	
		
func tryJump():
	for jump in jumps:
		if jump["canJump"]:
			vel.y = -jump["jumpForce"]
			jump["canJump"] = false
			self.blood -= jump["bloodCost"]
			$Jump.play()
			break
			
func resetJumps():
	for jump in jumps:
		jump["canJump"] = true
	
func shoot():
	var angle = get_global_mouse_position().angle_to_point(position)
	var bullet = Refs.bulletSc.instance()
	Refs.main.add_child(bullet)
	bullet.init(self,Cfg.p_bullet_size, Cfg.p_bullet_speed, angle,Cfg.p_damage, Cfg.p_invul_attack)
	bullet.set_collision_mask_bit(Refs.mask_player,false)

func _physics_process(delta):
	
	if invulnerable:
		blink()
	
	# Regen blood
	self.blood += Cfg.p_blood_regen * delta
	
	if not ignore_input:
		if Input.is_action_pressed("move_left"):
			acc.x += -1 * Cfg.player_speed
		if Input.is_action_pressed("move_right"):
			acc.x += 1 * Cfg.player_speed
		
	
	if dashing:
		move_and_slide(dashDirection * Cfg.p_dash_speed, Vector2(0,-1))
	else:
		acc.y += Cfg.gravity
		vel += acc
		vel = move_and_slide(vel, Vector2(0,-1))
		vel.x *= Cfg.p_xvel_decay
		vel.y *= Cfg.p_yvel_decay
		acc *= 0
	
	if is_on_floor():
		resetJumps()
		
	if not ignore_input:
		if Input.is_action_pressed("shoot") and shootTimer.is_stopped():
			shoot()
			shootTimer.start()
			$Shoot.play()
			self.blood -= Cfg.p_shoot_cost
		
		
	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).collider
		if collider.has_method("collisionResponse"):
			collider.collisionResponse(self)
			
func heal(amount):
	self.blood += amount
	# TODO: play a heal sound
	
func beatLevel():
	emit_signal("levelBeat")
	
func getHit(damage, invulnerableTime):
	if not invulnerable:
		self.blood -= damage
		$Hurt.play()
		invulnerable = true
		yield(get_tree().create_timer(invulnerableTime),"timeout")
		invulnerable = false
		
func die():
	emit_signal("playerDead", self)
	
func blink():
	spr.hide()
	yield(get_tree().create_timer(Cfg.p_blink_time),"timeout")
	spr.show()
		
func setBlood(newBlood):
	blood = newBlood
	if blood > Cfg.p_max_blood:
		blood = Cfg.p_max_blood
	if blood < 0:
		die()
	emit_signal("bloodChanged", self)