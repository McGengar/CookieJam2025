extends Node2D

@export var New_card : PackedScene
@export var selected_card : int = 0
var array
func _ready():
	reload()

func reload():
	for child in get_children():
		child.queue_free()
	for i in range(len(Player_globals.cards)):
		var card = New_card.instantiate()
		card.tier = Player_globals.cards[i].tier
		card.card_id=i	
		card.scale = Vector2(3,3)
		add_child(card)
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var new_card_tier = randi_range(1,4)
		var card = New_card.instantiate()
		card.tier= new_card_tier
		card.card_id = len(Player_globals.cards) -1
		add_child(card)
		reload()
	array = get_children()
	var count = get_child_count()
	var mid
	if count%2==0:
		mid = (count+1)/2.0
	else:
		mid = floor(count/2.0)+1
	for i in range(count):
		array[i].scale.x = lerpf(array[i].scale.x, 1, delta*5)
		array[i].scale.y = lerpf(array[i].scale.y, 1, delta*5)
		if array[i].selected:
			selected_card = i
			array[i].position.y = lerp(array[i].position.y,-cos((i+1-mid)/(2+(count/10.0)))*64,delta*10)
		else:
			array[i].position.y = lerp(array[i].position.y,-cos((i+1-mid)/(2+(count/10.0)))*48,delta*10)
		array[i].position.x = lerp(array[i].position.x,(i+1-mid)*(64+32*log(count)/log(2.5))/(1+count/15.0),delta*10)
		array[i].rotation = lerp(array[i].rotation, deg_to_rad(sin((i+1-mid)/(2+(count/10.0)))*24),delta*10)
	position.y = lerp(position.y,600-count*2.0,delta*10)
