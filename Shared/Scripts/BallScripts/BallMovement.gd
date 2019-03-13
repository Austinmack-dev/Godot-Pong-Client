extends KinematicBody2D

const moveSpeed = 100
var velocity = Vector2(-1,-1)*moveSpeed

func _physics_process(delta):
	var col = move_and_collide(velocity*delta)
	if col:
		velocity = velocity.bounce(col.normal)
