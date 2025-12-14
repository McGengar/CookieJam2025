extends Node2D

@onready var hand = $Hand
@onready var button = $Button
@onready var next_level = $NextLevel
@onready var stats = $Stats
@onready var traits = $Traits

@export var new_card_pop_up : PackedScene

var counter : int =1
var disappearing = false
var alpha =1
var can_remove = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if len(Player_globals.cards)>0:
		can_remove = true
	Player_globals.blocked=false
	counter =1
	hand.reload()

var shake_amount: float = 10.0   # Maximum displacement in pixels
var shake_duration: float = 0.5  # Duration of shake in seconds
var shake_speed: float = 50.0    # How fast it shakes

var _original_position: Vector2
var _shake_timer: float = 0.0
var _shaking: bool = false



func shake(amount: float = 10.0, duration: float = 0.5):
	shake_amount = amount
	shake_duration = duration
	_shake_timer = duration
	_original_position = button.position
	_shaking = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_remove:
		$remove.visible=true
	else:
		$remove.visible=false
	var SPEED = Player_globals.speed
	var JUMP_VELOCITY = Player_globals.jump
	var attack_speed = Player_globals.attack_speed
	var damage = Player_globals.damage
	var max_hp = Player_globals.max_hp
	var max_jumps = Player_globals.max_jumps
	
	stats.text = "speed = " + str(SPEED) + "[br]" + \
			 "jump = " + str(-1*JUMP_VELOCITY) + "[br]" + \
			 "attack speed = " + str(attack_speed) + "[br]" + \
			 "damage = " + str(damage) + "[br]" + \
			 "max hp = " + str(max_hp) + "[br]" + \
			 "max jumps = " + str(max_jumps)
	
	traits.text = "Active traits: [br]"
	var unique_traits = []
	var desc = []
	
	for augment in Player_globals.player_augments:
		if augment not in unique_traits:
			unique_traits.append(augment)
			var description
			match augment:
				"thorns":
					description = "Damage enemies who hit you"
				"reverse thorns":
					description = "Damage self on attack"
				"vamp":
					description = "Heal when dealing damage"
				"tainted":
					description = "Cannot heal in battle"
				"vulnerable":
					description = "Take more damage"
				"swiftness":
					description = "Damage scales with speed"
				"scopiest weapons":
					description = "Greatly increased range"
				"regen":
					description = "Constantly heal over time"
				"poisoned":
					description = "Constantly lose health"
				"nearsighted":
					description = "Greatly decreased range"
				"glass cannon":
					description = "Huge damage, low HP"
				"grounded":
					description = "Cannot jump at all"
				"healer":
					description = "Increased healing"
				"floor is lava":
					description = "Staying on floor hurts you"
				"hot walls":
					description = "Jumping on walls hurts you"
				"recovery":
					description = "No longer needs to scroll"
				"addicted":
					description = "Attention span decreased"
			desc.append(description)
	
	for i in range(len(unique_traits)):
		traits.text =traits.text + str(unique_traits[i]) +" - " + desc[i] +"[br]"
	
	if Input.is_action_just_pressed("deubg_2"):
		Player_globals.remove_card(hand.selected_card)
		hand.reload()
	if _shaking and button:
		_shake_timer -= delta
		if _shake_timer <= 0:
			# Stop shaking
			_shaking = false
			button.position = _original_position
		else:
			# Apply random shake
			var offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
			button.position = _original_position + offset
	if button:
		if disappearing==false:
			button.scale.x = lerpf(button.scale.x, counter*0.7, delta*5)
			button.scale.y = lerpf(button.scale.y, counter*0.7, delta*5)
		else:
			button.scale.x = lerpf(button.scale.x, 20, delta*5)
			button.scale.y = lerpf(button.scale.y, 20, delta*5)
			button.modulate = Color(1,1,1,alpha)
			alpha = lerpf(alpha,0, delta*5)
			if alpha<0.01:
				button.queue_free()

func _on_button_pressed():
	print("AAAAAA")
	
	if Player_globals.blocked==false:
		print("BBBBB")
		$next_card_song.play()
		if counter<5:
			print("CCCCC")
			Player_globals.blocked=true
			shake(counter*2,counter)
			var new_card = Player_globals.debug_gen_card(counter)
			hand.reload()
			await get_tree().create_timer(0.2).timeout
			var card = new_card_pop_up.instantiate()
			card.tier= counter
			card.card_id = len(Player_globals.cards) -1
			if len(new_card.modifiers)>0:
				if new_card.modifiers[0].positive:
					card.positive=true
			else:
				if new_card.augments[0] in ['scopiest weapons', 'recovery','glass cannon','healer','vamp','swiftness','regen','thorns']:
					card.positive=true 
			card.top_text = $Hand.get_child($Hand.get_child_count()-1).get_node('PContainer').get_node('Positive').text
			card.bottom_text = $Hand.get_child($Hand.get_child_count()-1).get_node('NContainer').get_node('Negative').text
			
			
			add_child(card)
			
			button.scale.x = counter*2
			button.scale.y = counter*2
			counter +=1
			if counter==5:
				disappearing = true

func _on_next_level_pressed():
	if Player_globals.level_counter<10:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_0"+str(Player_globals.level_counter)+".tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_"+str(Player_globals.level_counter)+".tscn")
