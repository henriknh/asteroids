extends CanvasLayer

export(NodePath) var player_node_path: NodePath
onready var player: Ship = get_node_or_null(player_node_path)

func _ready():
	Globals.ui_static = self
	if not player_node_path:
		breakpoint
		
	
