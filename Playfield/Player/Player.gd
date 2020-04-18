extends Position2D


enum States { IDLE, PATHING }

export(float) var speed = 200.0
export(float) var mass = 10.0
var _state = null

var _path = []
var _target_point_world = Vector2()
var _target_position = Vector2()

var _velocity = Vector2()


func _ready():
    _change_state(States.IDLE)


func _input(event):
    if (event.is_pressed() and event.button_index == BUTTON_LEFT):
        var global_mouse_pos = get_global_mouse_position()
        self.path_to(global_mouse_pos)


func _process(_delta):
    if _state != States.PATHING:
        return
    var _arrived_to_next_point = _move_to(_target_point_world)
    if _arrived_to_next_point:
        _path.remove(0)
        if len(_path) == 0:
            _change_state(States.IDLE)
            return
        _target_point_world = _path[0]



func _move_to(world_position):
    """Move the Player to a world position"""
    var ARRIVE_DISTANCE = 10.0

    var desired_velocity = (world_position - position).normalized() * speed
    var steering = desired_velocity - _velocity
    _velocity += steering / mass
    position += _velocity * get_process_delta_time()
    rotation = _velocity.angle()
    return position.distance_to(world_position) < ARRIVE_DISTANCE


func _change_state(new_state):
    if new_state == States.PATHING:
        # _path = get_parent().get_node("TileMap").get_astar_path(position, _target_position)
        _path = [position, _target_position]
        if not _path or len(_path) == 1:
            _change_state(States.IDLE)
            return
        # The index 0 is the starting cell
        # we don't want the character to move back to it in this example
        _target_point_world = _path[1]
    _state = new_state


# Public player api
func path_to(world_position):
    """path the Player to a world position"""
    _target_position = world_position
    _change_state(States.PATHING)


