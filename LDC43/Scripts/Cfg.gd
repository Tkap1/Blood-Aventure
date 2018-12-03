extends Node

# Player
var player_speed = 100.0
var p_xvel_decay = 0.85
var p_yvel_decay = 0.9
var gravity = 9.8 * 10
var p_jump_height = 1500.0
var p_bullet_size = 32.0
var p_bullet_speed = 800.0
var p_max_blood = 1000.0
var p_blood_regen = 50.0
var p_shoot_cost = 20.0
var p_damage = 10.0
var p_invul_attack = 0.0
var p_blink_time = 0.1
var p_jump_cost = 100.0
var p_shoot_delay = 0.2
var p_dash_cost = 200.0
var p_dash_duration = 0.1
var p_dash_speed = 1500.0
var p_dash_cd = 3.0

# Bullet




# Enemy
var e_melee_damage = 350.0
var e_hit_invul_duration = 0.5
var e_sleep_dist = 700.0
var e_speed = 30.0
var e_vel_decay = 0.9
var e_melee_dist = 60.0
var e_bullet_size = 32.0
var e_bullet_damage = 200.0 
var e_bullet_speed = 400.0
var e_shoot_delay = 0.5
var e_shoot_attack_invuln = 0.5
var e_melee_hp = 30.0
var e_ranged_hp = 20.0
var e_reaction_time = 0.25

# Spike
var spike_damage = 10000.0

# Pickup
var pickup_blood_heal = 100.0

# Turret
var turret_shoot_delay = 1.0
var turret_bullet_damage = 300.0
var turret_bullet_size = 32.0
var turret_bullet_speed = 400.0
var turret_shoot_attack_invuln = 0.5

# Z index
var pickup_z = 50.0
var bullet_z = 100.0
var turret_z = 45.0


