extends CharacterBody3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

@export var acceleration = 10.0
@export var turn_speed = 1.0
@export var jumpy = 5.0

@export var gravity = 9.8
@export var speed = 10.0

@export var max_speed := 12.0
var move_speed := 0.0

func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta
		
	var input_forward = Input.get_axis("forward", "backward")
	var input_turn = Input.get_axis("left", "right")
	
	var slope_force = proj(get_floor_normal(), -transform.basis.z.normalized()) * 1000
	print(slope_force)
	
	if input_forward != 0:
		move_speed = clamp(move_speed + input_forward * acceleration * delta, -max_speed, max_speed)
	elif is_on_floor():
		if abs(move_speed) > 0.01:
			move_speed = move_toward(move_speed, 0, acceleration * delta * 0.5)
		else:
			move_speed = 0.0
	
	var forward = -transform.basis.z
	velocity.x = move_toward(forward.x * move_speed, forward.x * move_speed + slope_force.x, acceleration * delta)
	velocity.z = move_toward(forward.z * move_speed, forward.z * move_speed + slope_force.z, acceleration * delta)
	print(velocity)
	
	var turn_modifier = 1.0 if is_on_floor() else 0.3
	
	if abs(move_speed) > 0.01:
		rotation.y += turn_modifier * input_turn * turn_speed * delta * clamp(move_speed, -10.0, 10.0) * .1
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jumpy
		
	#print(str(rotation.x)+" "+str(rotation.z))
	
	move_and_slide()

func proj(a: Vector3, b: Vector3) -> Vector3:
	return a.dot(b)/b.dot(b)*b
