#	 Controls what is shown for the lifebar on the HUD.
#    Copyright (C) 2022  Mark Gonzalez
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see https://www.gnu.org/licenses/.


extends Sprite


func _ready():
	var player:	KinematicBody2D = get_node("../Player")
	if not player.is_connected("lives_changed", self, "_on_lives_changed"):
		player.connect("lives_changed", self, "_on_lives_changed")

	self.frame = Global.lives


func _on_lives_changed():
	self.frame = Global.lives
