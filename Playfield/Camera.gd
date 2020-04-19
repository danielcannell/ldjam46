extends Camera2D


var max_zoom := 1.0
var min_zoom := 0.1


func _ready():
    size_changed()
    var err := get_tree().get_root().connect("size_changed", self, "size_changed"); assert(err == 0)


func size_changed():
    var viewport_size := get_viewport_rect().size
    var camera_limit := Vector2(limit_right - limit_left, limit_bottom - limit_top)

    var zoom_limit = 0.9 * camera_limit / viewport_size
    max_zoom = min(0.75, min(zoom_limit.x, zoom_limit.y))

    update_zoom(1.0)


func _unhandled_input(event):
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            BUTTON_WHEEL_UP: update_zoom(0.9)
            BUTTON_WHEEL_DOWN: update_zoom(1.1)
    # TODO pinch-to-zoom on mobile?


func update_zoom(ratio):
    var zoom = clamp(self.zoom.x * ratio, min_zoom, max_zoom)
    self.zoom = Vector2(zoom, zoom)
