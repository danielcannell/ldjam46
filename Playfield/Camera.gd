extends Camera2D


var max_zoom := 1.0
var min_zoom := 0.1
var events := {}
var first_distance := 0.0
var first_zoom := 1.0
var zoom_thres := 10.0


func _ready():
    size_changed()
    var err := get_tree().get_root().connect("size_changed", self, "size_changed"); assert(err == 0)


func size_changed():
    var viewport_size := get_viewport_rect().size
    var camera_limit := Vector2(limit_right - limit_left, limit_bottom - limit_top)

    var zoom_limit = 0.9 * camera_limit / viewport_size
    max_zoom = min(0.75, min(zoom_limit.x, zoom_limit.y))

    update_zoom(1.0)


func dist() -> float:
    var first_event = null
    var result
    for event in events:
        if first_event != null:
            result = events[event].position.distance_to(first_event.position)
            break
        first_event = events[event]
    return result


func _unhandled_input(event: InputEvent):
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            BUTTON_WHEEL_UP: update_zoom(self.zoom.x * 0.9)
            BUTTON_WHEEL_DOWN: update_zoom(self.zoom.x * 1.1)

    elif event is InputEventScreenTouch and event.is_pressed():
        events[event.index] = event
        if events.size() > 1:
            first_distance = dist()
            first_zoom = self.zoom.x

    elif event is InputEventScreenTouch and not event.is_pressed():
        var _b := events.erase(event.index)

    elif event is InputEventScreenDrag:
        events[event.index] = event
        if events.size() > 1:
            var second_distance := dist()
            if abs(first_distance - second_distance) > zoom_thres:
                var ratio := first_distance / second_distance
                update_zoom(first_zoom * ratio)



func update_zoom(ratio: float):
    var zoom = clamp(ratio, min_zoom, max_zoom)
    self.zoom = Vector2(zoom, zoom)
