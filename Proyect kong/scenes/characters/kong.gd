
extends KinematicBody2D
onready var pl_barrel = preload("res://scenes/characters/barrel.tscn")
onready var animation: AnimationPlayer = $AnimationPlayer
const throwing_time = Vector2(3.0,6.0)

#
func _ready():
	randomize()
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start(rand_range(throwing_time.x,throwing_time.y))
	

	$CollisionShape2D.set_deferred("disabled", true)
func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"take_barrel":
			var instance_barrel = pl_barrel.instance()
			get_parent().add_child(instance_barrel)
			instance_barrel.position = global_position
			animation.play("angry")
		"angry":
			$Timer.start(rand_range(throwing_time.x,throwing_time.y))
			animation.play("idle")
		


func _on_Timer_timeout():
	animation.play("take_barrel")
	




