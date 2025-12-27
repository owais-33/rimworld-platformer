extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -850.0   
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var projectile_scene = preload("res://scripts/buttet.tscn")

func _physics_process(delta: float) -> void:
	#add animations
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "run"
	else:     
		animated_sprite_2d.animation = "idle"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if direction == 1: 
		animated_sprite_2d.flip_h = false
	elif direction == -1: 
		animated_sprite_2d.flip_h = true

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		shoot_towards_mouse()

func shoot_towards_mouse():
	animated_sprite_2d.animation = "shoot"
	var projectile = projectile_scene.instantiate()
	projectile.init_position = global_position
	
	# Calculate direction to mouse
	var mouse_pos = get_global_mouse_position()
	projectile.direction = (mouse_pos - global_position).normalized()
	
	get_parent().add_child(projectile)
