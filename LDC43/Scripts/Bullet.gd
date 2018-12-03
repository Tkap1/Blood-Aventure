extends Area2D

var shooter
var size

var vel
var speed
var damage
var invulnTime

var didDamage = false

onready var spr = $Sprite
onready var coll = $CollisionShape2D
onready var vis = $VisibilityNotifier2D

func init(shooter, size, speed, angle, damage, invulnTime):
	add_to_group("removables")
	z_index = Cfg.bullet_z
	
	self.shooter = shooter
	self.size = size
	self.speed = speed
	self.damage = damage
	self.invulnTime = invulnTime
	position = shooter.global_position
	
	coll.shape = CircleShape2D.new()
	coll.shape.radius = size/2.0
	
	vis.rect = Rect2(-size/2, -size/2, size, size)
	
	var newScale = size / spr.texture.get_width()
	spr.scale = Vector2(newScale,newScale)
	
	vel = Vector2(cos(angle),sin(angle))
	
	
func _physics_process(delta):
	position += vel * speed * delta
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	if body != shooter and body.has_method("getHit") and not didDamage:
		body.getHit(damage,invulnTime)
		didDamage = true
		var particles = Refs.bulletParticlesSc.instance()
		Refs.main.add_child(particles)
		particles.position = position
		queue_free()
	elif "TileMap" in body.name:
		var particles = Refs.bulletParticlesSc.instance()
		Refs.main.add_child(particles)
		particles.position = position
		queue_free()
