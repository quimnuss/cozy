extends Control


func _input(event):
    if visible:
        if event.is_action_pressed("main_action") or event.is_action_pressed("move_up"):
            self.queue_free()

func _on_player_death():
    self.visible = true
