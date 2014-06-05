

# main dev routine for Mopt.jl

cd("/Users/florianoswald/git/MOpt.jl/")

include("src/mopt.jl")

# run tests
include("test/test_mopt.jl")





# workbench
# =========


# define a Test objective function
function Testobj(x::Dict,mom::DataFrame,whichmom::Array{ASCIIString,1})

	t0 = time()
	mm = copy(mom)
	nm = names(mm)

	# perform computations of the objective function
	# and add the resulting model moments
	mm = cbind(mm,[x["a"] + x["b"] + i for i=1:nrow(mm)])
	names!(mm,[nm, :model])

	# subset to required moments only
	mm = mm[findin(mm[:name],whichmom),:]

	# compute distance
	v = sum((mm[:data].-mm[:model]).^2)

	# status
	status = 1

	# time out
	t0 = time() - t0

	# return a tuple
	(v,t0,status)
end


# get a parameter vector
p = ["a" => 3.1 , "b" => 4.9]

# get some moments
mom = Mopt.DataFrame(data=rand(3),sd=rand(3)*0.1,name=["alpha","beta","gamma"])

# which pars to sample
whichpar = Mopt.DataFrame(name=["a","b"],lb=[-1,0],ub=[2,2])

# initiate
M = Mopt.Moptim(p,whichpar,Testobj,mom; moments_to_use=["alpha"]);

# show
M

# evaluate objective on all chains
Mopt.evaluateObjective(M)

# show Chain data
Mopt.showChainData(M)

# this will happen under the hood:

# update each chain with a new param value
p1 = { i => ["a" => 3.1 + rand() , "b" => 4.9 + rand()] for i=1:M.N}
Mopt.updateAllChains!(M,p1)


Mopt.evaluateObjective(M)
# show Chain data
Mopt.showChainData(M)


