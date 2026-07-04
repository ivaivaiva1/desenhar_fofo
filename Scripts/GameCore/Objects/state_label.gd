extends RichTextLabel

@onready var timer: Timer = %Timer

func _ready() -> void:
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
