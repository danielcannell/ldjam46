extends PopupDialog


func _on_restart_pressed():
    var err := get_tree().change_scene("res://Main.tscn"); assert(err == OK)
    get_tree().paused = false
