extends Area2D

var speed = 400
var direction = Vector2.ZERO
var damage = 25

func _ready():
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _physics_process(delta):
	position += direction * speed * delta
	
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		return

	if body.is_in_group("player"):
		#print("Gracz oberwał!")
		body.take_dmg(damage)
		print(body.hp)
		queue_free()
		return

	#print("Trafiono w ścianę: ", body.name)
	queue_free()
