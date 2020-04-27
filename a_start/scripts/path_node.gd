extends Node

var parent = null
var position = null
var g = 0
var h = 0
var f = 0

func _init(parent_node, pos):
	parent = parent_node
	position = pos

func is_equal(a_path_node):
	return position.x == a_path_node.position.x and position.y == a_path_node.position.y

