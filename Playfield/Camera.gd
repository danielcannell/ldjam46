extends Camera2D


const MAX_ZOOM = 1
const MIN_ZOOM = 0.1
const DRAG_MARGIN = 0.2


func _init():
    drag_margin_left = DRAG_MARGIN
    drag_margin_right = DRAG_MARGIN
    drag_margin_top = DRAG_MARGIN
    drag_margin_bottom = DRAG_MARGIN
    drag_margin_h_enabled = true
    drag_margin_v_enabled = true


func _unhandled_input(event):
    if event is InputEventMouseButton and event.is_pressed():
        match event.button_index:
            BUTTON_WHEEL_UP: update_zoom(0.9)
            BUTTON_WHEEL_DOWN: update_zoom(1.1)


func update_zoom(ratio):
    var zoom = clamp(self.zoom.x * ratio, MIN_ZOOM, MAX_ZOOM)
    self.zoom = Vector2(zoom, zoom)
