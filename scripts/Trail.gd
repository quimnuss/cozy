extends Node2D

@export var target : Node2D
@onready var trail = $Trail

var previous_point : Vector2

const THRESHOLD = 5

var elapsed = 0

var elapsed_death = 10

@export var HEALTHY_COLOR : Color = Color(0,150/255,0,1)
@export var DEATH_COLOR : Color = Color(75/255,40/255,0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    elapsed += delta
    var new_point : Vector2 = target.global_position
    if previous_point.distance_to(new_point) > THRESHOLD:
        trail.add_point(new_point)

    var ratio = min(elapsed/elapsed_death,1)

    trail.default_color = ratio*DEATH_COLOR + (1 - ratio)*HEALTHY_COLOR
