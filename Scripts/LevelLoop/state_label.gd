extends RichTextLabel

@onready var timer: Timer = %Timer

func _ready() -> void:
	timer.start()
	await timer.timeout
	while(true):
		if visible:
			visible = false
		else:
			visible = true
		timer.start()
		await timer.timeout
