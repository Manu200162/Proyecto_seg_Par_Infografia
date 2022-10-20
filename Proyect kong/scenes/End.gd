extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$is_rescued.play()
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_restart_bttn_pressed():
	get_tree().change_scene("res://scenes/Main.tscn") # Replace with function body.


func _on_quit_bttn_pressed():
	get_tree().quit() # Replace with function body.
