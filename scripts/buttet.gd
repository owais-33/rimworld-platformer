extends Area2D
var speed = 400
var direction = Vector2.RIGHT
var init_position = Vector2.ZERO 
var shooter = null

func _ready():
	body_entered.connect(_on_body_entered)
	global_position = init_position
	global_position += direction * 20

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body == shooter:
		return
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free()
