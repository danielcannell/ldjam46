extends Button


# outbound signals
signal button_pressed_with_label


func _ready():
    assert(connect("pressed", self, "_on_button_pressed") == 0)


func _on_button_pressed():
    emit_signal("button_pressed_with_label", text)
