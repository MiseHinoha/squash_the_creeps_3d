extends CharacterBody3D
signal  hit	# 受伤信号

# 移动速度
@export var speed = 14

# 重力加速度
@export var fall_acceleration = 75	# 掉落立
@export var jump_impulse = 20	# 跳跃高度
@export var bounce_impulse = 16	# 踩到怪物后弹力

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	# 基础移动
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	# 归一化 direction
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	#print("player y %s" %target_velocity.y)
	
	# 跳跃
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# 掉落
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# 判断是否踩到怪物
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("Mob"):
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
				break
	
	# 移动角色
	velocity = target_velocity
	move_and_slide()
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

# 死亡逻辑
func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()
