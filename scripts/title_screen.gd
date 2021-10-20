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
extends Control

var quit: bool = false

func _ready():
	$Menu/Options/VSync.pressed = OS.vsync_enabled
	$Menu/Options/Fullscreen.pressed = OS.window_fullscreen

func _on_LoadGame_pressed():
	pass


func _on_NewGame_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/main.tscn")


func _on_Options_pressed():
	$Background/Title.hide()
	$Menu/Main.hide()
	$Menu/Options.show()

func _on_Back_pressed():
	$Background/Title.show()
	$Menu/Main.show()
	$Menu/Options.hide()

func _on_About_pressed():
	$About.show()
	$About/AboutAnimation.play("Text Scroll", -1, 1)

# TODO, ask for confirmation
func _on_Quit_pressed():
	if quit:
		get_tree().quit()
	else:
		$Menu/Main/Quit.text = "Truly Quit ?"
		quit = true


func _on_RichTextLabel_meta_clicked(meta):
# warning-ignore:return_value_discarded
	OS.shell_open(meta)

func _on_AboutAnimation_animation_finished(_anim_name):
	$About.hide()

func _unhandled_key_input(_event):
	$About.hide()
	$About/RichTextLabel.rect_position.y = 192
	$About/AboutAnimation.stop(true)

func _on_CheckButton_toggled(button_pressed):
	OS.vsync_enabled = button_pressed

func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
