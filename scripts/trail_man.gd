extends Node2D

@export var target : Node2D
@onready var trail = $Trail
@onready var trail_fridge = $TrailFridge


var previous_point : Vector2

const THRESHOLD = 10
const PROP_THRESHOLD = 70



@export var HEALTHY_COLOR : Color = Color('#95D904')
@export var DEATH_COLOR : Color = Color('#8C3211')


func to_freezer():
    var new_trail : Line2D = trail.duplicate()
    trail.reparent(trail_fridge)
    trail.modulate.a = 0.5
    trail = new_trail
    trail.clear_points()
    self.add_child(trail)


func _process(_delta):
    var new_point : Vector2 = target.global_position
    if previous_point.distance_to(new_point) > THRESHOLD:
        trail.add_point(new_point)

    if previous_point.distance_to(new_point) > PROP_THRESHOLD:
        pass

    var ratio : float = 1

    var worse_stat = min(Global.player.water_level, Global.player.light_level)
    if worse_stat < Global.player.STAT_DANGER:
        if Global.player.water_level < Global.player.light_level:
            ratio = clamp(Global.player.water_level/Global.player.STAT_DANGER,0,1)
        else:
            ratio = clamp(Global.player.light_level/Global.player.STAT_DANGER,0,1)

    trail.default_color = ratio*HEALTHY_COLOR + (1 - ratio)*DEATH_COLOR


