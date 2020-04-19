extends PopupDialog


func _on_restart_pressed():
    get_tree().change_scene("res://Main.tscn")
    get_tree().paused = false
