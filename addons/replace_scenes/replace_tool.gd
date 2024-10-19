@tool
extends EditorPlugin

var editorSelection: EditorSelection

func _enter_tree() -> void:
	editorSelection = get_editor_interface().get_selection()
	add_tool_menu_item("Replace all selected", func():
		replace()
		)

func _exit_tree() -> void:
	remove_tool_menu_item("Replace all selected")

func replace() -> void:
	var fileDialog: FileDialog = preload("res://addons/replace_scenes/filedialog.tscn").instantiate()
	get_editor_interface().popup_dialog(fileDialog)
	
	await fileDialog.file_selected
	var replacement: PackedScene = load(fileDialog.current_path)

	var selected: Array[Node] = editorSelection.get_selected_nodes() 
	if selected.is_empty():
		return
		
	for scene: Node in selected:
		var temp: Node3D = replacement.instantiate()
		scene.add_sibling(temp, true)
		temp.transform = scene.transform
		temp.owner = scene.owner
		
		scene.queue_free()
		
		##optionally copy all the metadata
		#for meta: StringName in scene.get_meta_list():
		#	temp.set_meta(meta, scene.get_meta(meta))
