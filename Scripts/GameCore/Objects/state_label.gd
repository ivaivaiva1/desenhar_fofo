extends RichTextLabel

@onready var timer: Timer = %Timer
var font_color: Color = Color.BLACK
var outline_color: Color = Color.WHITE
@onready var WorldIsChangingEmmiter: LoadLevel = get_tree().get_first_node_in_group("WorldIsChangingEmmiter") as LoadLevel

func _ready() -> void:
	WorldIsChangingEmmiter.world_is_changing.connect(set_label_color)
	set_label_color()
	blink_text()


func set_label_color():
	var label_colors:= SkinPicker.label_color()
	font_color = label_colors["font"] as Color
	outline_color = label_colors["outline"] as Color 
	add_theme_color_override("default_color", font_color)
	add_theme_color_override("font_outline_color", outline_color)


func blink_text():
	timer.start()
	await timer.timeout
	while(true):
		if visible:
			visible = false
			timer.wait_time = 0.4
		else:
			visible = true
			timer.wait_time = 1
		timer.start()
		await timer.timeout
