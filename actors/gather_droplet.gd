extends Node2D

@export var speed_curve : Curve
@export var trajectory_curve : Curve2D
@onready var target = $"../../Target"
var third_quarters_point : Vector2
@onready var cross_2 = $"../Cross2"

var elapsed = 0.0

const DURATION = 2.0

func _ready():
    trajectory_curve.add_point(get_parent().global_position)
    trajectory_curve.add_point(target.global_position)
    self.global_position = get_parent().global_position
    third_quarters_point = get_parent().global_position + 0.10*(target.global_position - get_parent().global_position) + Vector2(0,-100)
    var m = Marker2D.new()
    m.global_position = third_quarters_point
    self.add_child(m)
    cross_2.global_position = third_quarters_point

#func _process(delta):
    #elapsed += delta
    #self.global_position = trajectory_curve.sample(0,elapsed/DURATION)


var t = 0.0
func _physics_process(delta)->void:

    if t > 1:
        t=0
    t+=delta/DURATION
    self.global_position = _quad_beizer(get_parent().global_position, third_quarters_point, target.global_position, t)


func _quad_beizer(startVector:Vector2, heightVector:Vector2, endVector:Vector2, t:float):
    var q0 = startVector.lerp(heightVector,t)
    var q1 = heightVector.lerp(endVector,t)
    var r = q0.lerp(q1,t)
    return r
