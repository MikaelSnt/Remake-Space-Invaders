extends Node2D
@export_group("Grade Clássica por Linhas")
@export var cenas_por_linha: Array[PackedScene] = []
@export var colunas:= 11
@export var espacamento: Vector2 = Vector2(75.0, 65.0)
@export var altura_inicial_y:= 200.0

@export_group("Movimento e Aceleração")
@export var velocidade_inicial:= 60.0
@export var velocidade_maxima:= 480.0
@export var descida:= 35.0
@export var margem_borda:= 55.0
var direcao:= 1 # 1 = direita, -1 = esquerda
var total_inimigos_inicial: = 0
var cronometro_tiro:= 0.0
var proximo_tiro:= 1.5
@export_group("Combate")
@export var cena_tiro_inimigo: PackedScene
@export var intervalo_tiro_min:= 1.0
@export var intervalo_tiro_max:= 2.4
@export var max_tiros_simultaneos:= 2

func _ready() -> void:
	criar_horda()
	proximo_tiro = randf_range(intervalo_tiro_min, intervalo_tiro_max)

func criar_horda() -> void:
	if cenas_por_linha.is_empty():
		return

	# Centraliza a grade horizontalmente de acordo com o tamanho da Camera2D
	var tela_camera: Rect2 = get_viewport().get_canvas_transform().affine_inverse() * get_viewport().get_visible_rect()
	var largura_grade := (colunas - 1) * espacamento.x
	var inicio_x := tela_camera.get_center().x - (largura_grade / 2.0)

	for linha in range(cenas_por_linha.size()):
		var cena_atual := cenas_por_linha[linha]
		if not cena_atual:
			continue
			
		for coluna in range(colunas):
			var inimigo := cena_atual.instantiate()
			inimigo.position = Vector2(
				inicio_x + (coluna * espacamento.x),
				altura_inicial_y + (linha * espacamento.y)
			)
			add_child(inimigo)

	total_inimigos_inicial = get_child_count()

func _physics_process(delta: float) -> void:
	var vivos := get_children()
	if vivos.is_empty():
		return

	# Lê as bordas reais da sua Camera2D
	var tela_camera: Rect2 = get_viewport().get_canvas_transform().affine_inverse() * get_viewport().get_visible_rect()
	var limite_esquerdo := tela_camera.position.x + margem_borda
	var limite_direito := tela_camera.end.x - margem_borda

	# Acelera conforme os inimigos são destruídos
	var proporcao_mortos := 1.0 - (float(vivos.size()) / float(total_inimigos_inicial))
	var velocidade_atual := lerpf(velocidade_inicial, velocidade_maxima, pow(proporcao_mortos, 1.5))
	position.x += direcao * velocidade_atual * delta
	
	# Verifica se algum inimigo vivo encostou na borda da câmera
	var bateu_na_borda := false
	for inimigo in vivos:
		if inimigo is Node2D:
			if direcao == 1 and inimigo.global_position.x >= limite_direito:
				bateu_na_borda = true
				break
			elif direcao == -1 and inimigo.global_position.x <= limite_esquerdo:
				bateu_na_borda = true
				break
	cronometro_tiro += delta
	if cronometro_tiro >= proximo_tiro:
		cronometro_tiro = 0.0
		proximo_tiro = randf_range(intervalo_tiro_min, intervalo_tiro_max)
		disparar_linha_de_frente()
	if bateu_na_borda:
		direcao *= -1
		position.y += descida
func disparar_linha_de_frente() -> void:
	if not cena_tiro_inimigo:
		return

	# Limita quantos tiros inimigos podem existir ao mesmo tempo na tela (estilo arcade)
	if get_tree().get_nodes_in_group("tiros_inimigos").size() >= max_tiros_simultaneos:
		return

	# Mapeia cada coluna (position.x) para o inimigo vivo mais baixo (maior position.y)
	var frente_por_coluna: Dictionary = {}
	for inimigo in get_children():
		if inimigo is Node2D:
			var chave_coluna := roundi(inimigo.position.x)
			if not frente_por_coluna.has(chave_coluna) or inimigo.position.y > frente_por_coluna[chave_coluna].position.y:
				frente_por_coluna[chave_coluna] = inimigo

	var atiradores := frente_por_coluna.values()
	if atiradores.is_empty():
		return

	var escolhido: Node2D = atiradores.pick_random()
	var tiro := cena_tiro_inimigo.instantiate()
	tiro.global_position = escolhido.global_position + Vector2(0.0, 32.0)
	get_parent().add_child(tiro)
	
func iniciar_nova_onda() -> void:
		position = Vector2.ZERO
		direcao = 1
		criar_horda()
