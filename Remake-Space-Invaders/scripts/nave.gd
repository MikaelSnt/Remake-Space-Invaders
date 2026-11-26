extends CharacterBody2D
#instancias 
var attack_player := "res://prefabs/attack_generico_player.tscn"
var carregando_a_cena: PackedScene 
#Atributos iniciais
var posicao_inicial := Vector2(540, 900)
var velocidade := 250.0
var margem_tela := 0.0 # eu vou pegar o valor exato no ready 
#Referencias, é tipo um Ponteiro que Aponta para o que eu to referenciando 
@onready var ponto_de_tiro: Marker2D = $PontoDeTiro
@onready var sprite_nave: AnimatedSprite2D = $sprite_nave
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready(): #Posição inicial da nave
	process_mode = Node.PROCESS_MODE_ALWAYS
	var marcador := get_parent().get_node_or_null("Player_position") as Node2D
	if marcador:
		global_position = marcador.global_position
	posicao_inicial = global_position
	carregando_a_cena = load(attack_player)
	margem_tela = (sprite_nave.sprite_frames.get_frame_texture("idle", 0).get_width()) #pega o valor exato do tamanho do sprite 
func _physics_process(_delta: float) -> void: #Inputs vou colocar A e D tbm
	if get_tree().paused:
		return 
	var direcao_player := Input.get_axis("ui_left", "ui_right") 
	movimento_player(direcao_player)
	if Input.is_action_just_pressed("atirar"):
		atirar()

func movimento_player(direcao_player) -> void:#Movimentação da nave
	velocity.x = direcao_player * velocidade
	velocity.y = 0.0
	move_and_slide()
	
	var largura_tela := get_viewport_rect().size.x
	global_position.x = clampf(global_position.x, margem_tela, largura_tela - margem_tela)

func atirar() -> void:
	if get_tree().paused:
		return
	if get_tree().get_nodes_in_group("attack_player").size() > 0:
		return
	var tiro_atual := carregando_a_cena.instantiate()
	tiro_atual.add_to_group("attack_player")
	tiro_atual.add_to_group("tiros")
	tiro_atual.global_position  = ponto_de_tiro.global_position
	get_parent().add_child(tiro_atual)
	
func receber_dano_player(dano) -> void:
	if get_tree().paused:
		return
	get_tree().paused = true
	for tiros in get_tree().get_nodes_in_group("tiros"):
		tiros.queue_free()
	animation_player.play("explosao")
	await animation_player.animation_finished
	GameManager.perder_vida(dano)
	if GameManager.jogo_acabou:
		return
	animation_player.play("idle")
	global_position = posicao_inicial
	get_tree().paused = false
