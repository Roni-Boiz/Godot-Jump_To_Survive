extends Actor

export var stomp_impulse := 1000.0

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()


func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var is_down_pressed := Input.is_action_just_pressed("fall") and !is_on_floor()
	var direction := get_direction()
	if direction.x < 0 and !flip or direction.x > 0 and flip : flip_player()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted, is_down_pressed)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_pressed("jump") and is_on_floor() else 0.0 
	)


func flip_player():
	get_node( "player" ).set_flip_h(!flip)
	flip = !flip


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool,
		is_down_pressed : bool
	) -> Vector2:
	var out := linear_velocity
	out.x = speed.x * direction.x
	if is_down_pressed :
		out.y += garavity * get_physics_process_delta_time() * 20
	else :
		out.y += garavity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
		double_jump = true
	if !is_on_floor() and double_jump and Input.is_action_just_pressed("jump") :
		out.y = speed.y * -1
		double_jump = false
	if is_jump_interrupted:
		out.y = 0.0
	return out
	
	
func calculate_stomp_velocity(
	linear_velocity: Vector2,
	impulse: float
) -> Vector2:
	var out := linear_velocity
	out.y = -impulse
	return out

func die() ->void:
	PlayerData.deaths += 1
	queue_free()








