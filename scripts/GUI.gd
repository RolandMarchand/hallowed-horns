# This file is part of Hallowed Horns.
#
# Hallowed Horns is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Hallowed Horns is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Hallowed Horns.  If not, see <https://www.gnu.org/licenses/>.
extends CanvasLayer


onready var _animated_text: RichTextLabel = get_node("BorderMargin/TextMargin/AnimatedText")

func display_message(message: String) -> void:
	get_tree().paused = true
	$BorderMargin.show()
	$ColorRect.color = Color("#ff000000")
	
	_animated_text.new_text(message)
	
	yield(_animated_text, "text_displayed")
	$ColorRect.color = Color("#00000000")
	$BorderMargin.hide()
	get_tree().paused = false

# Placeholder, please changex
func damaged() -> void:
	get_node("BorderMargin/TextMargin/HBoxContainer/Label2").text = str(PlayerStats.health)
	get_node("ColorRect").color = Color("#ff5555")
	get_node("ColorRect").show()
	get_node("BorderMargin/Tween").interpolate_property(get_node("ColorRect"),
	"color", Color("#ffff5555"), Color("#00ff5555"), 2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	get_node("BorderMargin/Tween").start()
	yield(get_node("BorderMargin/Tween"), "tween_all_completed")
