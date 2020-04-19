extends Button


# outbound signals
signal button_pressed_with_label


func _ready():
    var err := connect("pressed", self, "_on_button_pressed"); assert(err == 0)


func _on_button_pressed():
    emit_signal("button_pressed_with_label", text)
