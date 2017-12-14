from monosat import *

graph = Graph()

n1 = graph.addNode()
n2 = graph.addNode()
n3 = graph.addNode()
n4 = graph.addNode()

edge12 = graph.addEdge(n1, n2, 3)
edge13 = graph.addEdge(n1, n3, 1)
edge34 = graph.addEdge(n3, n4, 1)

Assert(graph.reaches(n1, n4))

result = Solve()

if result:
    print("SAT")
else:
    print("UNSAT")

Assert(graph.reaches(n4, n1))

result = Solve()

if result:
    print("SAT")
else:
    print("UNSAT")
