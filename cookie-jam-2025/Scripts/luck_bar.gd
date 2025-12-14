extends ProgressBar

@export var decay_speed: float = 25.0  

@export var refill_amount: float = 25.0 

var player_dead: bool = false

func _ready():
	value = 100
	max_value = 100

func _process(delta):
	if player_dead: return

	if Player_globals.addicted == Player_globals.recovery:
		value -= decay_speed * delta
	if Player_globals.addicted and !Player_globals.recovery:
		value -= decay_speed *2* delta		
		
	if value > 50:
		modulate = Color.GREEN
	elif value > 25:
		modulate = Color.YELLOW
	else:
		modulate = Color.RED

	if value <= 0:
		die()
		get_parent().get_parent().get_parent().die()

func add_luck():
	if player_dead: return
	
	value += refill_amount
	if value > max_value:
		value = max_value

func die():
	player_dead = true
	print("Game Over - Pasek spadł do 0!")
