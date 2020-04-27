extends TileMap


# All tiles that can be used for pathfinding
onready var traversable_tiles = get_used_cells()

var PathNode = load('res://scripts/path_node.gd')


## Public functions

# Returns a path from start to end
# These are real positions, not cell coordinates
func find_path(start, end):
	# You should implement A* algorithm
	var start_position = world_to_map(end)
	var end_position = world_to_map(start)
	
	var tablero = traversable_tiles
	print(start_position)
	print(end_position)
	
	CalculatePath(start_position, end_position)
	
	
	
	print('----------------------------')
	print()
	print('----------------------------')
	print(tablero)
	
		
func manhattan_distance(point_1, point_2):
	return abs(point_1.x - point_2.x) + abs(point_1.y - point_2.y)

func adjoining_cell(start):
	var adjoint_results = []
	for i in [start.x-1, start.x, start.x+1]:
		for j in [start.y-1, start.y, start.y+1]:
			var vec = Vector2(i,j)
			if vec in traversable_tiles and vec != start:
				adjoint_results.append(vec)
	return adjoint_results

func CalculatePath(start, end):
	var open_set = {'cell': start, 'F': 0, 'G': 0, 'H': 0, 'Parent': start}
	var close_set = {'cell': start, 'F': 0, 'G': 0, 'H': 0, 'Parent': start}
	
	adjoining_cell(start)
	
	
	var prueba01 = manhattan_distance(start, end) * 10
	print(prueba01)
	
	
	
