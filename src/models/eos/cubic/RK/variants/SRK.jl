#just a function, no struct
function SRK(components::Vector{String}; idealmodel=BasicIdeal,
    mixing = vdW1fRule,
    userlocations=String[], 
    ideal_userlocations=String[],
    alpha_userlocations = String[],
    mixing_userlocations = String[],
     verbose=false)

     return RK(components;
     idealmodel = idealmodel,
     alpha = SoaveAlpha,
     mixing=mixing,
     ideal_userlocations = ideal_userlocations,
     alpha_userlocations = alpha_userlocations,
     mixing_userlocations = mixing_userlocations,
     verbose = verbose)
end
export SRK