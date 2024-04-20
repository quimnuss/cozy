extends ProgressBar

const BLINK_THRESHOLD : float = 0.5
var blink_rate : float = 1.0
@export var blink_curve : Curve

var elapsed = 0

var base_color : Color

const HIGH_COLOR : Color = Color('#fb50c2')

func _ready():
    base_color = self.modulate


func _process(delta):
    elapsed += delta
    if ratio < BLINK_THRESHOLD:
        blink_rate = max(ratio/BLINK_THRESHOLD,0.2)
        elapsed = fmod(elapsed,blink_rate)
        var white_ratio : float = blink_curve.sample(elapsed/blink_rate)
        self.modulate = HIGH_COLOR*white_ratio + (1-white_ratio)*self.base_color
    else:
        if self.modulate != base_color:
            self.modulate = base_color

