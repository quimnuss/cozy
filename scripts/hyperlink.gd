extends RichTextLabel


func _ready():
    self.meta_clicked.connect(open_hyperlink)

func open_hyperlink(meta):
    OS.shell_open(meta)

