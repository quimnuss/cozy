extends Label


func _on_goal_distance_changed(distance : float):
    var display_distance : int = round(distance/10) as int
    if distance < 5:
        display_distance = 0
    self.text = str(display_distance) + ' cm'

func _on_goal_reached(_goal_num : int):
    self.text = 'Visited!'
    self.add_theme_font_size_override("font_size", 18)
    #queue_free()
