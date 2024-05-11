extends Node

var tween : Tween

var shake_amount = 5
var one_shake_duration = 0.1
var shake_duration = 0.5

var original_position : Vector2 = Vector2(0,0)

func _ready():
    # usually it will be 0,0 We assume that the parent will not move
    original_position = get_parent().position

func _input(event):
    if event.is_action_pressed("initial_sprout"):
        if tween and tween.is_running():
            stop_shaking()
        else:
            shake()

func stop_shaking():
    get_tree().create_tween().tween_property(get_parent(), "position", original_position, one_shake_duration)
    tween.kill()

func new_shake():
    tween = get_tree().create_tween()
    var shake_vector = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
    tween.tween_property(get_parent(), "position", shake_vector, one_shake_duration)
    tween.tween_callback(new_shake)

func shake():
    if shake_duration > 0:
        get_tree().create_timer(shake_duration).timeout.connect(stop_shaking)
    new_shake()
    tween.play()
