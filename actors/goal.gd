extends Node2D

class_name Goal

@export var goal_num : int

signal distance_changed(distance : float)

signal goal_reached(goal_num : int)

func ready():
    add_to_group('goals')

func pick_up():
    goal_reached.emit(goal_num)
    queue_free()

func _process(delta):
    var distance : float = self.global_position.distance_to(Global.player.global_position)
    distance_changed.emit(distance)

func _on_area_2d_body_entered(body):
    if body is Player:
        pick_up()
