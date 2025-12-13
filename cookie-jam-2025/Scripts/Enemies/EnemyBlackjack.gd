extends CharacterBody2D

@export var max_speed = 350.0
@export var acceleration = 250.0
@export var hp = 15

var player = null

func _ready():
	add_to_group("enemies")

	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)

		if velocity.length() > 0:
			look_at(player.global_position)

	move_and_slide()

func take_dmg(amount):
	hp -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	if hp <= 0:
		die()

func die():
	queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		print("Gracz dostał kartą!")
