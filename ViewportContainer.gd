extends ViewportContainer

func _input(event):
    # See: https://github.com/godotengine/godot/issues/17326
    # and: https://github.com/godotengine/godot/issues/31802
    $Viewport.unhandled_input(event)
