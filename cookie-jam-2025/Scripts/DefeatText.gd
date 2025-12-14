extends RichTextLabel
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sb = rng.randi_range(0,10)
	match sb:
		0:
			text="YIKES!"
		1:
			text="Jeszcze.. jeden.."
		2:
			text="Musze... scrollowac.."
		3:
			text="Unlucky!"
		4:
			text="TRAGICZNY!"
		5:
			text="i nawet nie było blisko!"
		6:
			text="BYŁO TAK BLISKO!"
		7:
			text="Było w zasięgu ręki!"
		8:
			text="wina tuska"
		9:
			text="Nie poddawaj sie!"
		10:
			text="dxddd!"
