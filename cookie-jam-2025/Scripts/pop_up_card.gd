extends Node2D

@export var card_id := 0
@export var tier := 0
var top_text :=""
var bottom_text:=""

var positive_modifier : Modifier
var negative_modifier : Modifier

var state = 'growing'
var positive := false

func _ready():
	if positive:
		$Pos.emitting=true
	else:
		$Neg.emitting=true
	$Figure.frame=tier
	$PContainer/Positive.text = top_text
	$NContainer/Negative.text = bottom_text
func _process(delta):
	if state =='growing':
		scale.x = lerpf(scale.x, 8, delta*5)
		scale.y = lerpf(scale.y, 8, delta*5)
	if scale.x >6:
		state = 'shrinking'
	if state=='shrinking':
		scale.x = lerpf(scale.x, 3, delta*2)
		scale.y = lerpf(scale.y, 3, delta*2)
	if scale.x <3.1 and state == 'shrinking':
		state = 'dis'
	if state == 'dis':
		scale.x = lerpf(scale.x, 0, delta*5)
		scale.y = lerpf(scale.y, 0, delta*5)
	if scale.x<0.1:
		Player_globals.blocked=false
		queue_free()
