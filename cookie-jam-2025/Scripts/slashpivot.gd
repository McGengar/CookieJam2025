extends RigidBody2D
@onready var player: CharacterBody2D = $".."
@onready var atkcd: Timer = $atkcd
var can_atk = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if can_atk:
			look_at(get_global_mouse_position())
			rotation -= deg_to_rad(90)
			can_atk = false
			atkcd.start()


func _on_atkcd_timeout() -> void:
	if can_atk == false:
		can_atk = true
