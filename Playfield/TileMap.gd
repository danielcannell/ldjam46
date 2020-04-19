tool
extends TileMap

# The Tilemap node doesn't have clear bounds so we're defining the map's limits here.
export var map_size := Vector2.ONE * 16

# You can only create an AStar2D node from code, not from the Scene tab.
onready var astar_node := AStar2D.new()
onready var _half_cell_size = cell_size / 2


# Return true if a tile is path
func is_tile_path(x: int, y: int) -> bool:
    var cell := get_cell(x, y)
    return cell == 1

# Return true if a tile can have something built on it
func is_tile_placeable(x: int, y: int) -> bool:
    return not is_tile_path(x, y)

# Return a world position of a valid spawn point for a 1x1 item
func random_spawn_point() -> Vector2:
    while true:
        var trial = Vector2(
            rand_range(0, map_size[0]),
            rand_range(0, map_size[1])
        )
        if is_tile_placeable(trial[0], trial[1]):
            return map_to_world(trial)

    # unreachable
    return Vector2(0, 0)


func _ready() -> void:
    # Only run _process in the editor
    set_process(Engine.editor_hint)

    var walkable_cells_list = astar_add_walkable_cells()
    astar_connect_walkable_cells(walkable_cells_list)


func _draw() -> void:
    if Engine.editor_hint:
        # Draw map extents
        var bottom := map_size * cell_size
        var points: PoolVector2Array = [
            Vector2(0, 0),
            Vector2(bottom.x, 0),
            bottom,
            Vector2(0, bottom.y),
            Vector2(0, 0)
        ]
        for idx in range(4):
            var p1 := points[idx]
            var p2 := points[idx+1]
            draw_line(p1, p2, Color.red, 2.0, true)


func _process(_delta: float) -> void:
    if Engine.editor_hint:
        update()


# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles.
func astar_add_walkable_cells():
    var points_array = []
    for y in range(map_size.y):
        for x in range(map_size.x):
            var point = Vector2(x, y)
            if not is_tile_path(x, y):
                continue

            points_array.append(point)
            # The AStar2D class references points with indices.
            # Using a function to calculate the index from a point's coordinates
            # ensures we always get the same index with the same input point.
            var point_index = calculate_point_index(point)
            astar_node.add_point(point_index, point)
    return points_array


# Once you added all points to the AStar2D node, you've got to connect them.
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like.
# It's a little harder to code at first, but works for 2d, 3d,
# orthogonal grids, hex grids, tower defense games...
func astar_connect_walkable_cells(points_array):
    for point in points_array:
        var point_index = calculate_point_index(point)
        # For every cell in the map, we check the one to the top, right.
        # left and bottom of it. If it's in the map and not an obstalce.
        # We connect the current point with it.
        var points_relative = PoolVector2Array([
            point + Vector2.RIGHT,
            point + Vector2.LEFT,
            point + Vector2.DOWN,
            point + Vector2.UP,
        ])
        for point_relative in points_relative:
            if is_outside_map_bounds(point_relative):
                continue
            var point_relative_index = calculate_point_index(point_relative)
            if not astar_node.has_point(point_relative_index):
                continue
            # Note the 3rd argument. It tells the astar_node that we want the
            # connection to be bilateral: from point A to B and B to A.
            # If you set this value to false, it becomes a one-way path.
            # As we loop through all points we can set it to false.
            astar_node.connect_points(point_index, point_relative_index, false)


# This is a variation of the method above.
# It connects cells horizontally, vertically AND diagonally.
func astar_connect_walkable_cells_diagonal(points_array):
    for point in points_array:
        var point_index = calculate_point_index(point)
        for local_y in range(3):
            for local_x in range(3):
                var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
                if point_relative == point or is_outside_map_bounds(point_relative):
                    continue
                var point_relative_index = calculate_point_index(point_relative)
                if not astar_node.has_point(point_relative_index):
                    continue
                astar_node.connect_points(point_index, point_relative_index, true)


func calculate_point_index(point):
    return point.x + map_size.x * point.y


func is_outside_map_bounds(point):
    return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func get_closest_point_on_path(point: Vector2) -> Vector2:
    var mpos := world_to_map(point)
    var cmpos := astar_node.get_closest_position_in_segment(mpos)
    return map_to_world(cmpos) + _half_cell_size


func get_astar_path(world_start, world_end) -> PoolVector2Array:
    var path_start_position := world_to_map(world_start)
    var path_end_position := world_to_map(world_end)

    if is_outside_map_bounds(path_start_position) or is_outside_map_bounds(path_end_position):
        return PoolVector2Array()

    var start_point_index = calculate_point_index(path_start_position)
    var end_point_index = calculate_point_index(path_end_position)

    if not astar_node.has_point(start_point_index) or not astar_node.has_point(end_point_index):
        return PoolVector2Array()

    # This method gives us an array of points. Note you need the start and
    # end points' indices as input.
    var point_path := astar_node.get_point_path(start_point_index, end_point_index)

    var path_world = PoolVector2Array()
    for point in point_path:
        var point_world = map_to_world(point) + _half_cell_size
        path_world.append(point_world)
    return path_world
