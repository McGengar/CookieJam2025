extends Card
#BASE STATS
const BASE_SPEED = 400.0
const BASE_JUMP = -400.0
const BASE_ATTACK_SPEED = 1.0
const BASE_DAMAGE = 10.0
const BASE_HP = 100.0
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

var cards : Array[Card]
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
	var player_modifiers : Array[Modifier]
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


	
