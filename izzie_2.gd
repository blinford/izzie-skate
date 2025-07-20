extends CharacterBody3D

@export var acceleration = 10.0
@export var gravity = -9.8
@export var jump = 5.0

var forward

func _physics_process(delta: float) -> void:
	
	# update forward direction
	forward = -transform.basis.z
	
	var input_forward = Input.get_axis("forward", "backward")
	handle_forward(input_forward, delta)
	
	var input_turn = Input.get_axis("right", "left")
	handle_turn(input_turn, delta)
	
	velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump
	
	move_and_slide()
	
	# adjust velocity to match transform.basis.z (in case of collisions)
	var adjusted_velocity = proj(velocity, forward)
	velocity.x = adjusted_velocity.x
	velocity.z = adjusted_velocity.z
	
	# normal 0.1 0.9 0.0 -> rotation x = 0, z = a bit
	#rotation.x = get_floor_normal().angle_to(Vector3(0.0, 0.0, -1.0)) - PI/2
	#rotation.z = get_floor_normal().angle_to(Vector3(1.0, 0.0, 0.0)) - PI/2

func proj(a: Vector3, b: Vector3) -> Vector3:
	return a.dot(b)/b.dot(b)*b

func handle_forward(input_forward, delta) -> void:
	var slope_force = proj(get_floor_normal(), -forward.normalized()) * -gravity * delta
	
	if input_forward != 0.0 and velocity.length() < 20.0:
		velocity.x += input_forward * forward.x * acceleration * delta
		velocity.z += input_forward * forward.z * acceleration * delta
	#elif slope_force.length() == 0.0:
		#velocity.x = move_toward(velocity.x, 0.0, acceleration * delta * 0.3)
		#velocity.z = move_toward(velocity.z, 0.0, acceleration * delta * 0.3)
	
	#print(slope_force)
	velocity.x += slope_force.x
	velocity.z += slope_force.z
	
	#print(velocity.length())

func handle_turn(input_turn, delta) -> void:
	var turn_modifier = 1.0 if is_on_floor() else 0.3
	var turn = input_turn * turn_modifier * delta * clamp(velocity.length(), -10.0, 10.0) * 0.1
	velocity = velocity.rotated(Vector3(0.0, 1.0, 0.0), turn)
	rotation.y += turn
