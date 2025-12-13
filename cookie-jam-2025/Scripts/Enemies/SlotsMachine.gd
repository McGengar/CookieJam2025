extends StaticBody2D

@onready var label = $Label
@onready var sprite = $Sprite2D

var is_used: bool = false
var buff_duration: float = 10.0
var use_count = 3
func take_dmg(amount):
	use_count -=1
	if use_count <= 0:
		show_text("WYCZERPANA", Color.RED)
		return
	else:	
		activate_machine()

func activate_machine():
	is_used = true
	
	var player = get_tree().get_first_node_in_group("player")
	if not player: 
		is_used = false
		return
		
	var tween = create_tween()
	modulate = Color.DIM_GRAY
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)

	if randf() > 0.6:
		apply_punishment(player)
	else:
		apply_reward(player)
		
	await get_tree().create_timer(0.8).timeout
	
	modulate = Color.WHITE
	is_used = false

func apply_punishment(player):
	show_text("PECH!", Color.RED)
	var damage_amount = player.hp * 0.4
	player.take_dmg(damage_amount)
	print("-hp: " + str(player.hp))

func apply_reward(player):
	var roll = randi() % 5
	
	match roll:
		0:
			show_text("+DMG!", Color.GOLD)
			#print(player.damage)
			player.damage = player.damage + 0.5*player.damage
			print("+damage: " + str(player.damage))
		1:
			show_text("+ATCK SPD!", Color.CYAN)
			#print(player.attack_speed)
			player.attack_speed = player.attack_speed + 0.3*player.attack_speed
			print("+atck speed: " + str(player.attack_speed))
		2:
			show_text("+HP!", Color.GREEN)
			#print(player.hp)
			player.hp = player.hp + 1*player.hp
			print("+hp: " + str(player.hp))
		3:
			show_text("+JUMP!", Color.GREEN)
			#print(player.hp)
			player.JUMP_VELOCITY = player.JUMP_VELOCITY + 0.1*player.JUMP_VELOCITY
			print("+jump: " + str(player.JUMP_VELOCITY))
		4:
			show_text("+MAX HP!", Color.GREEN)
			#print(player.max_hp)
			player.max_hp = player.max_hp + 0.2*player.max_hp
			print("+max_hp: " + str(player.max_hp))

func show_text(text, color):
	if label:
		label.text = text
		label.modulate = color
		await get_tree().create_timer(1.5).timeout
		label.text = ""
