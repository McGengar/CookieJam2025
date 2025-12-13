extends ProgressBar

@onready var player: CharacterBody2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = Player_globals.max_hp
	max_value = Player_globals.max_hp
	modulate = Color.RED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = player.hp
