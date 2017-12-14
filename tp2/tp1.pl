/*Arythmétique cryptée*/

arythmetique_crypt(D,O,N,A,L,G,E,R,B,T) :-
	All_variables = [D,O,N,A,L,G,E,R,B,T],
	fd_domain(All_variables, 0,9),
	D#\=0,
	G#\=0,
	R#\=0,
	fd_all_different(All_variables),
	Operande1 = D*100000 + O*10000+ N*1000+A*100+L*10+D/*[D,O,N,A,L,D]*/,
	Operande2 = G*100000 + E*10000+ R*1000+A*100+L*10+D/*[G,E,R,A,L,D]*/,
	Operande3 = R*100000 + O*10000+ B*1000+E*100+R*10+T/*[R,O,B,E,R,T]*/,
	Operande1 + Operande2 #= Operande3,
	fd_labeling(All_variables).


	
	
/*Nombre de HARDY-RAMANUJAN*/

hardy_ramanujan(N,A,B,C,D) :-
	All_variables = [N,A,B,C,D],
	fd_domain(All_variables,0,1000000),
	A#\=C,
	A#\=D,
	B#\=C,
	B#\=D,
	N#= A**3 +B**3,
	N#= C**3 +D**3,
	fd_minimize(fd_labeling(All_variables ), N).

/*Monnaie*/
/*1*/

monnaie_Q1(Billet, Cout_achat, A,B,C,D,E,F,G,H) :-
	Pieces = [A,B,C,D,E,F,G,H],
	fd_domain(Pieces,0,3),
	Monnaie = Billet - Cout_achat,
	Monnaie_p = A + B*2 + C*5 +D*10 +E*20 +F*50 +G*100 +H*200,
	Monnaie_p #= Monnaie,
	fd_labeling(Pieces).

/*2*/
/*sum(L, S) :-*/
	
	
