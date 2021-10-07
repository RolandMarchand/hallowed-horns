extends CanvasLayer


onready var label_node: RichTextLabel = get_node("BorderMargin/TextMargin/AnimatedText")

func damaged() -> void:
	get_node("BorderMargin/TextMargin/HBoxContainer/Label2").text = str(PlayerStats.health)
	get_node("BorderMargin/ColorRect").color = Color("#ff5555")
	get_node("BorderMargin/ColorRect").show()
	get_node("BorderMargin/Tween").interpolate_property(get_node("BorderMargin/ColorRect"),
	"color", Color("#ffff5555"), Color("#00ff5555"), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	get_node("BorderMargin/Tween").start()
