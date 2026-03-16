extends Node2D

const LEVEL_BTN = preload("res://lvl_btn.tscn")

@export_dir var dir_path
@onready var grid_container: GridContainer = $Control/GridContainer

func _ready() -> void:
	get_levels(dir_path)
	
	for i in range(grid_container.get_child_count()):
		global.levels.append(i+1)
		
		
	for level in grid_container.get_children():
		if str_to_var(level.name) in range (global.unlockedlevels+1):
			level.disabled = false
		else:
			level.disabled = true
			print(level.name)

func get_levels(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			create_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("failed to get levels")


func create_level_btn(lvl_path: String, lvl_name: String):
	var btn = LEVEL_BTN.instantiate()
	btn.text = lvl_name.trim_suffix('.tscn').replace('_', " ")
	btn.level_path = lvl_path
	btn.name = lvl_name.trim_suffix('.tscn').replace('_', " ").trim_prefix('Level')
	grid_container.add_child(btn)
