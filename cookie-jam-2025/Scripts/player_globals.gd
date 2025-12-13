extends Card
#BASE STATS
const BASE_SPEED = 400.0
const BASE_JUMP = -500.0
const BASE_ATTACK_SPEED = 1.0
const BASE_DAMAGE = 10.0
const BASE_HP = 250.0
const BASE_MAX_JUMPS = 1.0

var speed_add := 0.0
var jump_add := 0.0
var attack_speed_add :=0.0
var damage_add :=0.0
var max_hp_add :=0.0
var max_jumps_add :=0.0

var speed_mult := 1.0
var jump_mult := 1.0
var attack_speed_mult :=1.0
var damage_mult :=1.0
var max_hp_mult :=1.0
#ACTUAL STATS FORMULA
var speed = (BASE_SPEED + speed_add) * speed_mult
var jump = (BASE_JUMP + jump_add) * jump_mult
var attack_speed = (BASE_ATTACK_SPEED + attack_speed_add) * attack_speed_mult
var damage = (BASE_DAMAGE + damage_add) * damage_mult
var max_hp = (BASE_HP + max_hp_add) * max_hp_mult
var max_jumps = BASE_MAX_JUMPS + max_jumps_add

#stats are: speed, jump, attack_speed, damage, max_hp, max_jumps
#types are: a, m (for additive and multiplicative)
#value is float value that will be added to specified modifier
@warning_ignore("shadowed_variable_base_class")
func modify_stat(stat: String, type:String, value:float) -> void:
	match stat:
		'speed':
			if type == 'a':
				speed_add+=value
			elif type == 'm':
				speed_mult+=value
		'jump':
			if type == 'a':
				jump_add+=value
			elif type == 'm':
				jump_mult+=value
		'attack_speed':
			if type == 'a':
				attack_speed_add+=value
			elif type == 'm':
				attack_speed_mult+=value
		'damage':
			if type == 'a':
				damage_add+=value
			elif type == 'm':
				damage_mult+=value
		'max_hp':
			if type == 'a':
				max_hp_add+=value
			elif type == 'm':
				max_hp_mult+=value
		'max_jumps':
			if type == 'a':
				max_jumps+=value

var cards : Array[Card]
var player_modifiers : Array[Modifier]
var player_augments : Array[String]

func update_modifiers() -> void:
	speed_add = 0.0
	jump_add = 0.0
	attack_speed_add =0.0
	damage_add =0.0
	max_hp_add =0.0
	max_jumps_add = 0.0
	
	speed_mult = 1.0
	jump_mult = 1.0
	attack_speed_mult =1.0
	damage_mult =1.0
	max_hp_mult =1.0
	player_modifiers.clear()
	for card in cards:
		if len(card.modifiers)>0:
			for modifier in card.modifiers:
				player_modifiers.append(modifier)
	for modifier in player_modifiers:
		modify_stat(modifier.stat,modifier.type,modifier.value)
		
func update_stats() -> void:
	update_modifiers()
	speed = (BASE_SPEED + speed_add) * speed_mult
	jump = (BASE_JUMP + jump_add) * jump_mult
	attack_speed = (BASE_ATTACK_SPEED + attack_speed_add) * attack_speed_mult
	damage = (BASE_DAMAGE + damage_add) * damage_mult
	max_hp = (BASE_HP + max_hp_add) * max_hp_mult
	max_jumps = BASE_MAX_JUMPS + max_jumps_add

func update_augments() -> void:
	player_augments.clear()
	for card in cards:
		if len(card.augments)>0:
			for augment in card.augments:
				player_augments.append(augment)

func add_card(card : Card) -> void :
	cards.append(card)
	update_stats()
	update_augments()
	resolve_augoments()

