import sys
from monosat import *

def print_color_map():
	from colorama import Fore, Back, Style
	for i in range (grid_size):
		print ( "\ni:%2d | " % i, end="" )
		for j in range (grid_size):
			node = nodes[i,j]
			# background color
			color_idx= color[node].value()
			bcolor= Back.RESET
			if color_idx== 0:
				bcolor= Back.RED
			elif color_idx== 1:
				bcolor= Back.GREEN
			elif color_idx== 2:
				bcolor= Back.BLUE
			else: # color_idx== 3
				bcolor= Back.YELLOW
			print( Fore.BLACK + bcolor+ " " , end="" )
			print ( Style.RESET_ALL, end="" )


# initialisation de la taille de la grille (grid_size) et de la taille minimale du chemin (min_path_length) 
grid_size = int(sys.argv[1])
min_path_length = int(sys.argv[2])

# définition des 4 couleurs RED, GREEN, BLUE, YELLOW
RED = 0
GREEN = 1
BLUE= 2
YELLOW = 3

#Représentation du labirynthe sous forme de graphe
graph = Graph()

#dictionnaire qui associe les coordonnées (i,j) à des noeuds
nodes = dict()

#dictionnaire qui associe des paires de noeuds à des arcs
edges = dict()

#dictionnaire qui associe à chaque noeud une couleur (bitvector de taille 2)
color = dict()

#creation des noeuds
nodes = {(i,j): graph.addNode() for i in range(0, grid_size)for j in range(0,grid_size)}

#associer les couleurs à des noeuds
color = {(i,j) : BitVector(2) for i in range(0, grid_size)for j in range(0,grid_size)}

#Création des edges
for i in range(0, grid_size) :
	for j in range(0,grid_size) :

		if ((i!=0 and j!=0) and (i!=grid_size-1 and j!=grid_size-1)) :
			edges[(i,j), (i-1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i-1,j)], 1)
			edges[(i,j), (i+1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i+1,j)], 1)
			edges[(i,j), (i,j-1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j-1)], 1)
			edges[(i,j), (i,j+1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j+1)], 1)

		#cas limite
		# cases aux quatres extrémités de la table
		if i== 0 and j==0 :
			edges[(i,j), (i+1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i+1,j)], 1)
			edges[(i,j), (i,j+1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j+1)], 1)
		
		if i==grid_size-1 and j==0 :
			edges[(i,j), (i-1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i-1,j)], 1)
			edges[(i,j), (i,j+1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j+1)], 1)


		if i== grid_size-1 and j==grid_size-1 :
			edges[(i,j), (i-1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i-1,j)], 1)
			edges[(i,j), (i,j-1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j-1)], 1)


		if i==0 and j== grid_size-1:
			edges[(i,j), (i+1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i+1,j)], 1)
			edges[(i,j), (i,j-1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j-1)], 1)

		# cases uax bords de la table mais pas aux quatres extrémités
		if i==0 and j!=0 and j!= grid_size-1 :
			edges[(i,j), (i+1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i+1,j)], 1)
			edges[(i,j), (i,j-1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j-1)], 1)
			edges[(i,j), (i,j+1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j+1)], 1)

		if i !=0 and i!=grid_size-1 and j==0 :
			edges[(i,j), (i-1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i-1,j)], 1)
			edges[(i,j), (i+1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i+1,j)], 1)
			edges[(i,j), (i,j+1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j+1)], 1)

		if i==grid_size-1 and j!=0 and j!=grid_size-1:
			edges[(i,j), (i-1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i-1,j)], 1)
			edges[(i,j), (i,j-1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j-1)], 1)
			edges[(i,j), (i,j+1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j+1)], 1)

		if i!=0 and i!= grid_size-1 and j==grid_size-1:
			edges[(i,j), (i-1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i-1,j)], 1)
			edges[(i,j), (i+1,j)] = graph.addEdge(nodes[(i,j)], nodes[(i+1,j)], 1)
			edges[(i,j), (i,j-1)] = graph.addEdge(nodes[(i,j)], nodes[(i,j-1)], 1)






#contraintes
#deux noeuds voisins n'ont pas la même couleur


#contrainte d'ateignabilité entre le noeud de départ et le noeud d'arrivée
noeud_depart = nodes[(0,0)]
noeud_arrivee = nodes[(grid_size-1, grid_size-1)]
Assert(graph.reaches(noeud_depart, noeud_arrivee))
Assert(Not(graph.distance_leq(noeud_depart,  noeud_arrivee, min_path_length)))


#résolution du problème
result = Solve()
if result:
	#print_color_map()
    print("SAT")
else:
    print("UNSAT")

