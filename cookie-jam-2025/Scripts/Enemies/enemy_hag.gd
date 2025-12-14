extends CharacterBody2D

@export var speed = 120.0
@export var jump_force = -450.0
@export var gravity = 980.0
@export var attack_range = 80.0 
@export var damage = 20
var hp = 15;

var player = null
@onready var sword_hitbox = $SwordHitbox
@onready var sprite = $Sprite2D
@onready var attack_timer = $AttackTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var handslam: AnimatedSprite2D = $SwordHitbox/handslam
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var baba_attack: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_attacking = false

func _ready():
	add_to_group("enemies")
	sword_hitbox.monitoring = true
	player = get_tree().get_first_node_in_group("player")
	handslam.play("smash")

func _physics_process(delta):
	if ray_cast_2d.is_colliding() and is_on_floor():
		velocity.y += -50
	if not is_on_floor():
		velocity.y += gravity * delta

	if player:
		ray_cast_2d.look_at(player.global_position)
		var distance = global_position.distance_to(player.global_position)
		var direction_x = sign(player.global_position.x - global_position.x)
		
		if distance > attack_range:
			velocity.x = direction_x * speed
			update_facing(direction_x)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			

		if is_on_floor() and player.velocity.y < -100: 
			jump_towards_player()

	elif is_attacking:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func update_facing(dir_x):
	if dir_x > 0:
		animated_sprite_2d.flip_h = false
		sword_hitbox.scale.x = 1 
	elif dir_x < 0:
		animated_sprite_2d.flip_h = true
		sword_hitbox.scale.x = -1

func jump_towards_player():
	print("Baba: Hopsa! Skaczę za tobą!")
	velocity.y = jump_force
	var dir = sign(player.global_position.x - global_position.x)
	velocity.x = dir * speed * 1.5 


func take_dmg(amount):
	hp -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if hp <= 0:
		die()

func die():
	queue_free()
	
func _on_sword_hitbox_body_entered(body):
	if body.is_in_group("player"):
		#print("Gracz dostał z miecza!")
		baba_attack.play()
		body.take_dmg(damage)
		if Player_globals.thorns:
			take_dmg(5)
		print(body.hp)
