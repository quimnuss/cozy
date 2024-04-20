extends Node2D

@export var target : Node2D
@onready var trail = $Trail
@onready var trail_fridge = $TrailFridge


var previous_point : Vector2
var previous_prop_point : Vector2 = Vector2(2432,1773)

const THRESHOLD = 10
const PROP_THRESHOLD = 200

@export var HEALTHY_COLOR : Color = Color('#95D904')
@export var DEATH_COLOR : Color = Color('#8C3211')

var prop : PackedScene = preload('res://actors/plant_prop.tscn')

func _ready():
    randomize()

func to_freezer():
    var new_trail : Line2D = trail.duplicate()
    trail.reparent(trail_fridge)
    trail.modulate.a = 0.5
    trail = new_trail
    trail.clear_points()
    #TODO we do this shananigans to preserve line2d config, if wechange it for a scene we can create a new one and we're done.
    for child in trail.get_children():
        trail.remove_child(child)
    self.add_child(trail)

var rhythm_variation : float = randf() + 1

func _process(_delta):
    var new_point : Vector2 = target.global_position
    if previous_point.distance_to(new_point) > THRESHOLD:
        trail.add_point(new_point)
        previous_point = new_point


    if previous_prop_point.distance_to(new_point) > rhythm_variation*PROP_THRESHOLD:
        var prop : PlantProp = prop.instantiate()
        prop.global_position = new_point
        prop.rotation = target.rotation
        trail.add_child(prop)
        previous_prop_point = new_point
        rhythm_variation = randf_range(0, 1.5) + 0.5

    var ratio : float = 1

    var worse_stat = min(Global.player.water_level, Global.player.light_level)
    if worse_stat < Global.player.STAT_DANGER:
        if Global.player.water_level < Global.player.light_level:
            ratio = clamp(Global.player.water_level/Global.player.STAT_DANGER,0,1)
        else:
            ratio = clamp(Global.player.light_level/Global.player.STAT_DANGER,0,1)

    trail.default_color = ratio*HEALTHY_COLOR + (1 - ratio)*DEATH_COLOR


