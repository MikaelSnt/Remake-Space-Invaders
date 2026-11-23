extends CharacterBody2D

#Atributos iniciais
var vidas = 3
var pontos = 0

func _ready(): #Posição inicial da nave
	global_position.x = 500
	global_position.y = 300
	
func _process(delta): #Movimentação da nave
	if Input.is_action_pressed("ui_left"): #Movimentar para a esquerda
		global_position.x -= 4
	elif Input.is_action_pressed("ui_right"): #Movimentar para a direita
		global_position.x += 4
	if Input.is_action_pressed("ui_down"): #Movimentar para baixo
		global_position.y += 4
	if Input.is_action_pressed("ui_up"): #Movimentar para cima
		global_position.y -= 4
