module TestSobol

	using FactCheck,DataFrames,Lazy,MomentOpt

	# initial value
	pb    = Dict("p1" => [1.0;-2;2] , "p2" => [-1.0;-2;2] ) 
	moms = DataFrame(name=["mu1";"mu2"],value=[0.0;0.0],weight=rand(2))
	mprob = @> MomentOpt.MProb() MomentOpt.addSampledParam!(pb) MomentOpt.addMoment!(moms) MomentOpt.addEvalFunc!(MomentOpt.objfunc_norm);

	# compute the slices
	sl = MomentOpt.sobolsearch(mprob,500);

	# find the min value

	best=sl[1]
	for e in sl
		if e.value < best.value
			best=e
		end
	end

	sl = MomentOpt.sobolWeightedSearch(mprob,500);

	using PyPlot

	figure("sobolWeightedSearch")
	plot(sl[:X][:,1],sl[:X][:,2],"o")


	# subplot(231)
	# r = MomentOpt.get(sl, :m1 , :m1); PyPlot.plot(r[:x],r[:y],".")
	# subplot(232)
	# r = MomentOpt.get(sl, :m1 , :m2); PyPlot.plot(r[:x],r[:y],".")
	# subplot(233)
	# r = MomentOpt.get(sl, :m1 , :value); PyPlot.plot(r[:x],r[:y],".")
	# subplot(234)
	# r = MomentOpt.get(sl, :m2 , :m1); PyPlot.plot(r[:x],r[:y],".")
	# subplot(235)
	# r = MomentOpt.get(sl, :m2 , :m2); PyPlot.plot(r[:x],r[:y],".")
	# subplot(236)
	# r = MomentOpt.get(sl, :m2 , :value); PyPlot.plot(r[:x],r[:y],".")


	# generate a sobol sequence
	using Sobol
	sq = SobolSeq(2)
	S = [ next(sq) for k in 1:10000]
	S1 = [ x[1] for x in S]
	S2 = [ x[2] for x in S]

	# define a simple objective function
	mu = [1.0,1.0]
	C  = [0.5 0.3; 0.1 0.8]
	R = MomentOpt.MvNormal(mu, C)
	function f(x)
	 x1 = quantile(MomentOpt.Normal(),x[1])
	 x2 = quantile(MomentOpt.Normal(),x[2]) 
	 return MomentOpt.pdf(R,[x1,x2])
	end

	V = map(f,S)

	figure("sobol evaluations")
	PyPlot.scatter(S1,S2,c=V)

	# how to decide to add new points?

	# compute 2 things at each point: 
	# - a notion of density
	# - a notion of level

	# evaluate the first 100 points
	# E = V*0
	# E[1:100] = 1

	# # given the evaluated set, compute the local level and densities
	# dim = 2 # ?
	# N = sum(E)^(1/dim)
 #    h = 1/N # distance between points

 #    # for each point, we compute a local average of the value
 #    K  = length(S)
 #    S1e = S1[E .== 1] 
 #    S2e = S2[E .== 1] 
 #    Se  = S[E .== 1] 
 #    Ve  = V[E .== 1] 
 #    Sa = [S1 S2]


    # take 100 evaluated points and compute V and D 
    # for them and average.

    # add a point to Sobol list, check if it should be evaluated
    # randomly pick an unevaluated point from the past check if it should be evaluated

    # pick a new evaluation point, based on previously computed.
 #    sq   = SobolSeq(2)
 #    P0 = [ Dict(:p => next(sq) , :value => 0) for k in 1:10]

 #    # evaluate 10 points:
 #    P1 = map(P0) do p
 #    	p[:value] = f(p[:p])
 #    	p
 #    end

 #    # get an approx distance
	# N = length(P1)^(1/dim)
 #    h = 1/N # distance between points


 #    # 1 find closest evalued points
 #    function findClose(s,P)
 #    	best_dist = Inf
 #    	sbest = P[1]
	#     for s2 in P
	#     	d = sum( (s.-s2[:p]).^2)
	#     	if (  d > 0 ) & ( d < best_dist )
	#     		sbest = s2
	#     		best_dist = d
	#     	end
	#     end
	# 	return (sbest,best_dist)
	# end




 #    # d = [ exp(  - sum( ( S[i] .- ss ).^2 )/h^2 ) for ss in Se ]




 #    for i in 1:K
 #    	w = [ exp(  - sum( ( S[i] .- ss ).^2 )/h^2 ) for ss in Se ]
 #    	V_hat = sum ( w .* Ve) ./ sum( w )
 #    	w = [ exp(  - sum( ( S[i] .- ss ).^2 )/h^2 ) for ss in S ]
 #    	D_hat = sum( w .* E) ./ sum (w)
 #    end


    # compute the density
 









end # module 






