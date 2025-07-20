extends Area3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	print(str(body) + "BOOM")
	queue_free()
