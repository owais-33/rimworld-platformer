extends Area2D

var speed = 400
var direction = Vector2.RIGHT
var init_position = Vector2.ZERO 

func _ready():
	# Connect to detect hits
	body_entered.connect(_on_body_entered)
	global_position = init_position

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	# Handle what happens when projectile hits something
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free()  # Destroy the projectile
