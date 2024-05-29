extends Area2D


var is_reading : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
    if is_reading and event.is_action_pressed("main_action"):
        get_tree().paused = false
        self.queue_free()


func _on_body_entered(body):
    if body is Player:
        visible = true
        is_reading = true
        get_tree().paused = true
