extends CharacterBody2D

@export var speed = 170.0
@export var jump_force = -450.0
@export var gravity = 980.0
@export var attack_range = 30.0 
@export var damage = 10
var hp = 15;
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dziadsword: Node2D = $dziadsword
@onready var sword_hitbox: Area2D = $dziadsword/swordsprite/SwordHitbox
@onready var swordsprite: Sprite2D = $dziadsword/swordsprite

@onready var sword_attack: AudioStreamPlayer2D = $AudioStreamPlayer2D

var player = null


@onready var attack_timer = $AttackTimer

var is_attacking = false

func _ready():
	add_to_group("enemies")
	sword_hitbox.monitoring = false
	
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	dziadsword.look_at(player.global_position)
	if not is_on_floor():
		velocity.y += gravity * delta

	if player:
		var distance = global_position.distance_to(player.global_position)
		var direction_x = sign(player.global_position.x - global_position.x)
		if distance < 4*attack_range:
			perform_attack()
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
		sprite.flip_h = false
		sword_hitbox.scale.x = 1 
	elif dir_x < 0:
		sprite.flip_h = true
		sword_hitbox.scale.x = -1

func jump_towards_player():
	print("Dziad: Hopsa! Skaczę za tobą!")
	velocity.y = jump_force
	var dir = sign(player.global_position.x - global_position.x)
	velocity.x = dir * speed * 1.5 

func perform_attack():
	if attack_timer.is_stopped():
		#print("Dziad: Cios mieczem!")
		sword_attack.play()
		is_attacking = true
		swordsprite.visible = true
		sprite.play("new_animation")
		sword_hitbox.monitoring = true
		var original_speed = 170
		await get_tree().create_timer(0.5).timeout
		sprite.modulate = Color.YELLOW
		speed *= 1.2
		speed = clamp(speed,170,600)
		await get_tree().create_timer(0.5).timeout
		speed = original_speed
		swordsprite.visible = false
		sprite.play("default")
		sword_hitbox.monitoring = false
		sprite.modulate = Color.WHITE
		is_attacking = false
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
		body.take_dmg(damage)
		if Player_globals.thorns:
			take_dmg(5)
		print(body.hp)
