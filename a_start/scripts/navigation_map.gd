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

	
	CalculatePath(start_position, end_position)
	
	print('-------------DEBUG------------')
	print('Start: %s   ---   End: %s' % [start_position, end_position])
	print('------------------------------')
	
		
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
	## Search condition
	var searching = true
	## List of open_set
	var open_set = []
	## List of close_set
	var close_set = []
	## Firts
	var firts = [start, 0, 0, 0, start]
	close_set.append(firts)
	
	while(searching):
		calc_step(close_set[-1], end, open_set)
		next_step(close_set, open_set)
		if(close_set[-1][0] == end):
			searching = false
	print('salida correcta')

func next_step(close_set, open_set):
	var mayor = 999999
	var indice = 0
	for i in open_set:
		if i[2] < mayor:
			mayor = i[2]
			indice = i
	open_set.erase(indice)
	close_set.append(indice)

func calc_step(step, end, open_set):
	var adjcell = adjoining_cell(step[0])
	var F = 0 
	var G = 0 
	var H = 0
	for i in adjcell:
		H = manhattan_distance(i, end) * 10
		if int(i.x + i.y) % int(2) == int(step[0].x + step[0].y) % int(2):
			G = step[2] + 14
		else:
			G = step[2] + 10
		F = H + G
		## Row = [cellposition, F, G, H, Parent]
		open_set.append([i, F, G, H, step[0]])
	print(open_set)
