extends Area2D

class_name Player

enum States { IDLE, PATHING, BUILDING, ATTACKING }
enum Actions { NONE, GOTO_LOCATION, BUILD, ATTACK }

var ARRIVE_DISTANCE = 10.0


export(float) var speed = 200.0
export(float) var mass = 10.0
var _state = null

var _path = []
var _target_point_world = Vector2()
var _target_position = Vector2()

var _velocity = Vector2()

var _current_action = null

var _inventory = { }
var Food = preload("res://Playfield/Food/Food.gd")


signal state_changed(state)

signal building(target)

signal inventory_updated(inventory)


func _ready():
    _change_action({"type": Actions.NONE})
    assert(connect("area_entered", self, "_on_area_entered") == 0)


func _on_area_entered(area: Area2D):
    if area is Food:
        handle_food_pickup(area)


func feed_one():
    if 'food' in _inventory:
        if _inventory['food'] > 0:
            _inventory['food'] -= 1
            emit_signal("inventory_updated", _inventory)
            return true
    return false


func handle_food_pickup(area: Area2D):
    Globals.tutorial_event(Globals.TutorialEvents.FOOD_PICKED_UP)
    area.queue_free()
    if 'food' in _inventory:
        _inventory['food'] += 1
    else:
        _inventory['food'] = 1

    emit_signal("inventory_updated", _inventory)


func get_current_action():
    return _current_action


func _unhandled_input(event):
    if event.is_action_pressed("click"):
        var global_mouse_pos = get_global_mouse_position()
        self.move(global_mouse_pos)

    elif event.is_action_pressed("build"):
        var global_mouse_pos = get_global_mouse_position()
        self.build(global_mouse_pos, null)


func _pathing_complete():
    _velocity = Vector2.ZERO
    match _current_action["type"]:
        Actions.GOTO_LOCATION:
            _change_state(States.IDLE)
            _change_action({"type": Actions.NONE})
        Actions.BUILD:
            _change_state(States.BUILDING)
            emit_signal("building", _current_action["target"])
        Actions.ATTACK:
            _change_state(States.ATTACKING)


func _process(_delta):
    match _state:
        States.PATHING:
            var _arrived_to_next_point = _move_to(_target_point_world)
            if _arrived_to_next_point:
                _path.remove(0)
                if len(_path) == 0:
                    self._pathing_complete()
                else:
                    _target_point_world = _path[0]

        States.BUILDING:
            # some building animation?
            pass

func _move_to(world_position):
    """Move the Player to a world position"""
    var desired_velocity = (world_position - position).normalized() * speed
    var steering = desired_velocity - _velocity
    _velocity += steering / mass
    position += _velocity * get_process_delta_time()
    if _velocity.x < 0:
        $AnimatedSprite.set_flip_h(true)
    else:
        $AnimatedSprite.set_flip_h(false)
    return position.distance_to(world_position) < ARRIVE_DISTANCE


func _change_state(new_state):

    # any exit actions
    match _state:
        States.PATHING:
            $AnimatedSprite.stop()
        States.BUILDING:
            $AnimatedSprite.stop()

    emit_signal("state_changed", new_state)

    # entry actions
    match new_state:
        States.PATHING:
            $AnimatedSprite.play("run")
            _path = [position, _target_position]
            _target_point_world = _path[1]

        States.BUILDING:
            $AnimatedSprite.play("build")

    _state = new_state


func _change_action(new_action):
    _current_action = new_action
    var type = new_action["type"]
    match type:
        Actions.NONE:
            _change_state(States.IDLE)

        Actions.GOTO_LOCATION:
            Globals.tutorial_event(Globals.TutorialEvents.WALK)
            _target_position = new_action["position"]
            _change_state(States.PATHING)

        Actions.BUILD:
            _target_position = new_action["position"]
            _change_state(States.PATHING)



# Public player api
func move(world_position):
    """path the Player to a world position"""
    self._change_action({"type": Actions.GOTO_LOCATION, "position": world_position})


func attack(target):
    self._change_action({"type": Actions.ATTACK, "target": target})


func build(world_position, target):
    """Goto a target location and emit a building signal with the given target when it arrives"""
    self._change_action({"type": Actions.BUILD, "position": world_position, "target": target})
