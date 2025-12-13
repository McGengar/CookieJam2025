extends Node2D

@onready var hand = $Hand
@onready var button = $Button

var counter : int =1
var disappearing = false
var alpha =1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	if counter<5:
		Player_globals.debug_gen_card(counter)
		button.scale.x = counter*2
		button.scale.y = counter*2
		hand.reload()
		counter +=1
		if counter==5:
			disappearing = true
	
