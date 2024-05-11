extends Marker2D

var elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    elapsed += delta
    if elapsed > 1:
        elapsed = 0

