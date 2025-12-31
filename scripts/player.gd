extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -850.0   
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var projectile_scene = preload("res://scripts/buttet.tscn")

var shoot_timer = 0.0
var is_shooting = false
var last_direction = 1  

func _physics_process(delta: float) -> void:
	
	if is_shooting:
		shoot_timer -= delta
		if shoot_timer <= 0:
			is_shooting = false
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("left", "right")
	
	
	if direction != 0:
		last_direction = direction
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	if direction == 1: 
		animated_sprite_2d.flip_h = false
	elif direction == -1: 
		animated_sprite_2d.flip_h = true
	
	
	if not is_shooting:
		if velocity.x > 1 or velocity.x < -1:
			animated_sprite_2d.animation = "run"
		else:     
			animated_sprite_2d.animation = "idle"

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot_towards_mouse()

func shoot_towards_mouse():
	
	animated_sprite_2d.play("shoot")
	is_shooting = true
	shoot_timer = 0.5
	
	
	var projectile = projectile_scene.instantiate()
	projectile.init_position = global_position
	projectile.shooter = self
	
	
	projectile.direction = Vector2(last_direction, 0)
	
	get_parent().add_child(projectile)
