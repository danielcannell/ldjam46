extends PopupDialog


func _unhandled_input(event):
    if event is InputEventKey and event.pressed:
        if event.scancode in [KEY_P, KEY_PAUSE, KEY_SPACE]:
            toggle_paused()


func toggle_paused():
        get_tree().paused = !get_tree().paused
        visible = get_tree().paused


func _on_Resume_pressed():
    toggle_paused()


func _on_Restart_pressed():
    toggle_paused()
    var err := get_tree().change_scene("res://Main.tscn"); assert(err == OK)
