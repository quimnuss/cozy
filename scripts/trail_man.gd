extends Node2D

@export var target : Node2D
@onready var trail = $Trail
@onready var trail_fridge = $TrailFridge


var previous_point : Vector2

const THRESHOLD = 5

var elapsed = 0

var elapsed_death = 5


@export var HEALTHY_COLOR : Color = Color('#95D904')
@export var DEATH_COLOR : Color = Color('#8C3211')

func to_freezer():
    var new_trail : Line2D = trail.duplicate()
    trail.reparent(trail_fridge)
    trail = new_trail
    trail.clear_points()
    elapsed = 0
    self.add_child(trail)


func _process(delta):
    elapsed += delta
    var new_point : Vector2 = target.global_position
    if previous_point.distance_to(new_point) > THRESHOLD:
        trail.add_point(new_point)

    var ratio = min(elapsed/elapsed_death,1)

    trail.default_color = ratio*DEATH_COLOR + (1 - ratio)*HEALTHY_COLOR


func _on_player_is_watered():
    elapsed = 0
