factorial(0,1):-!.
factorial(N,Res) :- N1 is N-1, factorial(N1, Resp), Res is N * Resp. 
