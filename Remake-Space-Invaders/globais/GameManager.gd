extends Node
#Vai ligar as cenas e pontuaçoes
var pontuacao := 0 
var vidas := 3 
var jogo_acabou := false

func resetar_jogo() -> void:
	pontuacao = 0
	vidas = 3
	jogo_acabou = false
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://levels/level_um.tscn")
func adicionar_pontos(valor: int) -> void: 
	if jogo_acabou:
		return
	pontuacao += valor
func perder_vida(dano: int = 1) -> void:
	if jogo_acabou:
		return
	vidas = maxi(0, vidas - dano)
	if vidas <= 0:
		game_over()
func game_over() -> void:
	if jogo_acabou:
		return
	jogo_acabou = true
	get_tree().call_deferred("change_scene_to_file", "res://menus/game_over.tscn")
