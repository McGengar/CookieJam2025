extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 980.0

var player = null

func _ready():
	add_to_group("enemies")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if player:
		var direction = global_position.direction_to(player.global_position)
		
		if abs(global_position.x - player.global_position.x) > 10.0:
			velocity.x = sign(direction.x) * SPEED
			update_facing_direction(direction.x)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body):
	if body == player:
		player = null

func update_facing_direction(dir_x):
	if dir_x > 0:
		$Sprite2D.flip_h = false 
	elif dir_x < 0:
		$Sprite2D.flip_h = true
