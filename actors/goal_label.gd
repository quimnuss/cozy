extends Label


func _on_goal_distance_changed(distance : float):
    var display_distance : int = round(distance/10) as int
    if distance < 5:
        display_distance = 0
    self.text = str(display_distance) + ' cm'

func _on_goal_reached(goal_num : int):
    var extra_text : String = ''
    match goal_num:
        0:
            extra_text = '+H20'
        2:
            extra_text = '+H20'
        1:
            extra_text = '+Light'
        3:
            extra_text = 'Bloom'

    self.text = extra_text + ' Visited!'
    self.add_theme_font_size_override("font_size", 18)
    #queue_free()
