#	 Controls what is shown for the score on the HUD.
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


extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_node("../Player")
	if not player.is_connected("score_changed", self, "_on_score_changed"):
		player.connect("score_changed", self, "_on_score_changed")

	self.text = "Score: " + str(Global.score)


func _on_score_changed():
	self.text = "Score: " + str(Global.score)
