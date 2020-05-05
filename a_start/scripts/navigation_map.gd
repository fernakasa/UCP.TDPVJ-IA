extends TileMap

# All tiles that can be used for pathfinding
onready var traversable_tiles = get_used_cells()

var PathNode = load('res://scripts/path_node.gd')

## Public functions

# Returns a path from start to end
# These are real positions, not cell coordinates
func find_path(start, end):
	# You should implement A* algorithm
	var start_position = world_to_map(start)
	var end_position = world_to_map(end)
	print('-------------DEBUG------------')
	print('Start: %s  -  End: %s' % [start_position, end_position])
		## Search condition
	var searching = true
	## List of set
	var open_set = []
	var close_set = []
	## Firts row
	var firts = [start_position, 0, 0, 0, start_position]
	close_set.append(firts)
	while(searching):
		calc_step(close_set[-1], end_position, open_set, close_set)
		next_step(close_set, open_set)
		if(close_set[-1][0] == end_position):
			searching = false
	print('----------CLOSE SET-----------')
	for i in close_set:
		print(i)
	## ... ARMO EL PATH
	var close_set_reverse = close_set
	close_set_reverse.invert()
	var stepsorder = end_position
	var pathroute = []
	var finalroute = []
	for i in close_set_reverse:
		if stepsorder != start_position:
			if i[0] == stepsorder:
				pathroute.append(i[0])
				stepsorder = i[4]
	pathroute.invert()
	print('-------------PATH-------------')
	for i in pathroute:
		print(i, ' --- ', map_to_world(i))
		finalroute.append(map_to_world(i)+Vector2(32,32))
	return finalroute


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


func next_step(close_set, open_set):
	var mayor = 99999999
	var indice
	for i in open_set:
		if i[1] != mayor:
			if i[1] < mayor:
				mayor = i[1]
				indice = i
			else:
				if i[3] < indice[3] and i[1] == mayor:
					mayor = i[1]
					indice = i
	open_set.erase(indice)
	close_set.append(indice)


func calc_step(step, end, open_set, close_set):
	var adjcell = adjoining_cell(step[0])
	var F = 0 
	var G = 0 
	var H = 0
	var row
	var in_open
	var in_close
	for i in adjcell:
		H = manhattan_distance(i, end) * 10
		if int(i.x + i.y) % int(2) == int(step[0].x + step[0].y) % int(2):
			G = step[2] + 14
		else:
			G = step[2] + 10
		F = H + G
		## Row = [cellposition, F, G, H, Parent]
		row = [i, F, G, H, step[0]]
		for j in open_set:
			if(row[0] == j[0]):
				in_open = true
				break
			else:
				in_open = false
		for j in close_set:
			if(row[0] == j[0]):
				in_close = true
				break
			else:
				in_close = false
		if(in_open or in_close):
			if(in_open and row[2] < open_set[open_set.find(row)][2]):
				open_set.erase(open_set[open_set.find(row)])
				open_set.append(row)
		else:
			open_set.append(row)
