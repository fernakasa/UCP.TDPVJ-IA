extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Escenario_Demo_pressed():
	get_tree().change_scene("res://escenes/game.tscn")


func _on_Escenario_Uno_pressed():
	get_tree().change_scene("res://escenes/game2.tscn")


func _on_Escenario_Dos_pressed():
	get_tree().change_scene("res://escenes/game3.tscn")


func _on_Escenario_Tres_pressed():
	get_tree().change_scene("res://escenes/game4.tscn")
