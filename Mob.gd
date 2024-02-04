extends CharacterBody3D

@export var min_speed = 10	# 最小速度
@export var max_speed = 18	# 最大速度

func _physics_process(delta):
	move_and_slide()

func initialize(start_position,player_position):
	look_at_from_position(start_position,player_position,Vector3.UP)
	rotate_y(randf_range(-PI/4,PI/4))
	
	var random_speed = randi_range(min_speed,max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP,rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()