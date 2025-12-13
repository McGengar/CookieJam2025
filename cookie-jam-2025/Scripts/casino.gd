extends Node2D

@onready var hand = $Hand
@onready var button = $Button
@onready var next_level = $NextLevel

var counter : int =1
var disappearing = false
var alpha =1
# Called when the node enters the scene tree for the first time.
func _ready():
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
	shake(counter*2,counter)
	if counter<5:
		Player_globals.debug_gen_card(counter)
		button.scale.x = counter*2
		button.scale.y = counter*2
		hand.reload()
		counter +=1
		if counter==5:
			disappearing = true
	

func _on_next_level_pressed():
	if Player_globals.level_counter<10:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_0"+str(Player_globals.level_counter)+".tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_"+str(Player_globals.level_counter)+".tscn")
