extends RichTextLabel

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sb = rng.randi_range(0,2)
	match sb:
		0:
			text = "You might be the only person ever to have beaten this game. Contact darkgengar on Discord for your prize"
		1:
			text = "You might be the only person ever to have beaten this game. Contact dudsztor on Discord for your prize"
		2:
			text = "You might be the only person ever to have beaten this game. Contact asia_z on Discord for your prize"
