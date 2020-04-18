extends Camera2D


const MAX_ZOOM = 1
const MIN_ZOOM = 0.1


func _input(event):
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            BUTTON_WHEEL_UP: update_zoom(0.9)
            BUTTON_WHEEL_DOWN: update_zoom(1.1)


func update_zoom(ratio):
    var zoom = clamp(self.zoom.x * ratio, MIN_ZOOM, MAX_ZOOM)
    print(zoom)
    self.zoom = Vector2(zoom, zoom)
