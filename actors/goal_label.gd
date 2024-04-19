extends Label


func _on_goal_distance_changed(distance : float):
    var display_distance : int = round(distance/10) as int
    self.text = str(display_distance) + ' cm'
    if distance < 100:
        queue_free()
