extends CharacterBody2D
#instancias 
var attack_player := "res://prefabs/attack_generico_player.tscn"
var carregando_a_cena: PackedScene 
#Atributos iniciais
var vidas = 3
var pontos = 0

@onready var ponto_de_tiro: Marker2D = $PontoDeTiro


func _ready(): #Posição inicial da nave
	global_position.x = 500
	global_position.y = 900
	carregando_a_cena = load(attack_player)
func _process(_delta): #Movimentação da nave
	if Input.is_action_pressed("ui_left"): #Movimentar para a esquerda
		global_position.x -= 4
	elif Input.is_action_pressed("ui_right"): #Movimentar para a direita
		global_position.x += 4
	if Input.is_action_pressed("ui_down"): #Movimentar para baixo
		global_position.y += 4
	if Input.is_action_pressed("ui_up"): #Movimentar para cima
		global_position.y -= 4
	if Input.is_action_just_pressed("atirar"):
		atirar()

func atirar() -> void:
	var tiro_atual := carregando_a_cena.instantiate()
	tiro_atual.global_position  = ponto_de_tiro.global_position
	get_parent().add_child(tiro_atual)
