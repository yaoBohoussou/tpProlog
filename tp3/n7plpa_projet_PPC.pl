/*PROJET PPC 
  ENSEEIHT INFO 3A
  BOHOUSSOU Yao Yann Vianney
*/

:-include(libtp2).

/*Modèle basique*/

non_chevauchement(Xs1, Ys1, T1, Xs2, Ys2, T2) :-

	(Xs2 #>= Xs1+T1) #\/ (Xs2+T2 #=< Xs1)  #\/ (Ys2 #>= Ys1+T1) #\/ (Ys2+T2 #=< Ys1).

non_chevauchement_L1(_,_,_,[],[],_) :-!.

non_chevauchement_L1(Xs1, Ys1, T1, [Xs_head|Xs_tail], [Ys_head|Ys_tail], [T_Head| T_Tail] ) :-
	non_chevauchement(Xs1, Ys1, T1, Xs_head, Ys_head, T_Head),
	non_chevauchement_L1(Xs1, Ys1, T1, Xs_tail, Ys_tail, T_Tail). 


non_chevauchement_L([],[],_) :- !.

non_chevauchement_L([Xs_head|Xs_tail], [Ys_head|Ys_tail], [T_Head| T_Tail]) :-
	non_chevauchement_L1(Xs_head, Ys_head, T_Head, Xs_tail, Ys_tail, T_Tail),
	non_chevauchement_L(Xs_tail, Ys_tail,  T_Tail).
	
	
inclus_dans_grand_carre(_, [], [], []) :- !.

inclus_dans_grand_carre(GrandCarre, [T_Head| T_Tail], [Xs_head|Xs_tail], [Ys_head|Ys_tail]) :-
	Xs_head+T_Head #=< GrandCarre,
	Ys_head+T_Head #=< GrandCarre,
	inclus_dans_grand_carre(GrandCarre, T_Tail, Xs_tail, Ys_tail).


solveBasique(Num, Xs, Ys) :-
	data(Num, GrandCarre, PetitsCarres),
	length(PetitsCarres, Size),
	length(Xs, Size),
	length(Ys, Size),
	fd_domain(Xs, 0,GrandCarre),
	fd_domain(Ys, 0,GrandCarre),
	non_chevauchement_L(Xs,Ys,PetitsCarres),
	inclus_dans_grand_carre(GrandCarre, PetitsCarres, Xs, Ys),
	fd_labeling(Xs),
	fd_labeling(Ys),
	printsol('modeleBasique.txt', Xs, Ys, PetitsCarres).

solveBasiquelabeling(Num, Xs, Ys,Goal,NbSol,B) :-
	data(Num, GrandCarre, PetitsCarres),
	length(PetitsCarres, Size),
	length(Xs, Size),
	length(Ys, Size),
	fd_domain(Xs, 0,GrandCarre),
	fd_domain(Ys, 0,GrandCarre),
	non_chevauchement_L(Xs,Ys,PetitsCarres),
	inclus_dans_grand_carre(GrandCarre, PetitsCarres, Xs, Ys),
	labeling(Xs, Ys, Goal, minmin, B, NbSol),
	printsol('modeleBasiquelabeling.txt', Xs, Ys, PetitsCarres).



solveBasiqueBack(Num, Xs, Ys, B) :-
	data(Num, GrandCarre, PetitsCarres),
	length(PetitsCarres, Size),
	length(Xs, Size),
	length(Ys, Size),
	fd_domain(Xs, 0,GrandCarre),
	fd_domain(Ys, 0,GrandCarre),
	non_chevauchement_L(Xs,Ys,PetitsCarres),
	inclus_dans_grand_carre(GrandCarre, PetitsCarres, Xs, Ys),
	fd_labeling(Xs, [backtracks(B)]),
	fd_labeling(Ys, [backtracks(B)]),
	printsol('modeleBasiqueBacktrack.txt', Xs, Ys, PetitsCarres).
	

/*************************Contraintes redontantes**********************************/

carre_sur_verticale(Vert ,Xs, T, R) :-
	Xs_plus #= Xs + T,	
	((Xs #=< Vert) #/\ (Xs_plus #> Vert)) #<=> R.

/*Cette fonction retourne un tableau carr de taille le nombre de carrés tq 
		carr(i) = 1 si la verticale vert passe par le carré i et 0 sionon*/

carres_sur_verticale(Vert, [Xs], [Ts],Carr ) :-
	carre_sur_verticale(Vert ,Xs, Ts, R),
	Carr = [R].
carres_sur_verticale(Vert ,[Xs_Head|Xs_tail], [T_Head| T_Tail], Carr) :-
	carre_sur_verticale(Vert ,Xs_Head, T_Head, R),
	carres_sur_verticale(Vert , Xs_tail, T_Tail, Carrp),
	append([R],Carrp,Carr).

/*[Carr|Carr_Tail] table de booleens des carrés sur la verticale*/
/*Toujours initialiser Init à 0*/

calcul_somme_Taille_carre_sur_vert([Carr],[T_Head],Init, Res) :-
	CurT #= Carr * T_Head,
	Resp #= Init + CurT,
	Res #= Resp.

calcul_somme_Taille_carre_sur_vert([Carr|Carr_Tail],[T_Head| T_Tail], Init, Res) :-
	CurT #= Carr * T_Head,
	Resp #= Init + CurT,
	Initp #= Resp,
	calcul_somme_Taille_carre_sur_vert(Carr_Tail,T_Tail,Initp, Respp),
	Res #= Respp.
	
/******/

somme_tailles_carr_vert_inf_granCarre(GrandCarre,GrandCarre, _, _):- !.
	
somme_tailles_carr_vert_inf_granCarre(Vert,GrandCarre, T, Xs):-
	carres_sur_verticale(Vert ,Xs, T, Carr),
	calcul_somme_Taille_carre_sur_vert(Carr,T, 0, Res),
	Res #=< GrandCarre,
	Vertp #= Vert + 1,
	somme_tailles_carr_vert_inf_granCarre(Vertp,GrandCarre, T, Xs).
	



solveRed(Num, Xs, Ys) :-
	data(Num, GrandCarre, PetitsCarres),
	length(PetitsCarres, Size),
	length(Xs, Size),
	length(Ys, Size),
	fd_domain(Xs, 0,GrandCarre),
	fd_domain(Ys, 0,GrandCarre),
	non_chevauchement_L(Xs,Ys,PetitsCarres),
	inclus_dans_grand_carre(GrandCarre, PetitsCarres, Xs, Ys),
	somme_tailles_carr_vert_inf_granCarre(0,GrandCarre, PetitsCarres, Xs),
	somme_tailles_carr_vert_inf_granCarre(0,GrandCarre, PetitsCarres, Ys),
	fd_labeling(Xs),
	fd_labeling(Ys),
	printsol('modeleRedondant.txt', Xs, Ys, PetitsCarres).


/**backtrack*/
solveRedBack(Num, Xs, Ys, B) :-
	data(Num, GrandCarre, PetitsCarres),
	length(PetitsCarres, Size),
	length(Xs, Size),
	length(Ys, Size),
	fd_domain(Xs, 0,GrandCarre),
	fd_domain(Ys, 0,GrandCarre),
	non_chevauchement_L(Xs,Ys,PetitsCarres),
	inclus_dans_grand_carre(GrandCarre, PetitsCarres, Xs, Ys),
	somme_tailles_carr_vert_inf_granCarre(0,GrandCarre, PetitsCarres, Xs),
	somme_tailles_carr_vert_inf_granCarre(0,GrandCarre, PetitsCarres, Ys),
	fd_labeling(Xs, [backtracks(B)]),
	fd_labeling(Ys, [backtracks(B)]),
	printsol('modeleRedondantBacktrack.txt', Xs, Ys, PetitsCarres).

/**labeling*/
solveRedlabeling(Num, Xs, Ys,Goal,NbSol,B) :-
	data(Num, GrandCarre, PetitsCarres),
	length(PetitsCarres, Size),
	length(Xs, Size),
	length(Ys, Size),
	fd_domain(Xs, 0,GrandCarre),
	fd_domain(Ys, 0,GrandCarre),
	non_chevauchement_L(Xs,Ys,PetitsCarres),
	inclus_dans_grand_carre(GrandCarre, PetitsCarres, Xs, Ys),
	somme_tailles_carr_vert_inf_granCarre(0,GrandCarre, PetitsCarres, Xs),
	somme_tailles_carr_vert_inf_granCarre(0,GrandCarre, PetitsCarres, Ys),
	labeling(Xs, Ys, Goal, minmin, B, NbSol),
	printsol('modeleRedondantlabeling.txt', Xs, Ys, PetitsCarres).

/*************************End Contraintes redondantes*****************************/



