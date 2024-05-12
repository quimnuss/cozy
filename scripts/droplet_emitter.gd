extends Node2D

@onready var target = $"../Target"
@onready var emit_droplet = $EmitDroplet

@onready var midpoint : Node2D = $Midpoint
@onready var targetmarker : Node2D = $"../Target"


func _ready():
    emit_droplet.timeout.connect(spawn_droplet)
    emit_droplet.start()

func spawn_droplet():
    var target_position : Vector2 = (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * Vector2(100,100)
    target.global_position = target_position
    for i in range(4):
        var droplet : GatherDroplet = GatherDroplet.Instantiate(self.global_position, target_position)
        droplet.modulate = Color(0.369, 0.808, 0.973)
        midpoint.global_position = droplet.third_quarters_point
        self.add_child(droplet)
