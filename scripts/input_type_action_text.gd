extends RichTextLabel

var original_text : String


func _ready():
    original_text = self.text
    update_input_type(InputDetector.InputType.KEYBOARD)

func update_input_type(input_type : InputDetector.InputType):
    var input_aware_character = char(64)
    match input_type:
        InputDetector.InputType.KEYBOARD:
            input_aware_character = '\u243A'
        InputDetector.InputType.JOY:
            input_aware_character = '⇓'
        InputDetector.InputType.MOUSE:
            input_aware_character = '➊'
        _:
            input_aware_character = 'Action'
    self.text = original_text.format({'main_action':input_aware_character})

