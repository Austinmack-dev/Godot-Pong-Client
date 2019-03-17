extends KinematicBody2D

var moveDir = Vector2(-1,-1)
#var velocity = Vector2()

func _ready():
	var delta = 1
	#velocity = moveDir * 125
	
puppet func ball_move(pos,mvDir):
	position = pos
	moveDir = mvDir

func _physics_process(delta):
	rpc_id(1,"_send_server_ball_move_info",moveDir,delta)
	print("after send on client")
#	var coll = move_and_collide(velocity*delta)
#	if(coll):
#		velocity = velocity.bounce(coll.normal)
	
	