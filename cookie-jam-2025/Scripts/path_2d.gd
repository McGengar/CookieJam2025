extends Path2D

@onready var player: CharacterBody2D = $".."
var original_pos = [curve.get_point_in(0),curve.get_point_in(1),curve.get_point_in(2)]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_climbing == false:
		print(curve.get_point_position(0))
		curve.set_point_position(0,player.position + original_pos[0])
		curve.set_point_position(1,player.position + original_pos[1])
		curve.set_point_position(2,player.position + original_pos[2])