func debug_gen_card(card_tier:int=1) -> void:
	var new_card = Card.new()
	new_card.card_name = "card "+str(len(cards))+" tier "+str(card_tier)
	match card_tier:
		1:
			var positive_modifier = Modifier.new()
			positive_modifier.stat = ['speed', 'jump', 'attack_speed', 'damage', 'max_hp'].pick_random()
			positive_modifier.type = ['a','m'].pick_random()
			if positive_modifier.type =='a':
				positive_modifier.value = float(randi_range(10,25))
			else:
				positive_modifier.value = snapped(randf_range(0.10,0.20),0.01)
			new_card.modifiers.append(positive_modifier)
			var negative_modifier = Modifier.new()
			negative_modifier.stat = ['speed', 'jump', 'attack_speed', 'damage', 'max_hp'].pick_random()
			negative_modifier.type = ['a','m'].pick_random()
			if negative_modifier.type =='a':
				negative_modifier.value = float(randi_range(-15,-5))
			else:
				negative_modifier.value = snapped(randf_range(-0.10,-0.05),0.01)
			new_card.modifiers.append(negative_modifier)
		2:	
			var positive_choice = ['modifier','modifier','modifier','augment'].pick_random()
			match positive_choice:
				'modifier':
					var positive_modifier = Modifier.new()
					positive_modifier.stat = ['speed', 'jump', 'attack_speed', 'damage', 'max_hp','max_jumps'].pick_random()
					if positive_modifier.stat=='max_jumps':
						positive_modifier.type = 'a'
						positive_modifier.value = 1
					else:
						positive_modifier.type = ['a','m'].pick_random()
						if positive_modifier.type =='a':
							positive_modifier.value = float(randi_range(10,30))
						else:
							positive_modifier.value = snapped(randf_range(0.15,0.25),0.01)
						new_card.modifiers.append(positive_modifier)
					#print("P_MOD: ", positive_modifier.stat, " ",positive_modifier.type," ",positive_modifier.value)
				'augment':
					var options = ['thorns','swiftness','regen']
					#for i in range(len(options)):
						#if options[i] in player_augments:
							#options.remove_at(i)
					var positive_augment = options.pick_random()
					new_card.augments.append(positive_augment)
					player_augments.append(positive_augment)
			var negative_choice = ['modifier','modifier','modifier','augment'].pick_random()
			match negative_choice:
				'modifier':
					var negative_modifier = Modifier.new()
					negative_modifier.stat = ['speed', 'jump', 'attack_speed', 'damage', 'max_hp'].pick_random()
					negative_modifier.type = ['a','m'].pick_random()
					if negative_modifier.type =='a':
						negative_modifier.value = float(randi_range(-40,-5))
					else:
						negative_modifier.value = snapped(randf_range(-0.35,-0.05),0.01)
					new_card.modifiers.append(negative_modifier)
					#print("N_MOD: ", negative_modifier.stat," ",negative_modifier.type," ",negative_modifier.value)
				'augment':
					var options = ['reverse thorns','poisoned','nearsighted']
					#for i in range(len(options)):
						#if options[i] in player_augments:
							#options.remove_at(i)
					var negative_augment = options.pick_random()
					new_card.augments.append(negative_augment)
					player_augments.append(negative_augment)
		3:
			var positive_choice = ['modifier','augment'].pick_random()
			match positive_choice:
				'modifier':
					var positive_modifier = Modifier.new()
					positive_modifier.stat = ['speed', 'jump', 'attack_speed', 'damage', 'max_hp','max_jumps'].pick_random()
					if positive_modifier.stat=='max_jumps':
						positive_modifier.type = 'a'
						positive_modifier.value = randi_range(1,2)
					else:
						positive_modifier.type = ['a','m'].pick_random()
						if positive_modifier.type =='a':
							positive_modifier.value = float(randi_range(20,60))
						else:
							positive_modifier.value = snapped(randf_range(0.2,0.4),0.01)
						new_card.modifiers.append(positive_modifier)
					#print("P_MOD: ", positive_modifier.stat, " ",positive_modifier.type," ",positive_modifier.value)
				'augment':
					var options = ['vamp','swiftness','scopiest weapons']
					#for i in range(len(options)):
						#if options[i] in player_augments:
							#options.remove_at(i)
					var positive_augment = options.pick_random()
					new_card.augments.append(positive_augment)
					player_augments.append(positive_augment)
			var negative_choice = ['modifier','augment'].pick_random()
			match negative_choice:
				'modifier':
					var negative_modifier = Modifier.new()
					negative_modifier.stat = ['speed', 'jump', 'attack_speed', 'damage', 'max_hp'].pick_random()
					negative_modifier.type = ['a','m'].pick_random()
					if negative_modifier.type =='a':
						negative_modifier.value = float(randi_range(-120,-5))
					else:
						negative_modifier.value = snapped(randf_range(-0.80,-0.05),0.01)
					new_card.modifiers.append(negative_modifier)
					#print("N_MOD: ", negative_modifier.stat," ",negative_modifier.type," ",negative_modifier.value)
				'augment':
					var options = ['tainted','vulnerable']
					#for i in range(len(options)):
						#if options[i] in player_augments:
							#options.remove_at(i)
					var negative_augment = options.pick_random()
					new_card.augments.append(negative_augment)
					player_augments.append(negative_augment)
	add_card(new_card)

func resolve_augoments() -> void :
	for augment in player_augments:
		match augment:
			'thorns':
				#enemies takes damage as they damage you
				pass
			'reverse thorns':
				#YOU take damage as you damage enemies
				pass
			'vamp':
				#you heal 20% damage you deal
				pass
			'tainted':
				#you cant heal or regenerate during battle
				pass
			'vulnerable':
				#you take double damage
				pass
			'swiftness':
				#the faster you are the more damage you deal
				pass
			'scopiest weapons':
				#gain range
				pass
			'regen':
				#constantly heal
				pass
			'poisoned':
				#constantly loose hp
				pass
			'nearsighted':
				#-80%range
				pass
			'glass cannon':
				#x5damage but -80% max hp
				pass
			
